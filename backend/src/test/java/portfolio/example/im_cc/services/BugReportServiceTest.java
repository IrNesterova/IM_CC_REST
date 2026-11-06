package portfolio.example.im_cc.services;

import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;
import org.springframework.amqp.AmqpConnectException;
import org.springframework.beans.factory.ObjectProvider;
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
    private final BugReportMessage message = new BugReportMessage("desc", "/page", "name", "title");

    @SuppressWarnings("unchecked")
    private BugReportService service(BugReportProducer available) {
        ObjectProvider<BugReportProducer> provider = mock(ObjectProvider.class);
        when(provider.getIfAvailable()).thenReturn(available);
        return new BugReportService(provider, repository);
    }

    @Test
    void queuesReportWithoutTouchingDatabaseWhenRabbitIsUp() {
        service(producer).submit(message);

        verify(producer).send(message);
        verifyNoInteractions(repository);
    }

    @Test
    void savesReportToDatabaseWhenRabbitIsDown() {
        doThrow(new AmqpConnectException(new ConnectException("refused"))).when(producer).send(message);

        service(producer).submit(message);

        ArgumentCaptor<BugReport> saved = ArgumentCaptor.forClass(BugReport.class);
        verify(repository).save(saved.capture());
        assertEquals("desc", saved.getValue().getDescription());
        assertEquals("/page", saved.getValue().getPageUrl());
        assertEquals("name", saved.getValue().getName());
        assertEquals("title", saved.getValue().getTitle());
    }

    @Test
    void savesReportToDatabaseWhenRabbitIsDisabled() {
        service(null).submit(message);

        verify(repository).save(any(BugReport.class));
        verifyNoInteractions(producer);
    }

    @Test
    void doesNotHideUnrelatedFailures() {
        doThrow(new IllegalStateException("bug")).when(producer).send(any());

        assertThrows(IllegalStateException.class, () -> service(producer).submit(message));
        verifyNoInteractions(repository);
    }
}
