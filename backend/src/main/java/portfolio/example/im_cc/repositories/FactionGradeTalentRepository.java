package portfolio.example.im_cc.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import portfolio.example.im_cc.models.FactionGrade;
import portfolio.example.im_cc.models.FactionGradeTalent;

import java.util.List;

@Repository
public interface FactionGradeTalentRepository extends JpaRepository<FactionGradeTalent, Long> {
    List<FactionGradeTalent> findByGrade(FactionGrade grade);
    List<FactionGradeTalent> findByGradeIn(List<FactionGrade> grades);
}