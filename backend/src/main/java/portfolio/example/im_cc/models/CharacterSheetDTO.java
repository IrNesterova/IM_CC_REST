package portfolio.example.im_cc.models;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CharacterSheetDTO {

    private String characterName;
    private String age;
    private String height;
    private String eyeType;
    private String hairColor;
    private String hairStyle;
    private String distinguishingFeatures;

    private String originName;
    private String factionName;
    private String roleName;

    private Map<String, String> characteristics;

    private List<SkillEntry> skills;
    private List<String> talents;
    private Map<String, Integer> talentAdvances = new HashMap<>();
    private List<String> equipment;
    private List<String> augmetics = new ArrayList<>();
    private List<SpecializationEntry> specializations = new ArrayList<>();
    private List<InjuryEntry> injuries = new ArrayList<>();

    private String startingMoney;

    private int fatePoints = 3;

    private String shortTermGoal;
    private String longTermGoal;
    private String connections;

    public static class InjuryEntry {
        private final String name;
        private final String affectedPart;
        private final String effect;
        private final String treatment;
        private final String notes;

        public InjuryEntry(String name, String affectedPart, String effect, String treatment, String notes) {
            this.name = name;
            this.affectedPart = affectedPart;
            this.effect = effect;
            this.treatment = treatment;
            this.notes = notes;
        }

        public String getName() { return name; }
        public String getAffectedPart() { return affectedPart; }
        public String getEffect() { return effect; }
        public String getTreatment() { return treatment; }
        public String getNotes() { return notes; }
    }

    public static class SkillEntry {
        private final String name;
        private final int advances;
        private final String characteristicAbbr;

        public SkillEntry(String name, int advances, String characteristicAbbr) {
            this.name = name;
            this.advances = advances;
            this.characteristicAbbr = characteristicAbbr;
        }

        public String getName() { return name; }
        public int getAdvances() { return advances; }
        public String getCharacteristicAbbr() { return characteristicAbbr; }
    }

    public static class SpecializationEntry {
        private final String name;
        private final String skillName;
        private final String characteristicAbbr;
        private final int advances;
        private final int skillAdvances;

        public SpecializationEntry(String name, String skillName, String characteristicAbbr, int advances, int skillAdvances) {
            this.name = name;
            this.skillName = skillName;
            this.characteristicAbbr = characteristicAbbr;
            this.advances = advances;
            this.skillAdvances = skillAdvances;
        }

        public String getName() { return name; }
        public String getSkillName() { return skillName; }
        public String getCharacteristicAbbr() { return characteristicAbbr; }
        public int getAdvances() { return advances; }
        public int getSkillAdvances() { return skillAdvances; }
    }

    public String getCharacterName() { return characterName; }
    public void setCharacterName(String characterName) { this.characterName = characterName; }

    public String getAge() { return age; }
    public void setAge(String age) { this.age = age; }

    public String getHeight() { return height; }
    public void setHeight(String height) { this.height = height; }

    public String getEyeType() { return eyeType; }
    public void setEyeType(String eyeType) { this.eyeType = eyeType; }

    public String getHairColor() { return hairColor; }
    public void setHairColor(String hairColor) { this.hairColor = hairColor; }

    public String getHairStyle() { return hairStyle; }
    public void setHairStyle(String hairStyle) { this.hairStyle = hairStyle; }

    public String getDistinguishingFeatures() { return distinguishingFeatures; }
    public void setDistinguishingFeatures(String distinguishingFeatures) { this.distinguishingFeatures = distinguishingFeatures; }

    public String getOriginName() { return originName; }
    public void setOriginName(String originName) { this.originName = originName; }

    public String getFactionName() { return factionName; }
    public void setFactionName(String factionName) { this.factionName = factionName; }

    public String getRoleName() { return roleName; }
    public void setRoleName(String roleName) { this.roleName = roleName; }

    public Map<String, String> getCharacteristics() { return characteristics; }
    public void setCharacteristics(Map<String, String> characteristics) { this.characteristics = characteristics; }

    public List<SkillEntry> getSkills() { return skills; }
    public void setSkills(List<SkillEntry> skills) { this.skills = skills; }

    public List<String> getTalents() { return talents; }
    public void setTalents(List<String> talents) { this.talents = talents; }

    public Map<String, Integer> getTalentAdvances() { return talentAdvances; }
    public void setTalentAdvances(Map<String, Integer> talentAdvances) { this.talentAdvances = talentAdvances; }

    public List<String> getEquipment() { return equipment; }
    public void setEquipment(List<String> equipment) { this.equipment = equipment; }

    public List<String> getAugmetics() { return augmetics; }
    public void setAugmetics(List<String> augmetics) { this.augmetics = augmetics; }

    public List<SpecializationEntry> getSpecializations() { return specializations; }
    public void setSpecializations(List<SpecializationEntry> specializations) { this.specializations = specializations; }

    public List<InjuryEntry> getInjuries() { return injuries; }
    public void setInjuries(List<InjuryEntry> injuries) { this.injuries = injuries; }

    public String getStartingMoney() { return startingMoney; }
    public void setStartingMoney(String startingMoney) { this.startingMoney = startingMoney; }

    public int getFatePoints() { return fatePoints; }
    public void setFatePoints(int fatePoints) { this.fatePoints = fatePoints; }

    public String getShortTermGoal() { return shortTermGoal; }
    public void setShortTermGoal(String shortTermGoal) { this.shortTermGoal = shortTermGoal; }

    public String getLongTermGoal() { return longTermGoal; }
    public void setLongTermGoal(String longTermGoal) { this.longTermGoal = longTermGoal; }

    public String getConnections() { return connections; }
    public void setConnections(String connections) { this.connections = connections; }
}