package portfolio.example.im_cc.services;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.context.ApplicationEventPublisher;
import portfolio.example.im_cc.models.AppUser;
import portfolio.example.im_cc.models.characterwizard.CharacterSave;
import portfolio.example.im_cc.models.lobby.GameRoom;
import portfolio.example.im_cc.models.lobby.GameRoomMember;
import portfolio.example.im_cc.models.lobby.GameRoomMember.MemberStatus;
import portfolio.example.im_cc.repositories.characterwizard.CharacterSaveRepository;
import portfolio.example.im_cc.repositories.lobby.GameRoomMemberRepository;
import portfolio.example.im_cc.repositories.lobby.GameRoomRepository;

import java.util.Optional;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

class LobbyServiceTest {

    private final GameRoomRepository rooms = mock(GameRoomRepository.class);
    private final GameRoomMemberRepository members = mock(GameRoomMemberRepository.class);
    private final CharacterSaveRepository saves = mock(CharacterSaveRepository.class);
    private final ApplicationEventPublisher events = mock(ApplicationEventPublisher.class);
    private final LobbyService lobby = new LobbyService(rooms, members, saves, events);

    private final UUID roomId = UUID.randomUUID();
    private AppUser gm;
    private AppUser player;
    private GameRoom room;

    private static AppUser user(long id) {
        AppUser u = new AppUser();
        u.setId(id);
        u.setDisplayName("user" + id);
        return u;
    }

    @BeforeEach
    void setUp() {
        gm = user(1);
        player = user(2);
        room = new GameRoom("Campaign", "ABC234", gm);
        room.setId(roomId);
        when(rooms.findByJoinCode("ABC234")).thenReturn(Optional.of(room));
        when(rooms.findById(roomId)).thenReturn(Optional.of(room));
    }

    private GameRoomMember membership(MemberStatus status) {
        GameRoomMember m = new GameRoomMember(room, player, GameRoomMember.MemberRole.PLAYER);
        m.setStatus(status);
        when(members.findByRoomIdAndUserId(roomId, 2L)).thenReturn(Optional.of(m));
        return m;
    }

    @Test
    void playerWhoLeftCanRejoin() {
        GameRoomMember m = membership(MemberStatus.LEFT);

        GameRoomMember result = lobby.joinByCode("ABC234", player);

        assertSame(m, result);
        assertEquals(MemberStatus.ACTIVE, m.getStatus());
        verify(events).publishEvent(any(LobbyEvent.MemberJoined.class));
        verify(members, never()).save(any());
    }

    @Test
    void playerWhoLeftCanRejoinEvenAfterTheGameStarted() {
        room.setStatus(GameRoom.RoomStatus.ACTIVE);
        GameRoomMember m = membership(MemberStatus.LEFT);

        lobby.joinByCode("ABC234", player);

        assertEquals(MemberStatus.ACTIVE, m.getStatus());
    }

    @Test
    void kickedPlayerCannotRejoin() {
        membership(MemberStatus.KICKED);

        LobbyException e = assertThrows(LobbyException.class, () -> lobby.joinByCode("ABC234", player));
        assertEquals(LobbyException.Reason.ROOM_CLOSED, e.getReason());
    }

    @Test
    void newPlayerCannotJoinAStartedRoom() {
        room.setStatus(GameRoom.RoomStatus.ACTIVE);
        when(members.findByRoomIdAndUserId(roomId, 2L)).thenReturn(Optional.empty());

        assertThrows(LobbyException.class, () -> lobby.joinByCode("ABC234", player));
        verify(members, never()).save(any());
    }

    @Test
    void playerWhoLeftLosesAccessToTheRoom() {
        when(members.existsByRoomIdAndUserIdAndStatus(roomId, 2L, MemberStatus.ACTIVE)).thenReturn(false);

        assertThrows(LobbyException.class, () -> lobby.getRoom(roomId, 2L));
        assertThrows(LobbyException.class, () -> lobby.roster(roomId, 2L));
    }

    @Test
    void gmAlwaysHasAccess() {
        assertSame(room, lobby.getRoom(roomId, 1L));
    }

    @Test
    void characterWithoutOwnerIsRejectedInsteadOfCrashing() {
        membership(MemberStatus.ACTIVE);
        CharacterSave anonymous = new CharacterSave();
        anonymous.setSaveCode("ANON01");
        when(saves.findBySaveCode("ANON01")).thenReturn(Optional.of(anonymous));

        LobbyException e = assertThrows(LobbyException.class, () -> lobby.selectCharacter(roomId, player, "anon01"));
        assertEquals(LobbyException.Reason.NOT_GM, e.getReason());
    }

    @Test
    void ownerCanSelectTheirCharacter() {
        GameRoomMember m = membership(MemberStatus.ACTIVE);
        CharacterSave mine = new CharacterSave();
        mine.setSaveCode("MINE01");
        mine.setOwner(player);
        when(saves.findBySaveCode("MINE01")).thenReturn(Optional.of(mine));

        lobby.selectCharacter(roomId, player, "MINE01");

        assertSame(mine, m.getCharacter());
    }
}
