package portfolio.example.im_cc.dto;

import portfolio.example.im_cc.models.enums.SourceBook;
import portfolio.example.im_cc.models.lobby.GameRoom;
import portfolio.example.im_cc.models.lobby.GameRoomMember;

import java.util.Set;
import java.util.UUID;

public class LobbyDTO {
    private LobbyDTO() {}

    public record CreateRoomRequest(String name) {}

    public record JoinRequest(String code) {}

    public record StatusChangeRequest(String status) {}

    public record CharacterSelectRequest(String characterCode) {}

    public record SourceBooksRequest(Set<String> sourceBooks) {}

    public record WebhookRequest(String webhookUrl) {}

    public record PatronRequest(String patronCode) {}

    // NOTE: gm is LAZY — do not touch r.getGm() here (LazyInitializationException after tx close).
    // gmId and allowedSourceBooks are safe: gmId is a plain @Column, allowedSourceBooks is EAGER.
    public record RoomResponse(UUID id, String name, String joinCode, boolean open, Long gmUserId, Set<String> sourceBooks, String webhookUrl, String patronCode) {
        public static RoomResponse from(GameRoom r) {
            Set<String> books = new java.util.HashSet<>();
            for (SourceBook sb : r.getAllowedSourceBooks()) books.add(sb.name());
            return new RoomResponse(r.getId(), r.getName(), r.getJoinCode(),
                    r.getStatus().equals(GameRoom.RoomStatus.LOBBY), r.getGmId(), books, r.getWebhookUrl(), r.getPatronSaveCode());
        }
    }

    // Safe to touch user + character here ONLY because the roster query join-fetches them
    // (findRosterByRoomId). That's the same fetch that also kills the N+1 on the member list.
    // originSourceBook/factionSourceBook/roleSourceBook are resolved by the controller and passed in.
    public record RosterEntry(
            Long userId, String username, GameRoomMember.MemberRole role, GameRoomMember.MemberStatus status,
            Long characterId, String characterCode, String characterName,
            String originSourceBook, String factionSourceBook, String roleSourceBook) {

        public static RosterEntry from(GameRoomMember m, String originSb, String factionSb, String roleSb) {
            var character = m.getCharacter();
            return new RosterEntry(
                    m.getUser().getId(),
                    m.getUser().getDisplayName(),
                    m.getRole(),
                    m.getStatus(),
                    character != null ? character.getId() : null,
                    character != null ? character.getSaveCode() : null,
                    character != null ? character.getCharacterName() : null,
                    originSb, factionSb, roleSb
            );
        }
    }
}
