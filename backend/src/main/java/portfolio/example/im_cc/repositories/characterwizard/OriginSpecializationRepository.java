package portfolio.example.im_cc.repositories.characterwizard;

import org.springframework.data.jpa.repository.JpaRepository;
import portfolio.example.im_cc.models.characterwizard.OriginSpecialization;

import java.util.List;

public interface OriginSpecializationRepository extends JpaRepository<OriginSpecialization, Long> {
    List<OriginSpecialization> findByOriginId(Long originId);
}