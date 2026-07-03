package portfolio.example.im_cc.services;

import lombok.RequiredArgsConstructor;
import org.springframework.messaging.Message;
import org.springframework.messaging.MessageChannel;
import org.springframework.messaging.MessagingException;
import org.springframework.messaging.simp.stomp.StompCommand;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.messaging.support.ChannelInterceptor;
import org.springframework.stereotype.Component;
import portfolio.example.im_cc.repositories.AppUserRepository;
import portfolio.example.im_cc.repositories.lobby.GameRoomMemberRepository;
import portfolio.example.im_cc.repositories.lobby.GameRoomRepository;

import java.security.Principal;
import java.util.UUID;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Component
@RequiredArgsConstructor
public class StompSubscriptionAuthInterceptor implements ChannelInterceptor {
    private final GameRoomMemberRepository members;
    private final GameRoomRepository rooms;
    private final AppUserRepository users;

    // matches /topic/rooms/{uuid}
    private static final Pattern ROOM_TOPIC =
            Pattern.compile("^/topic/rooms/([0-9a-fA-F-]{36})$");

    @Override
    public Message<?> preSend(Message<?> message, MessageChannel channel) {
        StompHeaderAccessor accessor = StompHeaderAccessor.wrap(message);

        // Only gate SUBSCRIBE. (If you later let clients SEND to /app/rooms/{id}/..., gate SEND too.)
        if (!StompCommand.SUBSCRIBE.equals(accessor.getCommand())) {
            return message;
        }

        String destination = accessor.getDestination();
        if (destination == null) {
            return message;
        }

        Matcher matcher = ROOM_TOPIC.matcher(destination);
        if (!matcher.matches()) {
            // not a room topic (e.g. a user-specific queue) — leave it to other rules
            return message;
        }
        UUID roomId = UUID.fromString(matcher.group(1));

        Principal principal = accessor.getUser();
        if (principal == null) {
            // With cookie-based Spring Security sessions the principal rides in on the
            // handshake. If this is ever null, the authenticated session isn't reaching the
            // socket — configure a HandshakeHandler / Spring Security messaging support.
            throw new MessagingException("Unauthenticated subscription to " + destination);
        }
        Long userId = resolveUserId(principal);

        // THE check. You may subscribe to a room only if you actually belong to it.
        // This is the realtime equivalent of your REST ownership checks — without it,
        // anyone who knows a room id could read its live roster/presence stream.
        boolean allowed = members.existsByRoomIdAndUserId(roomId, userId)
                || rooms.findById(roomId)
                .map(room -> room.getGm().getId().equals(userId))
                .orElse(false);

        if (!allowed) {
            throw new MessagingException("Not a member of room " + roomId);
        }
        return message;
    }

    private Long resolveUserId(Principal principal) {
        return users.findByEmail(principal.getName())
                .map(u -> u.getId())
                .orElseThrow(() -> new MessagingException("Unknown user: " + principal.getName()));
    }
}
