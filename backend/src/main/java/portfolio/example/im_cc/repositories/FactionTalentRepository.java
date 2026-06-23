package portfolio.example.im_cc.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import portfolio.example.im_cc.models.Faction;
import portfolio.example.im_cc.models.FactionTalent;

import java.util.List;

@Repository
public interface FactionTalentRepository extends JpaRepository<FactionTalent, Long> {

    List<FactionTalent> findAllByFactionIn(List<Faction> factions);
    List<FactionTalent> findFactionTalentsByFaction(Faction faction);
}
