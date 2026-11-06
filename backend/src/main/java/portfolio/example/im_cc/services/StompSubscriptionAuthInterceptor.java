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

    // The only destination clients may subscribe to: /topic/rooms/{uuid}
    private static final Pattern ROOM_TOPIC = Pattern.compile(
            "^/topic/rooms/([0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12})$");

    @Override
    public Message<?> preSend(Message<?> message, MessageChannel channel) {
        StompHeaderAccessor accessor = StompHeaderAccessor.wrap(message);
        StompCommand command = accessor.getCommand();

        // Events are server-pushed and clients act through REST. A client SEND to /topic/... would be
        // relayed by the simple broker to every subscriber, letting anyone forge room events.
        if (StompCommand.SEND.equals(command)) {
            throw new MessagingException("Clients cannot send messages");
        }
        if (!StompCommand.SUBSCRIBE.equals(command)) {
            return message;
        }

        // Allowlist, not denylist: the broker treats patterns like /topic/** as wildcards,
        // so any destination other than one exact room topic is rejected.
        String destination = accessor.getDestination();
        Matcher matcher = destination == null ? null : ROOM_TOPIC.matcher(destination);
        if (matcher == null || !matcher.matches()) {
            throw new MessagingException("Subscription not allowed: " + destination);
        }
        UUID roomId = UUID.fromString(matcher.group(1));

        Principal principal = accessor.getUser();
        if (principal == null) {
            throw new MessagingException("Unauthenticated subscription to " + destination);
        }
        Long userId = resolveUserId(principal);

        // You may subscribe to a room only if you actually belong to it.
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
