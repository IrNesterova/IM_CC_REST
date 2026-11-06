package portfolio.example.im_cc.services;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import portfolio.example.im_cc.models.AppUser;
import portfolio.example.im_cc.models.characterwizard.CharacterSave;
import portfolio.example.im_cc.models.enums.SourceBook;
import portfolio.example.im_cc.models.lobby.GameRoom;
import portfolio.example.im_cc.models.lobby.GameRoomMember;
import portfolio.example.im_cc.repositories.characterwizard.CharacterSaveRepository;
import portfolio.example.im_cc.repositories.lobby.GameRoomMemberRepository;
import portfolio.example.im_cc.repositories.lobby.GameRoomRepository;

import java.security.SecureRandom;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.UUID;

import static portfolio.example.im_cc.services.LobbyException.Reason.*;


@Service
@RequiredArgsConstructor
public class LobbyService {
    private final GameRoomRepository rooms;
    private final GameRoomMemberRepository members;
    private final CharacterSaveRepository characterSaves;

    private static final char[] CODE_ALPHABET = "ABCDEFGHJKMNPQRSTUVWXYZ23456789".toCharArray();
    private static final int CODE_LENGTH = 6;
    private final SecureRandom random = new SecureRandom();
    private final ApplicationEventPublisher events;   // к остальным final-полям

    @Transactional
    public GameRoom createRoom(AppUser gm, String name) {
        GameRoom room = new GameRoom(name, generateUniqueJoinCode(), gm);
        rooms.save(room);
        // GM also gets a member row (role = GM) so roster/presence is one plain query.
        members.save(new GameRoomMember(room, gm, GameRoomMember.MemberRole.GM));
        return room;
    }

    @Transactional
    public GameRoomMember joinByCode(String code, AppUser user) {
        GameRoom room = rooms.findByJoinCode(code)
                .orElseThrow(() -> new LobbyException(ROOM_NOT_FOUND, "No room for code " + code));

        boolean isGm = room.getGm().getId().equals(user.getId());
        Optional<GameRoomMember> existing = members.findByRoomIdAndUserId(room.getId(), user.getId());

        // Returning member: the row stays in the campaign history when they leave, so rejoining
        // reactivates it instead of being a silent no-op that kept them locked out.
        if (existing.isPresent()) {
            GameRoomMember member = existing.get();
            if (member.getStatus() == GameRoomMember.MemberStatus.KICKED) {
                throw new LobbyException(ROOM_CLOSED, "You were removed from this room");
            }
            if (member.getStatus() == GameRoomMember.MemberStatus.LEFT) {
                member.setStatus(GameRoomMember.MemberStatus.ACTIVE);
                events.publishEvent(new LobbyEvent.MemberJoined(
                        room.getId(), user.getId(), user.getDisplayName(), member.getRole()));
            }
            return member;
        }

        // Access gate: a room that is no longer in LOBBY blocks NEW players; the GM and existing members pass.
        if (!room.getStatus().equals(GameRoom.RoomStatus.LOBBY) && !isGm) {
            throw new LobbyException(ROOM_CLOSED, "Room is closed to new players");
        }

        GameRoomMember member = new GameRoomMember(room, user, GameRoomMember.MemberRole.PLAYER);
        GameRoomMember saved;
        try {
            saved = members.save(member);

        } catch (DataIntegrityViolationException race) {
            // Two concurrent joins both passed the lookup above (classic TOCTOU).
            // The DB unique constraint uq_room_user is the REAL guard — the loser lands here.
            // Recover by returning the row the winner inserted instead of surfacing an error.
            return members.findByRoomIdAndUserId(room.getId(), user.getId())
                    .orElseThrow(() -> race);
        }
        events.publishEvent(new LobbyEvent.MemberJoined(
                room.getId(), user.getId(), user.getDisplayName(), GameRoomMember.MemberRole.PLAYER));
        return saved;
    }

    /** Active members and the GM may see a room; members who left or were kicked may not. */
    private boolean canAccess(UUID roomId, Long userId) {
        return members.existsByRoomIdAndUserIdAndStatus(roomId, userId, GameRoomMember.MemberStatus.ACTIVE)
                || rooms.findById(roomId)
                .map(r -> r.getGm().getId().equals(userId))
                .orElse(false);
    }

    @Transactional
    public List<GameRoomMember> roster(UUID roomId, Long requesterId) {
        if (!canAccess(roomId, requesterId)) {
            // ROOM_NOT_FOUND, а не FORBIDDEN: не палим даже сам факт, что комната существует
            throw new LobbyException(ROOM_NOT_FOUND, "Not a member of room " + roomId);
        }
        return members.findRosterByRoomId(roomId);
    }

    @Transactional
    public void leave(UUID roomId, AppUser user) {
        // Soft leave: membership stays in the campaign history, just flips to LEFT.
        // Dirty checking flushes the change at transaction commit — no explicit save needed.
        members.findByRoomIdAndUserId(roomId, user.getId()).ifPresent(m -> {
            m.setStatus(GameRoomMember.MemberStatus.LEFT);
            events.publishEvent(new LobbyEvent.MemberLeft(roomId, user.getId()));
        });
    }

