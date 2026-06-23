package portfolio.example.im_cc.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import portfolio.example.im_cc.models.Armour;

import java.util.List;

@Repository
public interface ArmourRepository extends JpaRepository<Armour, Long> {

    /** Eagerly fetch locationsCovered in a single query to avoid N+1. */
    @Query("SELECT a FROM Armour a LEFT JOIN FETCH a.locationsCovered")
    List<Armour> findAllWithLocations();
}
