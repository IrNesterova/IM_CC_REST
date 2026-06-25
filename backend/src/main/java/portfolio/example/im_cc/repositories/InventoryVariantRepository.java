package portfolio.example.im_cc.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import portfolio.example.im_cc.models.InventoryVariant;

@Repository
public interface InventoryVariantRepository extends JpaRepository<InventoryVariant, Long> {
}