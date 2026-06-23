package portfolio.example.im_cc.controllers.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import portfolio.example.im_cc.models.BugReport;
import portfolio.example.im_cc.repositories.BugReportRepository;

@RestController
@RequestMapping("/api/bug-report")
public class BugReportApiController {

    @Autowired private BugReportRepository bugReportRepository;

    @PostMapping
    public ResponseEntity<Void> submit(@RequestBody BugReport report) {
        bugReportRepository.save(report);
        return ResponseEntity.ok().build();
    }
}
