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
    @Autowired
    FactionGradeRepository factionGradeRepository;
    @Autowired
    FactionGradeCharChoiceRepository gradeCharChoiceRepository;
    @Autowired
    FactionGradeSkillRepository gradeSkillRepository;
    @Autowired
    FactionGradeInventoryRepository gradeInventoryRepository;
    @Autowired
    FactionGradeTalentRepository gradeTalentRepository;
    @Autowired
    FactionGradeChoiceGroupRepository gradeChoiceGroupRepository;
    @Autowired
    FactionGradeInventoryChoiceRepository gradeInventoryChoiceRepository;
    @Autowired
    FactionGradeTalentChoiceRepository gradeTalentChoiceRepository;

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
                        .getInventoryList().add(fi));

        // === 1 запрос: все группы выборов ===
        List<FactionChoiceGroup> allGroups = factionChoiceGroupRepository.findByFactionIn(factionList)
                .stream().distinct().collect(Collectors.toList());
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
                        o.setModifiers(new ArrayList<>());
                        return o;
                    });
                    opt.getInventory().add(fic.getInventory());
                    opt.getModifiers().addAll(fic.getModifiers());
                });

        // Собираем options в группы
        allGroups.forEach(g -> g.setOptions(new ArrayList<>(optionsByGroup.get(g.getId()).values())));

        // === GRADES (только AM-фракции) ===
        List<Faction> amFactions = factionList.stream()
                .filter(f -> f.getSourceBook() == SourceBook.AM)
                .collect(Collectors.toList());
        if (!amFactions.isEmpty()) {
            loadGrades(amFactions, factionMap);
        }

        return factionList;
    }

    private void loadGrades(List<Faction> amFactions, Map<Long, Faction> factionMap) {
        List<FactionGrade> allGrades = factionGradeRepository.findByFactionIn(amFactions);
        Map<Long, FactionGrade> gradeMap = allGrades.stream()
                .collect(Collectors.toMap(FactionGrade::getId, g -> g));

        allGrades.forEach(g -> {
            g.setCharChoices(new ArrayList<>());
            g.setAllowedSkills(new ArrayList<>());
            g.setFixedInventory(new ArrayList<>());
            g.setFixedTalents(new ArrayList<>());
            g.setChoiceGroups(new ArrayList<>());
            Faction f = factionMap.get(g.getFaction().getId());
            if (f.getGrades() == null) f.setGrades(new ArrayList<>());
            f.getGrades().add(g);
        });

        gradeCharChoiceRepository.findByGradeIn(allGrades)
                .forEach(gcc -> gradeMap.get(gcc.getGrade().getId())
                        .getCharChoices().add(gcc.getCharacteristics()));

        gradeSkillRepository.findByGradeIn(allGrades)
                .forEach(gs -> gradeMap.get(gs.getGrade().getId())
                        .getAllowedSkills().add(gs.getSkill()));

        gradeInventoryRepository.findByGradeIn(allGrades)
                .forEach(gi -> gradeMap.get(gi.getGrade().getId())
                        .getFixedInventory().add(gi));

        gradeTalentRepository.findByGradeIn(allGrades)
                .forEach(gt -> gradeMap.get(gt.getGrade().getId())
                        .getFixedTalents().add(gt.getTalent()));

        List<FactionGradeChoiceGroup> allChoiceGroups = gradeChoiceGroupRepository.findByGradeIn(allGrades)
                .stream().distinct().collect(Collectors.toList());
        Map<Long, FactionGradeChoiceGroup> choiceGroupMap = allChoiceGroups.stream()
                .collect(Collectors.toMap(FactionGradeChoiceGroup::getId, cg -> cg));

        allChoiceGroups.forEach(cg -> {
            cg.setInventoryOptions(new ArrayList<>());
            cg.setTalentOptions(new ArrayList<>());
            gradeMap.get(cg.getGrade().getId()).getChoiceGroups().add(cg);
        });

        gradeInventoryChoiceRepository.findByChoiceGroupIn(allChoiceGroups)
                .forEach(ic -> choiceGroupMap.get(ic.getChoiceGroup().getId())
                        .getInventoryOptions().add(ic));

        gradeTalentChoiceRepository.findByChoiceGroupIn(allChoiceGroups)
                .forEach(tc -> choiceGroupMap.get(tc.getChoiceGroup().getId())
                        .getTalentOptions().add(tc.getTalent()));
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
        );

        // =========================================
        // CHOICE GROUPS
        // =========================================

        List<FactionChoiceGroup> groups =
                factionChoiceGroupRepository.findByFaction(faction);

        Map<Long, Map<Long, ChoiceOption>> optionsByGroup = new HashMap<>();
        groups.forEach(g -> {
            g.setOptions(new ArrayList<>());
            optionsByGroup.put(g.getId(), new LinkedHashMap<>());
        });

        talentChoiceRepository.findByFactionChoiceGroupIn(groups)
                .forEach(tc -> {
                    Map<Long, ChoiceOption> optionMap = optionsByGroup.get(tc.getFactionChoiceGroup().getId());
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
                    Map<Long, ChoiceOption> optionMap = optionsByGroup.get(fic.getFactionChoiceGroup().getId());
                    ChoiceOption opt = optionMap.computeIfAbsent(fic.getId(), optId -> {
                        ChoiceOption o = new ChoiceOption();
                        o.setId(optId);
                        o.setTalents(new ArrayList<>());
                        o.setInventory(new ArrayList<>());
                        return o;
                    });
                    opt.getInventory().add(fic.getInventory());
                });

        groups.forEach(g -> g.setOptions(new ArrayList<>(optionsByGroup.get(g.getId()).values())));
        faction.setChoiceGroups(groups);

        // === GRADES (только AM) ===
        if (faction.getSourceBook() == SourceBook.AM) {
            Map<Long, Faction> singleMap = Map.of(faction.getId(), faction);
            loadGrades(List.of(faction), singleMap);
        }

        return faction;
    }
}
