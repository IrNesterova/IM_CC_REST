package portfolio.example.im_cc.repositories.patron;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import portfolio.example.im_cc.models.patron.PatronDemeanour;

@Repository
public interface PatronDemeanourRepository extends JpaRepository<PatronDemeanour, Long> {}