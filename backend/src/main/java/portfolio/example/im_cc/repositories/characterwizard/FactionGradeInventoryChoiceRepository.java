package portfolio.example.im_cc.repositories.characterwizard;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import portfolio.example.im_cc.models.characterwizard.FactionGradeChoiceGroup;
import portfolio.example.im_cc.models.characterwizard.FactionGradeInventoryChoice;

import java.util.List;

@Repository
public interface FactionGradeInventoryChoiceRepository extends JpaRepository<FactionGradeInventoryChoice, Long> {
    List<FactionGradeInventoryChoice> findByChoiceGroup(FactionGradeChoiceGroup choiceGroup);
    List<FactionGradeInventoryChoice> findByChoiceGroupIn(List<FactionGradeChoiceGroup> choiceGroups);
}