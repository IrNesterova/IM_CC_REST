package portfolio.example.im_cc.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import portfolio.example.im_cc.models.Specialization;

@Repository
public interface SpecializationRepository extends JpaRepository<Specialization, Long> {
}