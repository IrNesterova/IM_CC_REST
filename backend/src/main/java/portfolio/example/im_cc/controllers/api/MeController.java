package portfolio.example.im_cc.controllers.api;

import tools.jackson.databind.JsonNode;
import tools.jackson.databind.ObjectMapper;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import portfolio.example.im_cc.models.AppUser;
import portfolio.example.im_cc.repositories.AppUserRepository;
import portfolio.example.im_cc.repositories.CharacterSaveRepository;

import java.security.Principal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/me")
public class MeController {

    private final AppUserRepository appUserRepository;
    private final CharacterSaveRepository repo;
    private final ObjectMapper objectMapper;

    public MeController(AppUserRepository appUserRepository, CharacterSaveRepository repo, ObjectMapper objectMapper) {
        this.appUserRepository = appUserRepository;
        this.repo = repo;
        this.objectMapper = objectMapper;
    }

    public record CharacterSummary(
            String code,
            String name,
            String originName,
            String factionName,
            String roleName,
            LocalDateTime updatedAt
    ) {}

    @GetMapping("/characters")
    public List<CharacterSummary> myCharacters(Principal principal) {
        AppUser me = appUserRepository.findByEmail(principal.getName()).orElseThrow();
        return repo.findByOwnerOrderByUpdatedAtDesc(me).stream()
                .map(cs -> {
                    String origin = null, faction = null, role = null;
                    try {
                        JsonNode root = objectMapper.readTree(cs.getData());
                        JsonNode ccm = root.path("ccm");
                        origin  = ccm.path("_originName").asText(null);
                        faction = ccm.path("_factionName").asText(null);
                        role    = ccm.path("_roleName").asText(null);
                    } catch (Exception ignored) {}
                    return new CharacterSummary(cs.getSaveCode(), cs.getCharacterName(),
                            origin, faction, role, cs.getUpdatedAt());
                })
                .toList();
    }

    @GetMapping
    public ResponseEntity<?> me(Principal principal) {
        if (principal == null) return ResponseEntity.status(401).build();
        AppUser me = appUserRepository.findByEmail(principal.getName()).orElseThrow();
        var body = new java.util.HashMap<String, Object>();
        body.put("email", me.getEmail());
        body.put("displayName", me.getDisplayName() != null ? me.getDisplayName() : me.getEmail());
        if (me.getWebhookUrl() != null) body.put("webhookUrl", me.getWebhookUrl());
        return ResponseEntity.ok(body);
    }

    @PutMapping("/webhook")
    public ResponseEntity<?> saveWebhook(@RequestBody Map<String, String> body, Principal principal) {
        if (principal == null) return ResponseEntity.status(401).build();
        AppUser me = appUserRepository.findByEmail(principal.getName()).orElseThrow();
        me.setWebhookUrl(body.get("webhookUrl"));
        appUserRepository.save(me);
        return ResponseEntity.ok().build();
    }
}
