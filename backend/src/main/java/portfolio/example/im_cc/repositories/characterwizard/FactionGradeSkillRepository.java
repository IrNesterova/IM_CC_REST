package portfolio.example.im_cc.repositories.characterwizard;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import portfolio.example.im_cc.models.characterwizard.FactionGrade;
import portfolio.example.im_cc.models.characterwizard.FactionGradeSkill;

import java.util.List;

@Repository
public interface FactionGradeSkillRepository extends JpaRepository<FactionGradeSkill, Long> {
    List<FactionGradeSkill> findByGrade(FactionGrade grade);
    List<FactionGradeSkill> findByGradeIn(List<FactionGrade> grades);
}