package portfolio.example.im_cc.controllers.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import portfolio.example.im_cc.models.CharacterSave;
import portfolio.example.im_cc.repositories.CharacterSaveRepository;

import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.Map;

@RestController
@RequestMapping("/api/character")
public class CharacterSaveApiController {

    private static final String CHARS = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
    private static final int CODE_LEN = 6;
    private static final SecureRandom RNG = new SecureRandom();

    @Autowired private CharacterSaveRepository repo;

    /**
     * Save a character. Body is raw JSON: {"ccm": {...}, "edits": {...}}.
     * Optional query param ?code=XXXXXX to overwrite an existing save.
     */
    @PostMapping("/save")
    public ResponseEntity<Map<String, String>> save(
            @RequestBody String data,
            @RequestParam(required = false) String code) {

        CharacterSave cs = null;
        if (code != null && !code.isBlank()) {
            cs = repo.findBySaveCode(code.toUpperCase()).orElse(null);
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
        }

        cs.setData(data);
        cs.setUpdatedAt(LocalDateTime.now());
        repo.save(cs);

        return ResponseEntity.ok(Map.of("code", cs.getSaveCode()));
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
}
