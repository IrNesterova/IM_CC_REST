package portfolio.example.im_cc.repositories.characterwizard;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import portfolio.example.im_cc.models.characterwizard.FactionGrade;
import portfolio.example.im_cc.models.characterwizard.FactionGradeInventory;

import java.util.List;

@Repository
public interface FactionGradeInventoryRepository extends JpaRepository<FactionGradeInventory, Long> {
    List<FactionGradeInventory> findByGrade(FactionGrade grade);
    List<FactionGradeInventory> findByGradeIn(List<FactionGrade> grades);
}