package portfolio.example.im_cc.repositories.characterwizard;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import portfolio.example.im_cc.models.characterwizard.Faction;
import portfolio.example.im_cc.models.characterwizard.FactionGrade;

import java.util.List;

@Repository
public interface FactionGradeRepository extends JpaRepository<FactionGrade, Long> {
    List<FactionGrade> findByFaction(Faction faction);
    List<FactionGrade> findByFactionIn(List<Faction> factions);
}