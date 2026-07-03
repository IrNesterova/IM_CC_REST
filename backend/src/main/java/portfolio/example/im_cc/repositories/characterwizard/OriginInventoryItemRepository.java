package portfolio.example.im_cc.repositories.characterwizard;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import portfolio.example.im_cc.models.characterwizard.OriginInventoryItem;

import java.util.List;

@Repository
public interface OriginInventoryItemRepository extends JpaRepository<OriginInventoryItem, Long> {
    List<OriginInventoryItem> findByOriginId(Long originId);
}