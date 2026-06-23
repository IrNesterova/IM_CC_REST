package portfolio.example.im_cc.repositories;

import org.springframework.data.convert.ReadingConverter;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import portfolio.example.im_cc.models.FactionChoiceGroup;
import portfolio.example.im_cc.models.FactionTalentChoice;

import java.util.List;

@Repository
public interface FactionTalentChoiceRepository extends JpaRepository<FactionTalentChoice, Long> {
    List<FactionTalentChoice> findByFactionChoiceGroup(FactionChoiceGroup factionChoiceGroup);
    List<FactionTalentChoice> findByFactionChoiceGroupIn(List<FactionChoiceGroup> groups);
}

