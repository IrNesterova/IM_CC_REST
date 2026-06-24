package portfolio.example.im_cc.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import portfolio.example.im_cc.models.CharacterInjury;

import java.util.List;

@Repository
public interface CharacterInjuryRepository extends JpaRepository<CharacterInjury, Long> {

    List<CharacterInjury> findByCharacterSaveIdOrderByAcquiredAt(Long characterSaveId);

    void deleteByCharacterSaveIdAndInjuryId(Long characterSaveId, Long injuryId);
}