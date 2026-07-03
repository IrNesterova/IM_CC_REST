package portfolio.example.im_cc.controllers.api;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import portfolio.example.im_cc.dto.LobbyDTO;
import portfolio.example.im_cc.models.AppUser;
import portfolio.example.im_cc.models.characterwizard.CharacterSave;
import portfolio.example.im_cc.models.enums.SourceBook;
import portfolio.example.im_cc.models.lobby.GameRoom;
import portfolio.example.im_cc.models.lobby.GameRoomMember;
import portfolio.example.im_cc.repositories.AppUserRepository;
import portfolio.example.im_cc.repositories.characterwizard.FactionRepository;
import portfolio.example.im_cc.repositories.characterwizard.OriginRepository;
import portfolio.example.im_cc.repositories.characterwizard.RoleRepository;
import portfolio.example.im_cc.services.LobbyService;
import tools.jackson.databind.JsonNode;
import tools.jackson.databind.ObjectMapper;

import java.security.Principal;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/rooms")
@RequiredArgsConstructor
public class LobbyController {
    private final LobbyService lobby;
    private final AppUserRepository users;
    private final OriginRepository origins;
    private final FactionRepository factions;
    private final RoleRepository roles;
    private final ObjectMapper objectMapper;

    @PostMapping
    public LobbyDTO.RoomResponse create(@RequestBody LobbyDTO.CreateRoomRequest req, Principal principal) {
        GameRoom room = lobby.createRoom(currentUser(principal), req.name());
        return LobbyDTO.RoomResponse.from(room);
    }

    @PostMapping("/join")
    public LobbyDTO.RoomResponse join(@RequestBody LobbyDTO.JoinRequest req, Principal principal) {
        GameRoomMember member = lobby.joinByCode(req.code(), currentUser(principal));
        return LobbyDTO.RoomResponse.from(member.getRoom());
    }

    @GetMapping("/{roomId}/roster")
    public List<LobbyDTO.RosterEntry> roster(@PathVariable UUID roomId, Principal principal) {
        return lobby.roster(roomId, currentUser(principal).getId()).stream()
                .map(m -> {
                    String originSb = null, factionSb = null, roleSb = null;
                    CharacterSave cs = m.getCharacter();
                    if (cs != null) {
                        try {
                            JsonNode ccm = objectMapper.readTree(cs.getData()).path("ccm");
                            long originId  = ccm.path("originId").asLong(0);
                            long factionId = ccm.path("factionId").asLong(0);
                            long roleId    = ccm.path("roleId").asLong(0);
                            if (originId  > 0) originSb  = origins.findById(originId).map(o -> o.getSourceBook().name()).orElse(null);
                            if (factionId > 0) factionSb = factions.findById(factionId).map(f -> f.getSourceBook().name()).orElse(null);
                            if (roleId    > 0) roleSb    = roles.findById(roleId).map(r -> r.getSourceBook().name()).orElse(null);
                        } catch (Exception ignored) {}
                    }
                    return LobbyDTO.RosterEntry.from(m, originSb, factionSb, roleSb);
                })
                .toList();
    }

    @PostMapping("/{roomId}/leave")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void leave(@PathVariable UUID roomId, Principal principal) {
        lobby.leave(roomId, currentUser(principal));
    }

    @GetMapping
    public List<LobbyDTO.RoomResponse> myRooms(Principal principal) {
        return lobby.getMyRooms(currentUser(principal)).stream()
                .map(LobbyDTO.RoomResponse::from)
                .toList();
    }

    @GetMapping("/{roomId}")
    public LobbyDTO.RoomResponse getRoom(@PathVariable UUID roomId, Principal principal) {
        return LobbyDTO.RoomResponse.from(lobby.getRoom(roomId, currentUser(principal).getId()));
    }

    @PatchMapping("/{roomId}/status")
    public LobbyDTO.RoomResponse changeStatus(@PathVariable UUID roomId,
                                              @RequestBody LobbyDTO.StatusChangeRequest req,
                                              Principal principal) {
        GameRoom.RoomStatus newStatus = GameRoom.RoomStatus.valueOf(req.status().toUpperCase());
        return LobbyDTO.RoomResponse.from(lobby.changeStatus(roomId, currentUser(principal), newStatus));
    }

    @PostMapping("/{roomId}/character")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void selectCharacter(@PathVariable UUID roomId,
                                @RequestBody LobbyDTO.CharacterSelectRequest req,
                                Principal principal) {
        lobby.selectCharacter(roomId, currentUser(principal), req.characterCode());
    }

    @PatchMapping("/{roomId}/webhook")
    public LobbyDTO.RoomResponse updateWebhook(@PathVariable UUID roomId,
                                               @RequestBody LobbyDTO.WebhookRequest req,
                                               Principal principal) {
        return LobbyDTO.RoomResponse.from(lobby.updateWebhook(roomId, currentUser(principal), req.webhookUrl()));
    }

    @PatchMapping("/{roomId}/patron")
    public LobbyDTO.RoomResponse setPatron(@PathVariable UUID roomId,
                                           @RequestBody LobbyDTO.PatronRequest req,
                                           Principal principal) {
        return LobbyDTO.RoomResponse.from(lobby.setPatron(roomId, currentUser(principal), req.patronCode()));
    }

    @PatchMapping("/{roomId}/source-books")
    public LobbyDTO.RoomResponse updateSourceBooks(@PathVariable UUID roomId,
                                                   @RequestBody LobbyDTO.SourceBooksRequest req,
                                                   Principal principal) {
        var sourceBooks = req.sourceBooks().stream()
                .map(SourceBook::valueOf)
                .collect(java.util.stream.Collectors.toSet());
        return LobbyDTO.RoomResponse.from(lobby.updateSourceBooks(roomId, currentUser(principal), sourceBooks));
    }

    private AppUser currentUser(Principal principal) {
        return users.findByEmail(principal.getName()).orElseThrow();
    }
}
