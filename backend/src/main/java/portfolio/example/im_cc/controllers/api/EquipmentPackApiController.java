package portfolio.example.im_cc.controllers.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import portfolio.example.im_cc.models.characterwizard.EquipmentPack;
import portfolio.example.im_cc.models.characterwizard.EquipmentPackItem;
import portfolio.example.im_cc.repositories.characterwizard.EquipmentPackItemRepository;
import portfolio.example.im_cc.repositories.characterwizard.EquipmentPackRepository;

import java.util.List;

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
