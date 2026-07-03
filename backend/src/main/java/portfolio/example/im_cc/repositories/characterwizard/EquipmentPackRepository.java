package portfolio.example.im_cc.repositories.characterwizard;

import org.springframework.data.jpa.repository.JpaRepository;
import portfolio.example.im_cc.models.characterwizard.EquipmentPack;

import java.util.List;

public interface EquipmentPackRepository extends JpaRepository<EquipmentPack, Long> {
    List<EquipmentPack> findAllByOrderByCostAsc();
}
