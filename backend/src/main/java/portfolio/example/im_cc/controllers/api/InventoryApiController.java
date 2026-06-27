package portfolio.example.im_cc.controllers.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import portfolio.example.im_cc.models.Inventory;
import portfolio.example.im_cc.models.InventoryCategory;
import portfolio.example.im_cc.repositories.InventoryRepository;

import java.util.List;

@RestController
@RequestMapping("/api")
public class InventoryApiController {

    @Autowired
    private InventoryRepository inventoryRepository;

    @GetMapping("/augmetics")
    public List<Inventory> getAugmetics() {
        return inventoryRepository.findByInventoryCategoryIn(
            List.of(InventoryCategory.AUGMETIC, InventoryCategory.AUGMETIC_REPLACEMENTS),
            Sort.by(Sort.Direction.ASC, "name")
        );
    }
}
