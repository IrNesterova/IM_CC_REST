package portfolio.example.im_cc.repositories.characterwizard;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import portfolio.example.im_cc.models.characterwizard.FactionGrade;
import portfolio.example.im_cc.models.characterwizard.FactionGradeChoiceGroup;

import java.util.List;

@Repository
public interface FactionGradeChoiceGroupRepository extends JpaRepository<FactionGradeChoiceGroup, Long> {
    List<FactionGradeChoiceGroup> findByGrade(FactionGrade grade);
    List<FactionGradeChoiceGroup> findByGradeIn(List<FactionGrade> grades);
}