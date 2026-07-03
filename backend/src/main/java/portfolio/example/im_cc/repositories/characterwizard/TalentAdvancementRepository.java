package portfolio.example.im_cc.repositories.characterwizard;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import portfolio.example.im_cc.models.characterwizard.TalentAdvancement;

import java.util.List;

@Repository
public interface TalentAdvancementRepository extends JpaRepository<TalentAdvancement, Long> {
    List<TalentAdvancement> findByTalentIdOrderByAdvanceNumberAsc(Long talentId);
    List<TalentAdvancement> findByTalentIdAndChoiceTrue(Long talentId);
}