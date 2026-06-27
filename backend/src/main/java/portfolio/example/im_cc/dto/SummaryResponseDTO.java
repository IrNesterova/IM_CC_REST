package portfolio.example.im_cc.dto;

import portfolio.example.im_cc.models.CharacterSheetDTO;

import java.util.List;
import java.util.Map;

public class SummaryResponseDTO {

    private CharacterSheetDTO sheet;

    // Armour stats: name → {ap, locations, special, wt}
    private Map<String, Map<String, Object>> armourMap;

    // Talent lookup
    private List<String> allTalentNames;
    private Map<String, String> talentDescMap;
    // talentName → advanceNumber → effect text
    private Map<String, Map<Integer, String>> talentAdvEffectsMap;
    // talentName → maxAdvances (only for multi-advance talents)
    private Map<String, Integer> talentMaxAdvancesMap;
    // talentName → list of {name, effect} for choice=true options
    private Map<String, List<Map<String, String>>> talentOptionsMap;

    // Inventory lookup
    private List<String> allInventoryNames;

    // Melee weapon stats: name → {class, damage, special, wt}
    private Map<String, Map<String, String>> meleeWeaponMap;

    // Ranged weapon stats: name → {class, damage, range, clip, special, wt}
    private Map<String, Map<String, String>> rangedWeaponMap;

    // Mutation lookup
    private List<String> allMutationNames;
    private Map<String, String> mutationDescMap;
    private Map<Long, String> mutationIdToNameMap;

    // Augmetic lookup
    private List<String> allAugmeticNames;
    private Map<String, String> augmeticDescMap;

    // Combat action lookup
    private List<String> allActionNames;
    private Map<String, String> actionDescMap;

    // Specialization metadata: specName → { skillName, characteristicAbbr }
    private Map<String, Map<String, String>> allSpecMeta;

    public CharacterSheetDTO getSheet() { return sheet; }
    public void setSheet(CharacterSheetDTO sheet) { this.sheet = sheet; }

    public Map<String, Map<String, Object>> getArmourMap() { return armourMap; }
    public void setArmourMap(Map<String, Map<String, Object>> armourMap) { this.armourMap = armourMap; }

    public List<String> getAllTalentNames() { return allTalentNames; }
    public void setAllTalentNames(List<String> allTalentNames) { this.allTalentNames = allTalentNames; }

    public Map<String, String> getTalentDescMap() { return talentDescMap; }
    public void setTalentDescMap(Map<String, String> talentDescMap) { this.talentDescMap = talentDescMap; }

    public Map<String, Map<Integer, String>> getTalentAdvEffectsMap() { return talentAdvEffectsMap; }
    public void setTalentAdvEffectsMap(Map<String, Map<Integer, String>> talentAdvEffectsMap) { this.talentAdvEffectsMap = talentAdvEffectsMap; }

    public Map<String, Integer> getTalentMaxAdvancesMap() { return talentMaxAdvancesMap; }
    public void setTalentMaxAdvancesMap(Map<String, Integer> talentMaxAdvancesMap) { this.talentMaxAdvancesMap = talentMaxAdvancesMap; }

    public Map<String, List<Map<String, String>>> getTalentOptionsMap() { return talentOptionsMap; }
    public void setTalentOptionsMap(Map<String, List<Map<String, String>>> talentOptionsMap) { this.talentOptionsMap = talentOptionsMap; }

    public List<String> getAllInventoryNames() { return allInventoryNames; }
    public void setAllInventoryNames(List<String> allInventoryNames) { this.allInventoryNames = allInventoryNames; }

    public Map<String, Map<String, String>> getMeleeWeaponMap() { return meleeWeaponMap; }
    public void setMeleeWeaponMap(Map<String, Map<String, String>> meleeWeaponMap) { this.meleeWeaponMap = meleeWeaponMap; }

    public Map<String, Map<String, String>> getRangedWeaponMap() { return rangedWeaponMap; }
    public void setRangedWeaponMap(Map<String, Map<String, String>> rangedWeaponMap) { this.rangedWeaponMap = rangedWeaponMap; }

    public List<String> getAllMutationNames() { return allMutationNames; }
    public void setAllMutationNames(List<String> allMutationNames) { this.allMutationNames = allMutationNames; }

    public Map<String, String> getMutationDescMap() { return mutationDescMap; }
    public void setMutationDescMap(Map<String, String> mutationDescMap) { this.mutationDescMap = mutationDescMap; }

    public Map<Long, String> getMutationIdToNameMap() { return mutationIdToNameMap; }
    public void setMutationIdToNameMap(Map<Long, String> mutationIdToNameMap) { this.mutationIdToNameMap = mutationIdToNameMap; }

    public List<String> getAllAugmeticNames() { return allAugmeticNames; }
    public void setAllAugmeticNames(List<String> allAugmeticNames) { this.allAugmeticNames = allAugmeticNames; }

    public Map<String, String> getAugmeticDescMap() { return augmeticDescMap; }
    public void setAugmeticDescMap(Map<String, String> augmeticDescMap) { this.augmeticDescMap = augmeticDescMap; }

    public List<String> getAllActionNames() { return allActionNames; }
    public void setAllActionNames(List<String> allActionNames) { this.allActionNames = allActionNames; }

    public Map<String, String> getActionDescMap() { return actionDescMap; }
    public void setActionDescMap(Map<String, String> actionDescMap) { this.actionDescMap = actionDescMap; }

    public Map<String, Map<String, String>> getAllSpecMeta() { return allSpecMeta; }
    public void setAllSpecMeta(Map<String, Map<String, String>> allSpecMeta) { this.allSpecMeta = allSpecMeta; }
}
