package portfolio.example.im_cc.controllers.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import portfolio.example.im_cc.models.EquipmentPack;
import portfolio.example.im_cc.models.EquipmentPackItem;
import portfolio.example.im_cc.repositories.EquipmentPackItemRepository;
import portfolio.example.im_cc.repositories.EquipmentPackRepository;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/equipment-packs")
public class EquipmentPackApiController {

    @Autowired private EquipmentPackRepository packRepository;
    @Autowired private EquipmentPackItemRepository itemRepository;

    @GetMapping
    public List<PackWithItems> getAll() {
        List<EquipmentPack> packs = packRepository.findAllByOrderByCostAsc();
        return packs.stream().map(p -> new PackWithItems(
                p,
                itemRepository.findByEquipmentPackId(p.getId())
        )).toList();
    }

    public record PackWithItems(EquipmentPack pack, List<EquipmentPackItem> items) {}
}
