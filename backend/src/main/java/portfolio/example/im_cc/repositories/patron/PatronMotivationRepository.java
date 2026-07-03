package portfolio.example.im_cc.repositories.patron;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import portfolio.example.im_cc.models.patron.PatronMotivation;

@Repository
public interface PatronMotivationRepository extends JpaRepository<PatronMotivation, Long> {}