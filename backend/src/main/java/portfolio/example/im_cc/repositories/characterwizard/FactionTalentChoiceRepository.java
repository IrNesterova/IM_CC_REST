package portfolio.example.im_cc.repositories.characterwizard;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import portfolio.example.im_cc.models.characterwizard.FactionChoiceGroup;
import portfolio.example.im_cc.models.characterwizard.FactionTalentChoice;

import java.util.List;

@Repository
public interface FactionTalentChoiceRepository extends JpaRepository<FactionTalentChoice, Long> {
    List<FactionTalentChoice> findByFactionChoiceGroup(FactionChoiceGroup factionChoiceGroup);
    List<FactionTalentChoice> findByFactionChoiceGroupIn(List<FactionChoiceGroup> groups);
}

