package portfolio.example.im_cc.services;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import org.springframework.transaction.event.TransactionPhase;
import org.springframework.transaction.event.TransactionalEventListener;
import org.springframework.messaging.simp.SimpMessagingTemplate;

@Component
@RequiredArgsConstructor
public class LobbyEventBroadcaster {
    private final SimpMessagingTemplate messaging;
    @TransactionalEventListener(phase = TransactionPhase.AFTER_COMMIT)
    public void onLobbyEvent(LobbyEvent event) {
        messaging.convertAndSend("/topic/rooms/" + event.roomId(), event);
    }
}
