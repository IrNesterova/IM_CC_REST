package portfolio.example.im_cc.controllers.api;

import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import portfolio.example.im_cc.models.AppUser;
import portfolio.example.im_cc.models.characterwizard.CharacterSave;
import portfolio.example.im_cc.repositories.AppUserRepository;
import portfolio.example.im_cc.repositories.characterwizard.CharacterSaveRepository;
import tools.jackson.databind.ObjectMapper;

import java.io.IOException;
import java.security.Principal;
import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.Map;
import java.util.Set;

@RestController
@RequestMapping("/api/character")
public class CharacterSaveApiController {

    private static final long MAX_IMAGE_BYTES = 5L * 1024 * 1024; // 5 MB
    private static final Set<String> ALLOWED_IMAGE_TYPES = Set.of("image/png", "image/jpeg", "image/webp");
    private static final String CHARS = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
    private static final int CODE_LEN = 6;
    private static final SecureRandom RNG = new SecureRandom();

    private final CharacterSaveRepository repo;
    private final AppUserRepository users;
    private final ObjectMapper objectMapper;

    public CharacterSaveApiController(CharacterSaveRepository repo, AppUserRepository users, ObjectMapper objectMapper) {
        this.repo = repo;
        this.users = users;
        this.objectMapper = objectMapper;
    }

    /**
     * Save a character. Body is raw JSON: {"ccm": {...}, "edits": {...}}.
     * Optional query param ?code=XXXXXX to overwrite an existing save.
     */
    @PostMapping("/save")
    public ResponseEntity<Map<String, String>> save(
            @RequestBody String data,
            @RequestParam(required = false) String code, Principal principal) {
        if (!SavedJson.isObject(objectMapper, data)) {
            return ResponseEntity.badRequest().body(Map.of("error", "Body must be a JSON object"));
        }
        AppUser me = currentUser(principal);

        CharacterSave cs = null;
        if (code != null && !code.isBlank()) {
            cs = repo.findBySaveCode(code.toUpperCase()).orElse(null);
        }
        if (cs != null && cs.getOwner() != null){
            if (me == null || !cs.getOwner().getId().equals(me.getId())){
                return ResponseEntity.status(403).body(Map.of("error", "Это не ваш персонаж!"));
            }
        }
        if (cs == null) {
            String newCode;
            int attempts = 0;
            do {
                newCode = generateCode();
                if (++attempts > 30) throw new RuntimeException("Could not generate unique save code");
            } while (repo.findBySaveCode(newCode).isPresent());
            cs = new CharacterSave();
            cs.setSaveCode(newCode);
            cs.setCreatedAt(LocalDateTime.now());
            cs.setOwner(me);
        }

        cs.setData(data);
        cs.setUpdatedAt(LocalDateTime.now());
        cs.setCharacterName(extractName(data));
        repo.save(cs);

        return ResponseEntity.ok(Map.of("code", cs.getSaveCode()));
    }

    private AppUser currentUser(Principal p){
        return p == null ? null : users.findByEmail(p.getName()).orElse(null);
    }

    private String extractName(String data){
        try {
            var root = objectMapper.readTree(data);
            var edited = root.path("edits").path("characterName").asString("");
            if (!edited.isBlank()) return edited;
            return root.path("ccm").path("characterName").asString(null);
        } catch (Exception e){
            return null;
        }
    }

    /**
     * Load a character by code. Returns the raw saved JSON, always as application/json so a
     * browser never renders saved content as HTML.
     */
    @GetMapping("/load/{code}")
    public ResponseEntity<String> load(@PathVariable String code) {
        return repo.findBySaveCode(code.toUpperCase())
                .map(cs -> SavedJson.response(cs.getData()))
                .orElse(ResponseEntity.notFound().build());
    }

    private String generateCode() {
        StringBuilder sb = new StringBuilder(CODE_LEN);
        for (int i = 0; i < CODE_LEN; i++) sb.append(CHARS.charAt(RNG.nextInt(CHARS.length())));
        return sb.toString();
    }

    @PostMapping("/{code}/image")
    public ResponseEntity<?> uploadImage(@PathVariable String code,
                                         @RequestParam("file") MultipartFile file,
                                         Principal principal) throws IOException {
        if (file.getSize() > MAX_IMAGE_BYTES)
            return ResponseEntity.badRequest().body(Map.of("error", "File too large (max 5 MB)"));

        AppUser me = currentUser(principal);
        var cs = repo.findBySaveCode(code.toUpperCase()).orElse(null);
        if (cs == null) return ResponseEntity.notFound().build();
        if (cs.getOwner() == null || me == null || !cs.getOwner().getId().equals(me.getId()))
            return ResponseEntity.status(403).build();

        // Trust the file's bytes, not the client's Content-Type: SVG and HTML could carry scripts.
        byte[] bytes = file.getBytes();
        String type = detectImageType(bytes);
        if (type == null)
            return ResponseEntity.badRequest().body(Map.of("error", "Image must be PNG, JPEG or WebP"));

        cs.setImageData(bytes);
        cs.setImageContentType(type);
        repo.save(cs);
        return ResponseEntity.ok(Map.of("imageUrl", "/api/character/" + cs.getSaveCode() + "/image"));
    }

    @GetMapping("/{code}/image")
    public ResponseEntity<byte[]> getImage(@PathVariable String code) {
        // Images stored before the PNG/JPEG/WebP check may be SVG; those are no longer served.
        return repo.findBySaveCode(code.toUpperCase())
                .filter(cs -> cs.getImageData() != null && ALLOWED_IMAGE_TYPES.contains(cs.getImageContentType()))
                .map(cs -> ResponseEntity.ok()
                        .contentType(MediaType.parseMediaType(cs.getImageContentType()))
                        .header("Content-Security-Policy", "default-src 'none'; sandbox")
                        .body(cs.getImageData()))
                .orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{code}")
    public ResponseEntity<?> delete(@PathVariable String code, java.security.Principal principal) {
        AppUser me = currentUser(principal);
        var cs = repo.findBySaveCode(code.toUpperCase()).orElse(null);
        if (cs == null) return ResponseEntity.notFound().build();
        if (cs.getOwner() == null || me == null || !cs.getOwner().getId().equals(me.getId()))
            return ResponseEntity.status(403).build();
        repo.delete(cs);
        return ResponseEntity.noContent().build();
    }

    /** Returns the image MIME type detected from the file's magic bytes, or null if not PNG, JPEG or WebP. */
    static String detectImageType(byte[] b) {
        if (b == null) return null;
        if (b.length >= 8 && (b[0] & 0xFF) == 0x89 && b[1] == 'P' && b[2] == 'N' && b[3] == 'G'
                && b[4] == 0x0D && b[5] == 0x0A && b[6] == 0x1A && b[7] == 0x0A) return "image/png";
        if (b.length >= 3 && (b[0] & 0xFF) == 0xFF && (b[1] & 0xFF) == 0xD8 && (b[2] & 0xFF) == 0xFF) return "image/jpeg";
        if (b.length >= 12 && b[0] == 'R' && b[1] == 'I' && b[2] == 'F' && b[3] == 'F'
                && b[8] == 'W' && b[9] == 'E' && b[10] == 'B' && b[11] == 'P') return "image/webp";
        return null;
    }
}
