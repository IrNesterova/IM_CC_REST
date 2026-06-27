package portfolio.example.im_cc.models;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;

import java.util.List;

@Table
@Entity
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
public class Faction {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    public void setId(Long id) {
        this.id = id;
    }

    public Long getId() {
        return id;
    }

    @Column(columnDefinition = "text")
    private String name;

    @Column(columnDefinition = "text")
    private String influenceDescription;

    @Enumerated(EnumType.STRING)
    @Column(name = "source_book")
    private SourceBook sourceBook;


    @Transient
    private List<Talent> talentList;

    @Transient
    private List<Skill> skillList;

    @Transient
    private List<FactionInventory> inventoryList;

    @Transient
    private List<Characteristics> primaryCharacteristics;
    @Transient
    private List<Characteristics> secondaryCharacteristics;
    @Transient
    private List<FactionChoiceGroup> choiceGroups;

    @Transient
    private List<FactionGrade> grades;

    public List<Talent> getTalentList() {
        return talentList;
    }

    public void setTalentList(List<Talent> talentList) {
        this.talentList = talentList;
    }

    public List<Skill> getSkillList() {
        return skillList;
    }

    public void setSkillList(List<Skill> skillList) {
        this.skillList = skillList;
    }

    public List<FactionInventory> getInventoryList() {
        return inventoryList;
    }

    public void setInventoryList(List<FactionInventory> inventoryList) {
        this.inventoryList = inventoryList;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public SourceBook getSourceBook() { return sourceBook; }
    public void setSourceBook(SourceBook sourceBook) { this.sourceBook = sourceBook; }

    public List<Characteristics> getPrimaryCharacteristics() {
        return primaryCharacteristics;
    }

    public void setPrimaryCharacteristics(List<Characteristics> primaryCharacteristics) {
        this.primaryCharacteristics = primaryCharacteristics;
    }

    public List<Characteristics> getSecondaryCharacteristics() {
        return secondaryCharacteristics;
    }

    public void setSecondaryCharacteristics(List<Characteristics> secondaryCharacteristics) {
        this.secondaryCharacteristics = secondaryCharacteristics;
    }

    public List<FactionChoiceGroup> getChoiceGroups() {
        return choiceGroups;
    }

    public void setChoiceGroups(List<FactionChoiceGroup> choiceGroups) {
        this.choiceGroups = choiceGroups;
    }

    public List<FactionGrade> getGrades() { return grades; }
    public void setGrades(List<FactionGrade> grades) { this.grades = grades; }
}
