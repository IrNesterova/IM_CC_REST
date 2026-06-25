package portfolio.example.im_cc.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import portfolio.example.im_cc.models.*;
import portfolio.example.im_cc.repositories.*;

import java.util.*;

@Service
public class SummaryServiceImpl {

    @Autowired OriginRepository originRepository;
    @Autowired FactionRepository factionRepository;
    @Autowired RoleRepository roleRepository;
    @Autowired SkillRepository skillRepository;
    @Autowired SpecializationRepository specializationRepository;
    @Autowired SkillSpecializationsRepository skillSpecializationsRepository;
    @Autowired FactionTalentRepository factionTalentRepository;
    @Autowired FactionInventoryRepository factionInventoryRepository;
    @Autowired FactionChoiceGroupRepository factionChoiceGroupRepository;
    @Autowired FactionTalentChoiceRepository factionTalentChoiceRepository;
    @Autowired FactionInventoryChoiceRepository factionInventoryChoiceRepository;
    @Autowired RoleInventoryRepository roleInventoryRepository;
    @Autowired RoleChoiceGroupRepository roleChoiceGroupRepository;
    @Autowired RoleTalentChoiceGroupRepository roleTalentChoiceGroupRepository;
    @Autowired RoleInventoryChoiceGroupRepository roleInventoryChoiceGroupRepository;
    @Autowired portfolio.example.im_cc.repositories.EquipmentPackItemRepository equipmentPackItemRepository;

    private static String resolveItemName(Inventory inv, Map<Long, Long> variantChoices) {
        if (variantChoices == null || inv.getVariants().isEmpty()) return inv.getName();
        Long variantId = variantChoices.get(inv.getId());
        if (variantId == null) return inv.getName();
        return inv.getVariants().stream()
            .filter(v -> variantId.equals(v.getId()))
            .findFirst()
            .map(v -> inv.getName() + " (" + v.getName() + ")")
            .orElse(inv.getName());
    }

    private static boolean isAugmetic(Inventory inv) {
        InventoryCategory cat = inv.getInventoryCategory();
        return cat == InventoryCategory.AUGMETIC || cat == InventoryCategory.AUGMETIC_REPLACEMENTS;
    }

