package portfolio.example.im_cc.messaging;

import lombok.RequiredArgsConstructor;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.stereotype.Component;
import portfolio.example.im_cc.config.RabbitMQConfig;

@Component
@RequiredArgsConstructor
public class BugReportProducer {

    private final RabbitTemplate rabbitTemplate;

    public void send(BugReportMessage message) {
        rabbitTemplate.convertAndSend(
                RabbitMQConfig.BUG_REPORT_EXCHANGE,
                RabbitMQConfig.BUG_REPORT_ROUTING_KEY,
                message
        );
    }
}