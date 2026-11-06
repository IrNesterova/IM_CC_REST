package portfolio.example.im_cc.messaging;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.stereotype.Component;
import portfolio.example.im_cc.config.ConditionalOnRabbitMq;
import portfolio.example.im_cc.config.RabbitMQConfig;
import portfolio.example.im_cc.services.BugReportService;

@Slf4j
@Component
@ConditionalOnRabbitMq
@RequiredArgsConstructor
public class BugReportConsumer {

    private final BugReportService bugReportService;

    @RabbitListener(queues = RabbitMQConfig.BUG_REPORT_QUEUE)
    public void consume(BugReportMessage message) {
        log.info("Received bug report from queue: page={}", message.pageUrl());
        bugReportService.save(message);
    }
}
