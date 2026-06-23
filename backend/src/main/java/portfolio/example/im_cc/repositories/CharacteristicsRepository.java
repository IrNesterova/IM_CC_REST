package portfolio.example.im_cc.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import portfolio.example.im_cc.models.Characteristics;
import portfolio.example.im_cc.models.Origin;

@Repository
public interface CharacteristicsRepository extends JpaRepository<Characteristics, Long> {
}
