package portfolio.example.im_cc.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import portfolio.example.im_cc.models.EquipmentPackItem;

import java.util.List;

public interface EquipmentPackItemRepository extends JpaRepository<EquipmentPackItem, Long> {
    List<EquipmentPackItem> findByEquipmentPackId(Long packId);
}
