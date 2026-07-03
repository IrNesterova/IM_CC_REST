package portfolio.example.im_cc.repositories.patron;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import portfolio.example.im_cc.models.patron.PatronDuty;

@Repository
public interface PatronDutyRepository extends JpaRepository<PatronDuty, Long> {}