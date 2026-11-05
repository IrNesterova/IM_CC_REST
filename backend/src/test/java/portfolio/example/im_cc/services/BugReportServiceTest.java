package portfolio.example.im_cc.services;

import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;
import org.springframework.amqp.AmqpConnectException;
import portfolio.example.im_cc.messaging.BugReportMessage;
import portfolio.example.im_cc.messaging.BugReportProducer;
import portfolio.example.im_cc.models.characterwizard.BugReport;
import portfolio.example.im_cc.repositories.BugReportRepository;

import java.net.ConnectException;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

class BugReportServiceTest {

    private final BugReportProducer producer = mock(BugReportProducer.class);
    private final BugReportRepository repository = mock(BugReportRepository.class);
    private final BugReportService service = new BugReportService(producer, repository);
    private final BugReportMessage message = new BugReportMessage("desc", "/page", "name", "title");

    @Test
    void queuesReportWithoutTouchingDatabaseWhenRabbitIsUp() {
        service.submit(message);

        verify(producer).send(message);
        verifyNoInteractions(repository);
    }

    @Test
    void savesReportToDatabaseWhenRabbitIsDown() {
        doThrow(new AmqpConnectException(new ConnectException("refused"))).when(producer).send(message);

        service.submit(message);

        ArgumentCaptor<BugReport> saved = ArgumentCaptor.forClass(BugReport.class);
        verify(repository).save(saved.capture());
        assertEquals("desc", saved.getValue().getDescription());
        assertEquals("/page", saved.getValue().getPageUrl());
        assertEquals("name", saved.getValue().getName());
        assertEquals("title", saved.getValue().getTitle());
    }

    @Test
    void doesNotHideUnrelatedFailures() {
        doThrow(new IllegalStateException("bug")).when(producer).send(any());

        assertThrows(IllegalStateException.class, () -> service.submit(message));
        verifyNoInteractions(repository);
    }
}
