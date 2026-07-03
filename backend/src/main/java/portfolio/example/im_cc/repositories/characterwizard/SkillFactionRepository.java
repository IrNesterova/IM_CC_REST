package portfolio.example.im_cc.repositories.characterwizard;

import org.springframework.data.jpa.repository.JpaRepository;
import portfolio.example.im_cc.models.characterwizard.Faction;
import portfolio.example.im_cc.models.characterwizard.SkillFactions;

import java.util.List;

public interface SkillFactionRepository extends JpaRepository<SkillFactions, Long> {
    List<SkillFactions> findByFactionIn(List<Faction> factions);
    List<SkillFactions> findSkillFactionsByFaction(Faction faction);
}
