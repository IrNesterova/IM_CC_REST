package portfolio.example.im_cc.repositories.characterwizard;

import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import portfolio.example.im_cc.models.characterwizard.MeleeWeapon;

import java.util.List;

@Repository
public interface MeleeWeaponRepository extends JpaRepository<MeleeWeapon, Long> {

    @EntityGraph(attributePaths = {"specialization"})
    List<MeleeWeapon> findAll();
}
