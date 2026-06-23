package portfolio.example.im_cc.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import portfolio.example.im_cc.models.*;
import portfolio.example.im_cc.repositories.*;

import java.util.*;
import java.util.stream.Collectors;

@Service
public class FactionServiceImpl implements FactionService {
    @Autowired
    FactionRepository factionRepository;
    @Autowired
    FactionTalentRepository factionTalentRepository;
    @Autowired
    SkillFactionRepository skillFactionRepository;
    @Autowired
    FactionInventoryRepository factionInventoryRepository;
    @Autowired
    CharacteristicsFactionRepository characteristicsFactionRepository;
    @Autowired
    FactionChoiceGroupRepository factionChoiceGroupRepository;
    @Autowired
    FactionInventoryChoiceRepository inventoryChoiceRepository;
    @Autowired
    FactionTalentChoiceRepository talentChoiceRepository;

    @Override
    public List<Faction> getAllFactions() {
        return factionRepository.findAll(Sort.by(Sort.Direction.ASC, "id"));

    }
    @Override
    public List<Faction> getAllFactionsWithAdds() {

        List<Faction> factionList =
                factionRepository.findAll(
                        Sort.by(Sort.Direction.ASC, "id")
                );

        Map<Long, Faction> factionMap = factionList.stream().collect(Collectors.toMap(Faction::getId, f->f));

        factionList.forEach(f -> {
            f.setPrimaryCharacteristics(new ArrayList<>());
            f.setSecondaryCharacteristics(new ArrayList<>());
            f.setTalentList(new ArrayList<>());
            f.setSkillList(new ArrayList<>());
            f.setInventoryList(new ArrayList<>());
            f.setChoiceGroups(new ArrayList<>());
        });


        characteristicsFactionRepository.findByFactionIn(factionList)
                .forEach(cf -> {
                    Faction f = factionMap.get(cf.getFaction().getId());
                    if (cf.isPrimaryChar()) f.getPrimaryCharacteristics().add(cf.getCharacteristics());
                    else f.getSecondaryCharacteristics().add(cf.getCharacteristics());
                });

        // === 1 запрос: все таланты ===
        factionTalentRepository.findAllByFactionIn(factionList)
                .forEach(ft -> factionMap.get(ft.getFaction().getId())
                        .getTalentList().add(ft.getTalent()));

        // === 1 запрос: все скиллы ===
        skillFactionRepository.findByFactionIn(factionList)
                .forEach(sf -> factionMap.get(sf.getFaction().getId())
                        .getSkillList().add(sf.getSkill()));

        // === 1 запрос: весь инвентарь ===
        factionInventoryRepository.findByFactionIn(factionList)
                .forEach(fi -> factionMap.get(fi.getFaction().getId())
                        .getInventoryList().add(fi.getInventory()));

        // === 1 запрос: все группы выборов ===
        List<FactionChoiceGroup> allGroups = factionChoiceGroupRepository.findByFactionIn(factionList);
        Map<Long, FactionChoiceGroup> groupMap = allGroups.stream()
                .collect(Collectors.toMap(FactionChoiceGroup::getId, g -> g));

        allGroups.forEach(g -> {
            g.setOptions(new ArrayList<>());
            factionMap.get(g.getFaction().getId()).getChoiceGroups().add(g);
        });

        // === 1 запрос: все talent choices ===
        Map<Long, Map<Long, ChoiceOption>> optionsByGroup = new HashMap<>();
        allGroups.forEach(g -> optionsByGroup.put(g.getId(), new LinkedHashMap<>()));

        talentChoiceRepository.findByFactionChoiceGroupIn(allGroups)
                .forEach(tc -> {
                    Map<Long, ChoiceOption> optionMap = optionsByGroup.get(tc.getFactionChoiceGroup().getId());
                    ChoiceOption opt = optionMap.computeIfAbsent(tc.getOption_id(), id -> {
                        ChoiceOption o = new ChoiceOption();
                        o.setId(id);
                        o.setTalents(new ArrayList<>());
                        o.setInventory(new ArrayList<>());
                        return o;
                    });
                    opt.getTalents().add(tc.getTalent());
                });

        // === 1 запрос: все inventory choices ===
        inventoryChoiceRepository.findByFactionChoiceGroupIn(allGroups)
                .forEach(fic -> {
                    Map<Long, ChoiceOption> optionMap = optionsByGroup.get(fic.getFactionChoiceGroup().getId());
                    ChoiceOption opt = optionMap.computeIfAbsent(fic.getId(), id -> {
                        ChoiceOption o = new ChoiceOption();
                        o.setId(id);
                        o.setTalents(new ArrayList<>());
                        o.setInventory(new ArrayList<>());
                        return o;
                    });
                    opt.getInventory().add(fic.getInventory());
                });

        // Собираем options в группы
        allGroups.forEach(g -> g.setOptions(new ArrayList<>(optionsByGroup.get(g.getId()).values())));


        return factionList;
    }
    @Override
    public Faction getById(Long id) {
        return factionRepository.getFactionById(id);

    }

