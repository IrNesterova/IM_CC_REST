package portfolio.example.im_cc.repositories.characterwizard;

import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import portfolio.example.im_cc.models.characterwizard.RangedWeapon;

import java.util.List;

@Repository
public interface RangedWeaponRepository extends JpaRepository<RangedWeapon, Long> {

    @EntityGraph(attributePaths = {"specialization"})
    List<RangedWeapon> findAll();
}
