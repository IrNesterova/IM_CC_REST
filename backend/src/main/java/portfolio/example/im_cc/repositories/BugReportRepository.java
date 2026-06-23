package portfolio.example.im_cc.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import portfolio.example.im_cc.models.BugReport;

import java.time.LocalDateTime;

public interface BugReportRepository extends JpaRepository<BugReport, Long> {

}
