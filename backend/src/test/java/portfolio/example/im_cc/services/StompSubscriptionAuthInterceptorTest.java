package portfolio.example.im_cc.services;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.messaging.Message;
import org.springframework.messaging.MessageChannel;
import org.springframework.messaging.MessagingException;
import org.springframework.messaging.simp.stomp.StompCommand;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.messaging.support.MessageBuilder;
import portfolio.example.im_cc.models.AppUser;
import portfolio.example.im_cc.models.lobby.GameRoomMember;
import portfolio.example.im_cc.repositories.AppUserRepository;
import portfolio.example.im_cc.repositories.lobby.GameRoomMemberRepository;
import portfolio.example.im_cc.repositories.lobby.GameRoomRepository;

import java.security.Principal;
import java.util.Optional;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.assertSame;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

class StompSubscriptionAuthInterceptorTest {

    private static final UUID ROOM = UUID.fromString("11111111-2222-3333-4444-555555555555");
    private static final Principal ALICE = () -> "alice@example.com";

    private final GameRoomMemberRepository members = mock(GameRoomMemberRepository.class);
    private final GameRoomRepository rooms = mock(GameRoomRepository.class);
    private final AppUserRepository users = mock(AppUserRepository.class);
    private final StompSubscriptionAuthInterceptor interceptor =
            new StompSubscriptionAuthInterceptor(members, rooms, users);
    private final MessageChannel channel = mock(MessageChannel.class);

    @BeforeEach
    void setUp() {
        AppUser alice = new AppUser();
        alice.setId(1L);
        when(users.findByEmail("alice@example.com")).thenReturn(Optional.of(alice));
        when(rooms.findById(any())).thenReturn(Optional.empty());
    }

    private static Message<byte[]> frame(StompCommand command, String destination, Principal user) {
        StompHeaderAccessor accessor = StompHeaderAccessor.create(command);
        if (destination != null) accessor.setDestination(destination);
        accessor.setUser(user);
        return MessageBuilder.createMessage(new byte[0], accessor.getMessageHeaders());
    }

    @Test
    void memberCanSubscribeToTheirRoom() {
        when(members.existsByRoomIdAndUserIdAndStatus(ROOM, 1L, GameRoomMember.MemberStatus.ACTIVE)).thenReturn(true);
        Message<byte[]> msg = frame(StompCommand.SUBSCRIBE, "/topic/rooms/" + ROOM, ALICE);

        assertSame(msg, interceptor.preSend(msg, channel));
    }

    @Test
    void nonMemberCannotSubscribe() {
        when(members.existsByRoomIdAndUserIdAndStatus(ROOM, 1L, GameRoomMember.MemberStatus.ACTIVE)).thenReturn(false);

        assertThrows(MessagingException.class, () ->
                interceptor.preSend(frame(StompCommand.SUBSCRIBE, "/topic/rooms/" + ROOM, ALICE), channel));
    }

    @Test
    void wildcardSubscriptionsAreRejected() {
        for (String destination : new String[]{"/topic/**", "/topic/rooms/*", "/topic/rooms/**", "/topic/other"}) {
            assertThrows(MessagingException.class, () ->
                    interceptor.preSend(frame(StompCommand.SUBSCRIBE, destination, null), channel), destination);
        }
        verifyNoInteractions(members);
    }

    @Test
    void anonymousCannotSubscribeToARoom() {
        assertThrows(MessagingException.class, () ->
                interceptor.preSend(frame(StompCommand.SUBSCRIBE, "/topic/rooms/" + ROOM, null), channel));
    }

    @Test
    void clientsCannotSend() {
        when(members.existsByRoomIdAndUserIdAndStatus(ROOM, 1L, GameRoomMember.MemberStatus.ACTIVE)).thenReturn(true);

        assertThrows(MessagingException.class, () ->
                interceptor.preSend(frame(StompCommand.SEND, "/topic/rooms/" + ROOM, ALICE), channel));
    }

    @Test
    void connectPassesThrough() {
        Message<byte[]> msg = frame(StompCommand.CONNECT, null, null);

        assertSame(msg, interceptor.preSend(msg, channel));
    }
}
