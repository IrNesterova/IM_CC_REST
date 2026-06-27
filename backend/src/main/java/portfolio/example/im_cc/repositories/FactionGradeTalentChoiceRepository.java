package portfolio.example.im_cc.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import portfolio.example.im_cc.models.FactionGradeChoiceGroup;
import portfolio.example.im_cc.models.FactionGradeTalentChoice;

import java.util.List;

@Repository
public interface FactionGradeTalentChoiceRepository extends JpaRepository<FactionGradeTalentChoice, Long> {
    List<FactionGradeTalentChoice> findByChoiceGroup(FactionGradeChoiceGroup choiceGroup);
    List<FactionGradeTalentChoice> findByChoiceGroupIn(List<FactionGradeChoiceGroup> choiceGroups);
}