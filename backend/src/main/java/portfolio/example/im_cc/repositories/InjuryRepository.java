package portfolio.example.im_cc.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import portfolio.example.im_cc.models.Injury;
import portfolio.example.im_cc.models.InjuryType;

import java.util.List;
import java.util.Optional;

@Repository
public interface InjuryRepository extends JpaRepository<Injury, Long> {

    Optional<Injury> findByName(String name);

    List<Injury> findByInjuryType(InjuryType injuryType);
}