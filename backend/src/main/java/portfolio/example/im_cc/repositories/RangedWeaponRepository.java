package portfolio.example.im_cc.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import portfolio.example.im_cc.models.RangedWeapon;

import java.util.List;

@Repository
public interface RangedWeaponRepository extends JpaRepository<RangedWeapon, Long> {

    @Query("SELECT r FROM RangedWeapon r LEFT JOIN FETCH r.specialization")
    List<RangedWeapon> findAllWithSpec();
}