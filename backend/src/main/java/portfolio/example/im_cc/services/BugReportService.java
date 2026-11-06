package portfolio.example.im_cc.services;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.AmqpException;
import org.springframework.beans.factory.ObjectProvider;
import org.springframework.stereotype.Service;
import portfolio.example.im_cc.messaging.BugReportMessage;
import portfolio.example.im_cc.messaging.BugReportProducer;
import portfolio.example.im_cc.models.characterwizard.BugReport;
import portfolio.example.im_cc.repositories.BugReportRepository;

@Slf4j
@Service
@RequiredArgsConstructor
public class BugReportService {

    // Absent when RabbitMQ is disabled (no RABBITMQ_HOST), see ConditionalOnRabbitMq.
    private final ObjectProvider<BugReportProducer> producer;
    private final BugReportRepository repository;

    /** Queues the report, or saves it straight to the database if RabbitMQ is disabled or unavailable. */
    public void submit(BugReportMessage message) {
        BugReportProducer queue = producer.getIfAvailable();
        if (queue == null) {
            save(message);
            return;
        }
        try {
            queue.send(message);
        } catch (AmqpException e) {
            log.warn("RabbitMQ unavailable, saving bug report directly to the database: {}", e.getMessage());
            save(message);
        }
    }

    public void save(BugReportMessage message) {
        BugReport report = new BugReport();
        report.setDescription(message.description());
        report.setPageUrl(message.pageUrl());
        report.setName(message.name());
        report.setTitle(message.title());
        repository.save(report);
    }
}
