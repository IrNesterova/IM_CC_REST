package portfolio.example.im_cc.repositories;

import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import portfolio.example.im_cc.models.Inventory;
import portfolio.example.im_cc.models.InventoryCategory;

import java.util.List;

@Repository
public interface InventoryRepository extends JpaRepository<Inventory, Long> {
    List<Inventory> findByInventoryCategoryIn(List<InventoryCategory> categories, Sort sort);
}