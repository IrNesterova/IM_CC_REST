package portfolio.example.im_cc.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import portfolio.example.im_cc.models.Faction;
import portfolio.example.im_cc.models.FactionChoiceGroup;

import java.util.List;

@Repository
public interface FactionChoiceGroupRepository extends JpaRepository<FactionChoiceGroup,Long> {
    List<FactionChoiceGroup> findByFactionIn(List<Faction> factions);

    List<FactionChoiceGroup> findByFaction(Faction faction);
}
