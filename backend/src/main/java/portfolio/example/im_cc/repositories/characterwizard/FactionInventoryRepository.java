package portfolio.example.im_cc.repositories.characterwizard;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import portfolio.example.im_cc.models.characterwizard.Faction;
import portfolio.example.im_cc.models.characterwizard.FactionInventory;

import java.util.List;

@Repository
public interface FactionInventoryRepository extends JpaRepository<FactionInventory, Long> {
    List<FactionInventory> findByFactionIn(List<Faction> factions);
    List<FactionInventory> findFactionInventoriesByFaction(Faction faction);
}
