package portfolio.example.im_cc.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import portfolio.example.im_cc.models.MeleeWeapon;

import java.util.List;

@Repository
public interface MeleeWeaponRepository extends JpaRepository<MeleeWeapon, Long> {

    @Query("SELECT m FROM MeleeWeapon m LEFT JOIN FETCH m.specialization")
    List<MeleeWeapon> findAllWithSpec();
}