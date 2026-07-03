package portfolio.example.im_cc.controllers.api;

import tools.jackson.databind.JsonNode;
import tools.jackson.databind.ObjectMapper;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import portfolio.example.im_cc.models.AppUser;
import portfolio.example.im_cc.models.enums.SourceBook;
import portfolio.example.im_cc.repositories.AppUserRepository;
import portfolio.example.im_cc.repositories.characterwizard.CharacterSaveRepository;
import portfolio.example.im_cc.repositories.characterwizard.FactionRepository;
import portfolio.example.im_cc.repositories.characterwizard.OriginRepository;
import portfolio.example.im_cc.repositories.characterwizard.RoleRepository;

import java.security.Principal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/me")
public class MeController {

    private final AppUserRepository appUserRepository;
    private final CharacterSaveRepository repo;
    private final OriginRepository origins;
    private final FactionRepository factions;
    private final RoleRepository roles;
    private final ObjectMapper objectMapper;

    public MeController(AppUserRepository appUserRepository, CharacterSaveRepository repo,
                        OriginRepository origins, FactionRepository factions, RoleRepository roles,
                        ObjectMapper objectMapper) {
        this.appUserRepository = appUserRepository;
        this.repo = repo;
        this.origins = origins;
        this.factions = factions;
        this.roles = roles;
        this.objectMapper = objectMapper;
    }

    public record CharacterSummary(
            String code,
            String name,
            String originName,
            String factionName,
            String roleName,
            String originSourceBook,
            String factionSourceBook,
            String roleSourceBook,
            LocalDateTime updatedAt
    ) {}

    @GetMapping("/characters")
    public List<CharacterSummary> myCharacters(Principal principal) {
        AppUser me = appUserRepository.findByEmail(principal.getName()).orElseThrow();
        return repo.findByOwnerOrderByUpdatedAtDesc(me).stream()
                .map(cs -> {
                    String originName = null, factionName = null, roleName = null;
                    String originSb = null, factionSb = null, roleSb = null;
                    try {
                        JsonNode root = objectMapper.readTree(cs.getData());
                        JsonNode ccm = root.path("ccm");
                        originName  = ccm.path("_originName").asText(null);
                        factionName = ccm.path("_factionName").asText(null);
                        roleName    = ccm.path("_roleName").asText(null);
                        long originId  = ccm.path("originId").asLong(0);
                        long factionId = ccm.path("factionId").asLong(0);
                        long roleId    = ccm.path("roleId").asLong(0);
                        if (originId  > 0) originSb  = sbName(origins.findById(originId).map(o -> o.getSourceBook()).orElse(null));
                        if (factionId > 0) factionSb = sbName(factions.findById(factionId).map(f -> f.getSourceBook()).orElse(null));
                        if (roleId    > 0) roleSb    = sbName(roles.findById(roleId).map(r -> r.getSourceBook()).orElse(null));
                    } catch (Exception ignored) {}
                    return new CharacterSummary(cs.getSaveCode(), cs.getCharacterName(),
                            originName, factionName, roleName, originSb, factionSb, roleSb, cs.getUpdatedAt());
                })
                .toList();
    }

    private String sbName(SourceBook sb) {
        return sb == null ? null : sb.name();
    }

    @GetMapping
    public ResponseEntity<?> me(Principal principal) {
        if (principal == null) return ResponseEntity.status(401).build();
        AppUser me = appUserRepository.findByEmail(principal.getName()).orElseThrow();
        var body = new java.util.HashMap<String, Object>();
        body.put("id", me.getId());
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
