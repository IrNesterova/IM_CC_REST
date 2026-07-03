package portfolio.example.im_cc.repositories.characterwizard;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import portfolio.example.im_cc.models.characterwizard.CharacteristicsOrigin;

import java.util.List;

@Repository
public interface CharacteristicsOriginRepository extends JpaRepository<CharacteristicsOrigin, Long> {
    List<CharacteristicsOrigin> findByOriginId(Long originId);
    List<CharacteristicsOrigin> findByOriginIdAndPrimaryChar(Long originId, boolean primary_char);
}
