package portfolio.example.im_cc.controllers.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import portfolio.example.im_cc.models.AppUser;
import portfolio.example.im_cc.models.CharacterSave;
import portfolio.example.im_cc.repositories.AppUserRepository;
import portfolio.example.im_cc.repositories.CharacterSaveRepository;
import tools.jackson.databind.ObjectMapper;

import java.io.IOException;
import java.security.Principal;
import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.Map;

@RestController
@RequestMapping("/api/character")
public class CharacterSaveApiController {

    private static final long MAX_IMAGE_BYTES = 5L * 1024 * 1024; // 5 MB
    private static final String CHARS = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
    private static final int CODE_LEN = 6;
    private static final SecureRandom RNG = new SecureRandom();

    @Autowired private CharacterSaveRepository repo;
    @Autowired private AppUserRepository users;
    @Autowired private ObjectMapper objectMapper;
    /**
     * Save a character. Body is raw JSON: {"ccm": {...}, "edits": {...}}.
     * Optional query param ?code=XXXXXX to overwrite an existing save.
     */
    @PostMapping("/save")
    public ResponseEntity<Map<String, String>> save(
            @RequestBody String data,
            @RequestParam(required = false) String code, Principal principal) {
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
     * Load a character by code. Returns the raw saved JSON.
     */
    @GetMapping("/load/{code}")
    public ResponseEntity<String> load(@PathVariable String code) {
        return repo.findBySaveCode(code.toUpperCase())
                .map(cs -> ResponseEntity.ok(cs.getData()))
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
        String ct = file.getContentType();
        if (ct == null || !ct.startsWith("image/"))
            return ResponseEntity.badRequest().body(Map.of("error", "File must be an image"));

        AppUser me = currentUser(principal);
        var cs = repo.findBySaveCode(code.toUpperCase()).orElse(null);
        if (cs == null) return ResponseEntity.notFound().build();
        if (cs.getOwner() == null || me == null || !cs.getOwner().getId().equals(me.getId()))
            return ResponseEntity.status(403).build();

        cs.setImageData(file.getBytes());
        cs.setImageContentType(ct);
        repo.save(cs);
        return ResponseEntity.ok(Map.of("imageUrl", "/api/character/" + cs.getSaveCode() + "/image"));
    }

    @GetMapping("/{code}/image")
    public ResponseEntity<byte[]> getImage(@PathVariable String code) {
        return repo.findBySaveCode(code.toUpperCase())
                .filter(cs -> cs.getImageData() != null)
                .map(cs -> ResponseEntity.ok()
                        .contentType(MediaType.parseMediaType(cs.getImageContentType()))
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
}
