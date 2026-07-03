package portfolio.example.im_cc.repositories.characterwizard;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import portfolio.example.im_cc.models.characterwizard.Specialization;

@Repository
public interface SpecializationRepository extends JpaRepository<Specialization, Long> {
}