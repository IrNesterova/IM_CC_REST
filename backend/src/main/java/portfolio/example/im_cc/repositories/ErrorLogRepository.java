package portfolio.example.im_cc.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import portfolio.example.im_cc.models.ErrorLog;

public interface ErrorLogRepository extends JpaRepository<ErrorLog, Long> {
}
