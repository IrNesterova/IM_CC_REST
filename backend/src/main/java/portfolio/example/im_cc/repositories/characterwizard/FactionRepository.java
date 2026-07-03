package portfolio.example.im_cc.repositories.characterwizard;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import portfolio.example.im_cc.dto.PatronFactionEntry;
import portfolio.example.im_cc.models.characterwizard.Faction;

import java.util.List;

@Repository
public interface FactionRepository extends JpaRepository<Faction, Long> {
    Faction getFactionById(Long id);

    @Query("SELECT new portfolio.example.im_cc.dto.PatronFactionEntry(f.id, f.name) FROM Faction f WHERE f.sourceBook = portfolio.example.im_cc.models.enums.SourceBook.IM ORDER BY f.name")
    List<PatronFactionEntry> findAllSimple();
}