    public CharacterSheetDTO build(CharacterCreationModel ccm) {
        CharacterSheetDTO dto = new CharacterSheetDTO();

        dto.setCharacterName(ccm.getCharacterName());
        dto.setAge(ccm.getAge());
        dto.setHeight(ccm.getHeight());
        dto.setEyeType(ccm.getEyeType());
        dto.setHairColor(ccm.getHairColor());
        dto.setHairStyle(ccm.getHairStyle());
        dto.setDistinguishingFeatures(ccm.getDistinguishingFeatures());
        dto.setShortTermGoal(ccm.getShortTermGoal());
        dto.setLongTermGoal(ccm.getLongTermGoal());
        dto.setConnections(ccm.getConnections());
        dto.setCharacteristics(ccm.getCharacteristics());

        if (ccm.getOriginId() != null) {
            originRepository.findById(ccm.getOriginId())
                .ifPresent(o -> dto.setOriginName(o.getName()));
        }
        if (ccm.getFactionId() != null) {
            factionRepository.findById(ccm.getFactionId())
                .ifPresent(f -> dto.setFactionName(f.getName()));
        }
        if (ccm.getRoleId() != null) {
            roleRepository.findById(ccm.getRoleId())
                .ifPresent(r -> dto.setRoleName(r.getName()));
        }

        // ── SKILLS ────────────────────────────────────────────────────
        Map<Long, Integer> combinedSkillAdvances = new HashMap<>();
        if (ccm.getFactionSkillAdvances() != null) {
            combinedSkillAdvances.putAll(ccm.getFactionSkillAdvances());
        }
        if (ccm.getRoleSkillAdvances() != null) {
            for (Map.Entry<Long, Integer> e : ccm.getRoleSkillAdvances().entrySet()) {
                combinedSkillAdvances.merge(e.getKey(), e.getValue(), Integer::sum);
            }
        }

        List<Skill> allSkills = skillRepository.findAll(Sort.by(Sort.Direction.ASC, "id"));
        List<CharacterSheetDTO.SkillEntry> skills = new ArrayList<>();
        for (Skill skill : allSkills) {
            int advances = combinedSkillAdvances.getOrDefault(skill.getId(), 0);
            String charAbbr = (skill.getCharacteristics() != null) ? skill.getCharacteristics().getName() : "";
            skills.add(new CharacterSheetDTO.SkillEntry(skill.getName(), advances, charAbbr));
        }
        dto.setSkills(skills);

        // ── TALENTS & EQUIPMENT ───────────────────────────────────────
        List<String> talents = new ArrayList<>();
        List<String> equipment = new ArrayList<>();
        List<String> augmetics = new ArrayList<>();

        boolean usePack = ccm.getEquipmentPackId() != null;

        if (ccm.getFactionId() != null) {
            Faction faction = factionRepository.findById(ccm.getFactionId()).orElseThrow();

            factionTalentRepository.findFactionTalentsByFaction(faction)
                .forEach(ft -> talents.add(ft.getTalent().getName()));
            if (!usePack) {
                factionInventoryRepository.findFactionInventoriesByFaction(faction)
                    .forEach(fi -> {
                        Inventory inv = fi.getInventory();
                        if (inv != null && inv.getId() == 1L) {
                            String qty = fi.getQuantity();
                            dto.setStartingMoney(qty != null ? qty : inv.getName());
                        } else if (inv != null) {
                            String name = resolveItemName(inv, ccm.getItemVariantChoices());
                            equipment.add(name);
                            if (isAugmetic(inv)) augmetics.add(name);
                        }
                    });
            }

            for (Map.Entry<Long, List<Long>> entry : ccm.getFactionChoices().entrySet()) {
                FactionChoiceGroup group = factionChoiceGroupRepository
                    .findById(entry.getKey()).orElse(null);
                if (group == null) continue;
                List<Long> optionIds = entry.getValue();
                if (optionIds == null) continue;
                for (Long optionId : optionIds) {
                    factionTalentChoiceRepository.findByFactionChoiceGroup(group).stream()
                        .filter(tc -> optionId.equals(tc.getOption_id()))
                        .forEach(tc -> talents.add(tc.getTalent().getName()));
                    if (!usePack) {
                        factionInventoryChoiceRepository.findById(optionId)
                            .ifPresent(fic -> {
                                Inventory inv = fic.getInventory();
                                String name = resolveItemName(inv, ccm.getItemVariantChoices());
                                equipment.add(name);
                                if (isAugmetic(inv)) augmetics.add(name);
                            });
                    }
                }
            }
        }

        if (ccm.getRoleId() != null) {
            Role role = roleRepository.findById(ccm.getRoleId()).orElseThrow();

            if (!usePack) {
                roleInventoryRepository.findByRole(role)
                    .forEach(ri -> {
                        Inventory inv = ri.getInventory();
                        String name = resolveItemName(inv, ccm.getItemVariantChoices());
                        equipment.add(name);
                        if (isAugmetic(inv)) augmetics.add(name);
                    });
            }

            List<RoleChoiceGroup> groups = roleChoiceGroupRepository.findByRole(role);
            for (RoleChoiceGroup group : groups) {
                List<Long> selected = ccm.getRoleChoices().getOrDefault(group.getId(), List.of());
                if (selected.isEmpty()) continue;

                switch (group.getChoiceType()) {
                    case TALENT -> roleTalentChoiceGroupRepository
                        .findByRoleChoiceGroup(group).stream()
                        .filter(r -> selected.contains(r.getTalent().getId()))
                        .forEach(r -> talents.add(r.getTalent().getName()));
                    case INVENTORY -> {
                        if (!usePack) {
                            roleInventoryChoiceGroupRepository
                                .findByRoleChoiceGroup(group).stream()
                                .filter(r -> selected.contains(r.getInventory().getId()))
                                .forEach(r -> {
                                    Inventory inv = r.getInventory();
                                    String name = resolveItemName(inv, ccm.getItemVariantChoices());
                                    equipment.add(name);
                                    if (isAugmetic(inv)) augmetics.add(name);
                                });
                        }
                    }
                }
            }
        }

        if (usePack) {
            equipmentPackItemRepository.findByEquipmentPackId(ccm.getEquipmentPackId())
                .forEach(item -> {
                    if (item.getInventory() != null) {
                        int qty = item.getQuantity() != null ? item.getQuantity() : 1;
                        String entry = qty > 1 ? qty + "× " + item.getInventory().getName()
                                               : item.getInventory().getName();
                        equipment.add(entry);
                        if (isAugmetic(item.getInventory())) augmetics.add(item.getInventory().getName());
                    } else if (item.getNote() != null) {
                        if (item.getNote().matches("(?i).*\\d+\\s*solars?.*")) {
                            dto.setStartingMoney(item.getNote());
                        } else {
                            equipment.add(item.getNote());
                        }
                    }
                });
        }

        dto.setTalents(talents);
        dto.setEquipment(equipment);
        dto.setAugmetics(augmetics);

        // ── FATE POINTS ───────────────────────────────────────────────
        boolean fated = talents.stream().anyMatch(t -> t.equalsIgnoreCase("Fated"));
        dto.setFatePoints(fated ? 4 : 3);

        // ── SPECIALIZATIONS ───────────────────────────────────────────
        List<CharacterSheetDTO.SpecializationEntry> specs = new ArrayList<>();
        if (ccm.getRoleSpecAdvances() != null) {
            for (Map.Entry<Long, Integer> e : ccm.getRoleSpecAdvances().entrySet()) {
                if (e.getValue() <= 0) continue;
                specializationRepository.findById(e.getKey()).ifPresent(spec -> {
                    List<SkillSpecializations> links =
                        skillSpecializationsRepository.findBySpecializationIn(List.of(spec));
                    String skillName = "";
                    String charAbbr = "";
                    int parentSkillAdv = 0;
                    if (!links.isEmpty()) {
                        Skill parentSkill = links.get(0).getSkill();
                        skillName = parentSkill.getName();
                        charAbbr = (parentSkill.getCharacteristics() != null)
                            ? parentSkill.getCharacteristics().getName() : "";
                        parentSkillAdv = combinedSkillAdvances.getOrDefault(parentSkill.getId(), 0);
                    }
                    specs.add(new CharacterSheetDTO.SpecializationEntry(
                        spec.getName(), skillName, charAbbr, e.getValue(), parentSkillAdv));
                });
            }
        }
        specs.sort(Comparator.comparing(CharacterSheetDTO.SpecializationEntry::getName));
        dto.setSpecializations(specs);

        return dto;
    }
}