    @Override
    public Faction getFactionWithAdds(Long id) {
        Faction faction = factionRepository.findById(id).orElseThrow();

        // =========================================
        // CHARACTERISTICS
        // =========================================

        List<CharacteristicsFaction> allCf =
                characteristicsFactionRepository.findAllByFaction(faction);

        faction.setPrimaryCharacteristics(
                allCf.stream()
                        .filter(CharacteristicsFaction::isPrimaryChar)
                        .map(CharacteristicsFaction::getCharacteristics)
                        .collect(Collectors.toList())
        );

        faction.setSecondaryCharacteristics(
                allCf.stream()
                        .filter(cf -> !cf.isPrimaryChar())
                        .map(CharacteristicsFaction::getCharacteristics)
                        .collect(Collectors.toList())
        );

        // =========================================
        // TALENTS
        // =========================================

        faction.setTalentList(
                factionTalentRepository.findFactionTalentsByFaction(faction)
                        .stream()
                        .map(FactionTalent::getTalent)
                        .collect(Collectors.toList())
        );

        // =========================================
        // SKILLS
        // =========================================

        faction.setSkillList(
                skillFactionRepository.findSkillFactionsByFaction(faction)
                        .stream()
                        .map(SkillFactions::getSkill)
                        .collect(Collectors.toList())
        );

        // =========================================
        // INVENTORY
        // =========================================

        faction.setInventoryList(
                factionInventoryRepository.findFactionInventoriesByFaction(faction)
                        .stream()
                        .map(FactionInventory::getInventory)
                        .collect(Collectors.toList())
        );

        // =========================================
        // CHOICE GROUPS
        // =========================================

        List<FactionChoiceGroup> groups =
                factionChoiceGroupRepository.findByFaction(faction);

        Map<Long, ChoiceOption> optionMap = new LinkedHashMap<>();

        talentChoiceRepository.findByFactionChoiceGroupIn(groups)
                .forEach(tc -> {
                    ChoiceOption opt = optionMap.computeIfAbsent(tc.getOption_id(), optId -> {
                        ChoiceOption o = new ChoiceOption();
                        o.setId(optId);
                        o.setTalents(new ArrayList<>());
                        o.setInventory(new ArrayList<>());
                        return o;
                    });
                    opt.getTalents().add(tc.getTalent());
                });

        inventoryChoiceRepository.findByFactionChoiceGroupIn(groups)
                .forEach(fic -> {
                    ChoiceOption opt = optionMap.computeIfAbsent(fic.getId(), optId -> {
                        ChoiceOption o = new ChoiceOption();
                        o.setId(optId);
                        o.setTalents(new ArrayList<>());
                        o.setInventory(new ArrayList<>());
                        return o;
                    });
                    opt.getInventory().add(fic.getInventory());
                });

        groups.forEach(g -> g.setOptions(new ArrayList<>(optionMap.values())));
        faction.setChoiceGroups(groups);

        return faction;
    }
}
