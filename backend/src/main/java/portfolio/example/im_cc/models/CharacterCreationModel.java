package portfolio.example.im_cc.models;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CharacterCreationModel {
    private Long originId;
    private Long factionId;
    private Long roleId;
    private Map<String, String> characteristics = new HashMap<>();
    private Map<Long, Integer> factionSkillAdvances = new HashMap<>();
    private Map<Long, List<Long>> factionChoices = new HashMap<>();
    private Map<Long, List<Long>> roleChoices = new HashMap<>();
    private Map<Long, Integer> roleSkillAdvances = new HashMap<>();
    private Map<Long, Integer> roleSpecAdvances = new HashMap<>();
    private Map<Long, Long> itemVariantChoices = new HashMap<>();

    // Equipment Pack step
    private Long equipmentPackId;
    private boolean equipmentStepDone;

    // Characteristic bonuses stored for progress bar display
    private String originPrimaryCharNames;   // comma-separated abbreviations, e.g. "WS, AG"
    private String originSecondaryCharName;  // abbreviation of chosen secondary, e.g. "FEL"
    private String factionPrimaryCharNames;
    private String factionSecondaryCharName;

    // Adding Detail
    private String characterName;
    private String age;
    private String eyeType;
    private String hairColor;
    private String hairStyle;
    private String height;
    private String distinguishingFeatures;
    private String shortTermGoal;
    private String longTermGoal;
    private String connections;


    public Map<String, String> getCharacteristics() {
        return characteristics;
    }

    public void setCharacteristics(Map<String, String> characteristics) {
        this.characteristics = characteristics;
    }

    public Long getOriginId() {
        return originId;
    }

    public void setOriginId(Long originId) {
        this.originId = originId;
    }

    public Map<Long, Integer> getFactionSkillAdvances() {
        return factionSkillAdvances;
    }

    public void setFactionSkillAdvances(Map<Long, Integer> factionSkillAdvances) {
        this.factionSkillAdvances = factionSkillAdvances;
    }

    public Map<Long, List<Long>> getFactionChoices() {
        return factionChoices;
    }

    public void setFactionChoices(Map<Long, List<Long>> factionChoices) {
        this.factionChoices = factionChoices;
    }

    public Long getFactionId() {
        return factionId;
    }

    public void setFactionId(Long factionId) {
        this.factionId = factionId;
    }

    public Long getRoleId() {
        return roleId;
    }

    public void setRoleId(Long roleId) {
        this.roleId = roleId;
    }

    public Map<Long, List<Long>> getRoleChoices() {
        return roleChoices;
    }

    public void setRoleChoices(Map<Long, List<Long>> roleChoices) {
        this.roleChoices = roleChoices;
    }

    public String getCharacterName() { return characterName; }
    public void setCharacterName(String characterName) { this.characterName = characterName; }

    public String getAge() { return age; }
    public void setAge(String age) { this.age = age; }

    public String getEyeType() { return eyeType; }
    public void setEyeType(String eyeType) { this.eyeType = eyeType; }

    public String getHairColor() { return hairColor; }
    public void setHairColor(String hairColor) { this.hairColor = hairColor; }

    public String getHairStyle() { return hairStyle; }
    public void setHairStyle(String hairStyle) { this.hairStyle = hairStyle; }

    public String getHeight() { return height; }
    public void setHeight(String height) { this.height = height; }

    public String getDistinguishingFeatures() { return distinguishingFeatures; }
    public void setDistinguishingFeatures(String distinguishingFeatures) { this.distinguishingFeatures = distinguishingFeatures; }

    public String getShortTermGoal() { return shortTermGoal; }
    public void setShortTermGoal(String shortTermGoal) { this.shortTermGoal = shortTermGoal; }

    public String getLongTermGoal() { return longTermGoal; }
    public void setLongTermGoal(String longTermGoal) { this.longTermGoal = longTermGoal; }

    public String getConnections() { return connections; }
    public void setConnections(String connections) { this.connections = connections; }

    public Long getEquipmentPackId() { return equipmentPackId; }
    public void setEquipmentPackId(Long equipmentPackId) { this.equipmentPackId = equipmentPackId; }
    public boolean isEquipmentStepDone() { return equipmentStepDone; }
    public void setEquipmentStepDone(boolean equipmentStepDone) { this.equipmentStepDone = equipmentStepDone; }

    public String getOriginPrimaryCharNames() { return originPrimaryCharNames; }
    public void setOriginPrimaryCharNames(String originPrimaryCharNames) { this.originPrimaryCharNames = originPrimaryCharNames; }
    public String getOriginSecondaryCharName() { return originSecondaryCharName; }
    public void setOriginSecondaryCharName(String originSecondaryCharName) { this.originSecondaryCharName = originSecondaryCharName; }
    public String getFactionPrimaryCharNames() { return factionPrimaryCharNames; }
    public void setFactionPrimaryCharNames(String factionPrimaryCharNames) { this.factionPrimaryCharNames = factionPrimaryCharNames; }
    public String getFactionSecondaryCharName() { return factionSecondaryCharName; }
    public void setFactionSecondaryCharName(String factionSecondaryCharName) { this.factionSecondaryCharName = factionSecondaryCharName; }

    public Map<Long, Integer> getRoleSkillAdvances() { return roleSkillAdvances; }
    public void setRoleSkillAdvances(Map<Long, Integer> roleSkillAdvances) { this.roleSkillAdvances = roleSkillAdvances; }

    public Map<Long, Integer> getRoleSpecAdvances() { return roleSpecAdvances; }
    public void setRoleSpecAdvances(Map<Long, Integer> roleSpecAdvances) { this.roleSpecAdvances = roleSpecAdvances; }

    public Map<Long, Long> getItemVariantChoices() { return itemVariantChoices; }
    public void setItemVariantChoices(Map<Long, Long> itemVariantChoices) { this.itemVariantChoices = itemVariantChoices; }
}
