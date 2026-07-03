package portfolio.example.im_cc.messaging;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.stereotype.Component;
import portfolio.example.im_cc.config.RabbitMQConfig;
import portfolio.example.im_cc.models.characterwizard.BugReport;
import portfolio.example.im_cc.repositories.BugReportRepository;

@Slf4j
@Component
@RequiredArgsConstructor
public class BugReportConsumer {

    private final BugReportRepository bugReportRepository;

    @RabbitListener(queues = RabbitMQConfig.BUG_REPORT_QUEUE)
    public void consume(BugReportMessage message) {
        log.info("Received bug report from queue: page={}", message.pageUrl());
        BugReport report = new BugReport();
        report.setDescription(message.description());
        report.setPageUrl(message.pageUrl());
        report.setName(message.name());
        report.setTitle(message.title());
        bugReportRepository.save(report);
    }
}