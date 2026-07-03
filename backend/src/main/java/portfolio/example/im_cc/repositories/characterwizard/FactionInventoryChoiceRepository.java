package portfolio.example.im_cc.repositories.characterwizard;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import portfolio.example.im_cc.models.characterwizard.FactionChoiceGroup;
import portfolio.example.im_cc.models.characterwizard.FactionInventoryChoice;

import java.util.List;

@Repository
public interface FactionInventoryChoiceRepository extends JpaRepository<FactionInventoryChoice, Long> {
    List<FactionInventoryChoice> findByFactionChoiceGroup(FactionChoiceGroup factionChoiceGroup);
    List<FactionInventoryChoice> findByFactionChoiceGroupIn(List<FactionChoiceGroup> groups);
}

