package portfolio.example.im_cc.controllers.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import portfolio.example.im_cc.models.patron.PatronSave;
import portfolio.example.im_cc.repositories.patron.PatronSaveRepository;
import tools.jackson.databind.ObjectMapper;

import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/patron")
public class PatronSaveApiController {

    private static final String CHARS = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
    private static final int CODE_LEN = 6;
    private static final SecureRandom RNG = new SecureRandom();

    @Autowired private PatronSaveRepository repo;
    @Autowired private ObjectMapper objectMapper;

    @PostMapping("/save")
    public ResponseEntity<Map<String, String>> save(
            @RequestBody String data,
            @RequestParam(required = false) String code) {

        PatronSave ps = null;
        if (code != null && !code.isBlank()) {
            ps = repo.findBySaveCode(code.toUpperCase()).orElse(null);
        }
        if (ps == null) {
            String newCode;
            int attempts = 0;
            do {
                newCode = generateCode();
                if (++attempts > 30) throw new RuntimeException("Could not generate unique patron save code");
            } while (repo.findBySaveCode(newCode).isPresent());
            ps = new PatronSave();
            ps.setSaveCode(newCode);
            ps.setCreatedAt(LocalDateTime.now());
        }

        ps.setData(data);
        ps.setUpdatedAt(LocalDateTime.now());
        ps.setPatronName(extractName(data));
        repo.save(ps);

        return ResponseEntity.ok(Map.of("code", ps.getSaveCode()));
    }

    @GetMapping("/load/{code}")
    public ResponseEntity<String> load(@PathVariable String code) {
        return repo.findBySaveCode(code.toUpperCase())
                .map(ps -> ResponseEntity.ok(ps.getData()))
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/preview/{code}")
    public ResponseEntity<Map<String, Object>> preview(@PathVariable String code) {
        return repo.findBySaveCode(code.toUpperCase()).map(ps -> {
            try {
                var root = objectMapper.readTree(ps.getData());
                Map<String, Object> out = new LinkedHashMap<>();
                out.put("code", ps.getSaveCode());
                out.put("patronName", str(root, "patronName"));
                out.put("factionText", str(root, "factionText"));
                out.put("dutyName", str(root, "dutyName"));
                out.put("dutyBoonName", str(root, "dutyBoonName"));
                out.put("motivationName", str(root, "motivationName"));
                out.put("demeanourName", str(root, "demeanourName"));
                out.put("payGradeName", str(root, "payGradeName"));
                var boons = root.path("boonNames");
                out.put("boonNames", boons.isArray()
                        ? objectMapper.convertValue(boons, List.class) : List.of());
                var liabs = root.path("liabilityNames");
                out.put("liabilityNames", liabs.isArray()
                        ? objectMapper.convertValue(liabs, List.class) : List.of());
                return ResponseEntity.ok(out);
            } catch (Exception e) {
                return ResponseEntity.ok(Map.<String, Object>of("code", ps.getSaveCode()));
            }
        }).orElse(ResponseEntity.notFound().build());
    }

    private String str(tools.jackson.databind.JsonNode node, String field) {
        var v = node.path(field);
        return v.isNull() || v.isMissingNode() ? null : v.asText();
    }

    private String extractName(String data) {
        try {
            return objectMapper.readTree(data).path("patronName").asString(null);
        } catch (Exception e) {
            return null;
        }
    }

    private String generateCode() {
        StringBuilder sb = new StringBuilder(CODE_LEN);
        for (int i = 0; i < CODE_LEN; i++) sb.append(CHARS.charAt(RNG.nextInt(CHARS.length())));
        return sb.toString();
    }
}