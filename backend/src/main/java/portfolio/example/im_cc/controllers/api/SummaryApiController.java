package portfolio.example.im_cc.controllers.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;
import portfolio.example.im_cc.dto.SummaryResponseDTO;
import portfolio.example.im_cc.models.*;
import portfolio.example.im_cc.repositories.*;
import portfolio.example.im_cc.services.SummaryServiceImpl;

import java.util.*;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/summary")
public class SummaryApiController {

    @Autowired private SummaryServiceImpl summaryService;
    @Autowired private ArmourRepository armourRepository;
    @Autowired private TalentRepository talentRepository;
    @Autowired private InventoryRepository inventoryRepository;
    @Autowired private MeleeWeaponRepository meleeWeaponRepository;
    @Autowired private RangedWeaponRepository rangedWeaponRepository;
    @Autowired private MutationRepository mutationRepository;
    @Autowired private CombatActionRepository combatActionRepository;
    @Autowired private SkillSpecializationsRepository skillSpecializationsRepository;

    @Transactional(readOnly = true)
    @PostMapping
    public SummaryResponseDTO buildSummary(@RequestBody CharacterCreationModel ccm) {
        SummaryResponseDTO response = new SummaryResponseDTO();

        response.setSheet(summaryService.build(ccm));

        // Armour stats
        Map<String, Map<String, Object>> armourMap = new HashMap<>();
        armourRepository.findAllWithLocations().forEach(a -> {
            if (a.getName() == null) return;
            Map<String, Object> data = new LinkedHashMap<>();
            data.put("ap", a.getArmorPoints() != null ? a.getArmorPoints() : 0);
            data.put("locations", a.getLocationsCovered() != null
                    ? a.getLocationsCovered().stream().map(Enum::name).collect(Collectors.toList())
                    : List.of());
            data.put("special", a.getSpecial() != null ? a.getSpecial() : "");
            data.put("wt", a.getWeightWorn() != null ? a.getWeightWorn() : 0);
            armourMap.put(a.getName(), data);
        });
        response.setArmourMap(armourMap);

        // Talents
        List<String> allTalentNames = talentRepository
                .findAll(Sort.by(Sort.Direction.ASC, "name"))
                .stream().map(Talent::getName).collect(Collectors.toList());
        response.setAllTalentNames(allTalentNames);

        Map<String, String> talentDescMap = new HashMap<>();
        talentRepository.findAll().forEach(t -> {
            if (t.getName() != null)
                talentDescMap.put(t.getName(), t.getDescription() != null ? t.getDescription() : "");
        });
        response.setTalentDescMap(talentDescMap);

        // Inventory names
        List<String> allInventoryNames = inventoryRepository
                .findAll(Sort.by(Sort.Direction.ASC, "name"))
                .stream().map(Inventory::getName).collect(Collectors.toList());
        response.setAllInventoryNames(allInventoryNames);

        // Melee weapons
        Map<String, Map<String, String>> meleeWeaponMap = new HashMap<>();
        meleeWeaponRepository.findAllWithSpec().forEach(w -> {
            Map<String, String> s = new LinkedHashMap<>();
            s.put("class",   w.getSpecialization() != null ? w.getSpecialization().getName() : "");
            s.put("damage",  w.getDamage() != null ? w.getDamage() : "");
            s.put("special", w.getSpecial() != null ? w.getSpecial() : "");
            s.put("wt",      w.getEncumbrance() != null ? String.valueOf(w.getEncumbrance()) : "");
            meleeWeaponMap.put(w.getName(), s);
        });
        response.setMeleeWeaponMap(meleeWeaponMap);

        // Ranged weapons
        Map<String, Map<String, String>> rangedWeaponMap = new HashMap<>();
        rangedWeaponRepository.findAllWithSpec().forEach(w -> {
            Map<String, String> s = new LinkedHashMap<>();
            s.put("class",   w.getSpecialization() != null ? w.getSpecialization().getName() : "");
            s.put("damage",  w.getDamage() != null ? String.valueOf(w.getDamage()) : "");
            s.put("range",   w.getRange() != null ? w.getRange().name() : "");
            s.put("clip",    w.getMagSize() != null ? String.valueOf(w.getMagSize()) : "");
            s.put("special", w.getSpecial() != null ? w.getSpecial() : "");
            s.put("wt",      w.getEncumbrance() != null ? String.valueOf(w.getEncumbrance()) : "");
            rangedWeaponMap.put(w.getName(), s);
        });
        response.setRangedWeaponMap(rangedWeaponMap);

        // Mutations
        List<String> allMutationNames = mutationRepository
                .findAll(Sort.by(Sort.Direction.ASC, "name"))
                .stream().map(Mutation::getName).collect(Collectors.toList());
        response.setAllMutationNames(allMutationNames);

        Map<String, String> mutationDescMap = new HashMap<>();
        mutationRepository.findAll().forEach(m -> {
            if (m.getName() != null)
                mutationDescMap.put(m.getName(), m.getDescription() != null ? m.getDescription() : "");
        });
        response.setMutationDescMap(mutationDescMap);

        // Augmetics
        List<InventoryCategory> augmeticCats = List.of(
                InventoryCategory.AUGMETIC, InventoryCategory.AUGMETIC_REPLACEMENTS);
        List<Inventory> augmeticItems = inventoryRepository.findByInventoryCategoryIn(
                augmeticCats, Sort.by(Sort.Direction.ASC, "name"));
        response.setAllAugmeticNames(augmeticItems.stream().map(Inventory::getName).collect(Collectors.toList()));

        Map<String, String> augmeticDescMap = new HashMap<>();
        augmeticItems.forEach(i -> {
            if (i instanceof GenericItem gi && gi.getName() != null)
                augmeticDescMap.put(gi.getName(), gi.getDescription() != null ? gi.getDescription() : "");
        });
        response.setAugmeticDescMap(augmeticDescMap);

        // Combat actions
        List<String> allActionNames = combatActionRepository
                .findAll(Sort.by(Sort.Direction.ASC, "name"))
                .stream().map(CombatAction::getName).collect(Collectors.toList());
        response.setAllActionNames(allActionNames);

        Map<String, String> actionDescMap = new HashMap<>();
        combatActionRepository.findAll().forEach(a -> {
            if (a.getName() != null)
                actionDescMap.put(a.getName(), a.getDescription() != null ? a.getDescription() : "");
        });
        response.setActionDescMap(actionDescMap);

        // Specialization metadata
        Map<String, Map<String, String>> allSpecMeta = new LinkedHashMap<>();
        skillSpecializationsRepository.findAll().forEach(ss -> {
            if (ss.getSpecialization() == null || ss.getSkill() == null) return;
            String specName = ss.getSpecialization().getName();
            String skillName = ss.getSkill().getName();
            String charAbbr = ss.getSkill().getCharacteristics() != null ? ss.getSkill().getCharacteristics().getName() : "";
            Map<String, String> meta = new LinkedHashMap<>();
            meta.put("skillName", skillName);
            meta.put("characteristicAbbr", charAbbr);
            allSpecMeta.put(specName, meta);
        });
        response.setAllSpecMeta(allSpecMeta);

        return response;
    }
}