    private String generateUniqueJoinCode() {
        for (int attempt = 0; attempt < 10; attempt++) {
            String code = randomCode();
            if (!rooms.existsByJoinCode(code)) {
                return code;
            }
        }
        throw new IllegalStateException("Could not generate a unique join code after 10 tries");
    }

    public List<GameRoom> getMyRooms(AppUser user) {
        return members.findByUserIdAndStatusFetchRoom(user.getId(), GameRoomMember.MemberStatus.ACTIVE)
                .stream()
                .map(GameRoomMember::getRoom)
                .filter(r -> r.getStatus() != GameRoom.RoomStatus.CLOSED)
                .toList();
    }

    @Transactional
    public GameRoom getRoom(UUID roomId, Long requesterId) {
        GameRoom room = rooms.findById(roomId)
                .orElseThrow(() -> new LobbyException(ROOM_NOT_FOUND, "Room " + roomId + " not found"));
        if (!canAccess(roomId, requesterId)) throw new LobbyException(ROOM_NOT_FOUND, "Not a member of room " + roomId);
        return room;
    }

    @Transactional
    public GameRoom changeStatus(UUID roomId, AppUser gm, GameRoom.RoomStatus newStatus) {
        GameRoom room = rooms.findById(roomId)
                .orElseThrow(() -> new LobbyException(ROOM_NOT_FOUND, "Room " + roomId + " not found"));
        if (!room.getGm().getId().equals(gm.getId())) {
            throw new LobbyException(NOT_GM, "Only the GM can change room status");
        }
        room.setStatus(newStatus);
        events.publishEvent(new LobbyEvent.RoomStatusChanged(roomId, newStatus == GameRoom.RoomStatus.LOBBY));
        return room;
    }

    @Transactional
    public void selectCharacter(UUID roomId, AppUser user, String characterCode) {
        GameRoomMember member = members.findByRoomIdAndUserId(roomId, user.getId())
                .filter(m -> m.getStatus() == GameRoomMember.MemberStatus.ACTIVE)
                .orElseThrow(() -> new LobbyException(ROOM_NOT_FOUND, "Not a member of room " + roomId));
        CharacterSave character = characterSaves.findBySaveCode(characterCode == null ? "" : characterCode.toUpperCase())
                .orElseThrow(() -> new LobbyException(MEMBER_NOT_FOUND, "Character " + characterCode + " not found"));
        // Characters saved without an account have no owner and cannot be claimed by anyone.
        if (character.getOwner() == null || !character.getOwner().getId().equals(user.getId())) {
            throw new LobbyException(NOT_GM, "Character does not belong to you");
        }
        member.setCharacter(character);
        events.publishEvent(new LobbyEvent.CharacterSelected(
                roomId, user.getId(), character.getId(), character.getSaveCode(), character.getCharacterName()));
    }

    @Transactional
    public GameRoom updateWebhook(UUID roomId, AppUser gm, String webhookUrl) {
        GameRoom room = rooms.findById(roomId)
                .orElseThrow(() -> new LobbyException(NOT_GM, "Room " + roomId + " not found"));
        if (!room.getGm().getId().equals(gm.getId())) {
            throw new LobbyException(NOT_GM, "Only the GM can set the webhook");
        }
        room.setWebhookUrl(webhookUrl == null || webhookUrl.isBlank() ? null : webhookUrl.trim());
        return room;
    }

    @Transactional
    public GameRoom setPatron(UUID roomId, AppUser gm, String patronCode) {
        GameRoom room = rooms.findById(roomId)
                .orElseThrow(() -> new LobbyException(NOT_GM, "Room " + roomId + " not found"));
        if (!room.getGm().getId().equals(gm.getId())) {
            throw new LobbyException(NOT_GM, "Only the GM can set the patron");
        }
        room.setPatronSaveCode(patronCode == null || patronCode.isBlank() ? null : patronCode.toUpperCase().trim());
        events.publishEvent(new LobbyEvent.PatronChanged(roomId, room.getPatronSaveCode()));
        return room;
    }

    @Transactional
    public GameRoom updateSourceBooks(UUID roomId, AppUser gm, Set<SourceBook> sourceBooks) {
        GameRoom room = rooms.findById(roomId)
                .orElseThrow(() -> new LobbyException(NOT_GM, "Room " + roomId + " not found"));
        if (!room.getGm().getId().equals(gm.getId())) {
            throw new LobbyException(NOT_GM, "Only the GM can change source books");
        }
        // IM is always included regardless of what was sent
        Set<SourceBook> updated = new java.util.HashSet<>(sourceBooks);
        updated.add(SourceBook.IM);
        room.setAllowedSourceBooks(updated);
        events.publishEvent(new LobbyEvent.SourceBooksChanged(roomId, updated));
        return room;
    }

    private String randomCode() {
        StringBuilder sb = new StringBuilder(CODE_LENGTH);
        for (int i = 0; i < CODE_LENGTH; i++) {
            sb.append(CODE_ALPHABET[random.nextInt(CODE_ALPHABET.length)]);
        }
        return sb.toString();
    }

}
