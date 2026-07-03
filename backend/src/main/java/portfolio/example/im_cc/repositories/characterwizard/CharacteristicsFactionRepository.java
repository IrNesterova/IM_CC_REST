package portfolio.example.im_cc.repositories.characterwizard;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import portfolio.example.im_cc.models.characterwizard.CharacteristicsFaction;
import portfolio.example.im_cc.models.characterwizard.Faction;

import java.util.List;

@Repository
public interface CharacteristicsFactionRepository extends JpaRepository<CharacteristicsFaction, Long> {
    List<CharacteristicsFaction> findAllByFaction(Faction faction);
    List<CharacteristicsFaction> findByFactionIn(List<Faction> factions);
    List<CharacteristicsFaction> findAllByFactionAndPrimaryChar(Faction faction, boolean primaryChar);
}
