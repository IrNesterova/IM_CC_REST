package portfolio.example.im_cc.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import portfolio.example.im_cc.models.BodyLocation;
import portfolio.example.im_cc.models.CriticalWound;

import java.util.List;
import java.util.Optional;

@Repository
public interface CriticalWoundRepository extends JpaRepository<CriticalWound, Long> {

    List<CriticalWound> findByLocationOrderByRollMin(BodyLocation location);

    @Query("SELECT c FROM CriticalWound c WHERE c.location = :location AND :roll BETWEEN c.rollMin AND c.rollMax")
    Optional<CriticalWound> findByLocationAndRoll(@Param("location") BodyLocation location, @Param("roll") Integer roll);
}