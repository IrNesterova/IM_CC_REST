package portfolio.example.im_cc.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import portfolio.example.im_cc.models.FactionGrade;
import portfolio.example.im_cc.models.FactionGradeCharChoice;

import java.util.List;

@Repository
public interface FactionGradeCharChoiceRepository extends JpaRepository<FactionGradeCharChoice, Long> {
    List<FactionGradeCharChoice> findByGrade(FactionGrade grade);
    List<FactionGradeCharChoice> findByGradeIn(List<FactionGrade> grades);
}