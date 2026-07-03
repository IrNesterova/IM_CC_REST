package portfolio.example.im_cc.controllers.api;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import portfolio.example.im_cc.messaging.BugReportMessage;
import portfolio.example.im_cc.messaging.BugReportProducer;
import portfolio.example.im_cc.models.characterwizard.BugReport;

@RestController
@RequestMapping("/api/bug-report")
@RequiredArgsConstructor
public class BugReportApiController {

    private final BugReportProducer bugReportProducer;

    @PostMapping
    public ResponseEntity<Void> submit(@RequestBody BugReport report) {
        bugReportProducer.send(new BugReportMessage(
                report.getDescription(),
                report.getPageUrl(),
                report.getName(),
                report.getTitle()
        ));
        return ResponseEntity.accepted().build();
    }
}