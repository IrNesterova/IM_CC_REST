package portfolio.example.im_cc.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import portfolio.example.im_cc.models.characterwizard.BugReport;

public interface BugReportRepository extends JpaRepository<BugReport, Long> {

}
