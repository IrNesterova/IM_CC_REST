package portfolio.example.im_cc.models;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;

import java.util.List;

@Entity
@Table(name = "faction_grade")
public class FactionGrade {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "faction_id")
    @JsonIgnore
    private Faction faction;

    @Column(name = "grade_number")
    private int gradeNumber;

    private String name;

    @Column(columnDefinition = "text")
    private String description;

    @Column(name = "skill_pool_size")
    private int skillPoolSize;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "fixed_char_id")
    private Characteristics fixedChar;

    @Column(name = "fixed_char_amount")
    private int fixedCharAmount;

    @Transient
    private List<Characteristics> charChoices;

    @Transient
    private List<Skill> allowedSkills;

    @Transient
    private List<FactionGradeInventory> fixedInventory;

    @Transient
    private List<Talent> fixedTalents;

    @Transient
    private List<FactionGradeChoiceGroup> choiceGroups;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Faction getFaction() { return faction; }
    public void setFaction(Faction faction) { this.faction = faction; }

    public int getGradeNumber() { return gradeNumber; }
    public void setGradeNumber(int gradeNumber) { this.gradeNumber = gradeNumber; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public int getSkillPoolSize() { return skillPoolSize; }
    public void setSkillPoolSize(int skillPoolSize) { this.skillPoolSize = skillPoolSize; }

    public Characteristics getFixedChar() { return fixedChar; }
    public void setFixedChar(Characteristics fixedChar) { this.fixedChar = fixedChar; }

    public int getFixedCharAmount() { return fixedCharAmount; }
    public void setFixedCharAmount(int fixedCharAmount) { this.fixedCharAmount = fixedCharAmount; }

    public List<Characteristics> getCharChoices() { return charChoices; }
    public void setCharChoices(List<Characteristics> charChoices) { this.charChoices = charChoices; }

    public List<Skill> getAllowedSkills() { return allowedSkills; }
    public void setAllowedSkills(List<Skill> allowedSkills) { this.allowedSkills = allowedSkills; }

    public List<FactionGradeInventory> getFixedInventory() { return fixedInventory; }
    public void setFixedInventory(List<FactionGradeInventory> fixedInventory) { this.fixedInventory = fixedInventory; }

    public List<Talent> getFixedTalents() { return fixedTalents; }
    public void setFixedTalents(List<Talent> fixedTalents) { this.fixedTalents = fixedTalents; }

    public List<FactionGradeChoiceGroup> getChoiceGroups() { return choiceGroups; }
    public void setChoiceGroups(List<FactionGradeChoiceGroup> choiceGroups) { this.choiceGroups = choiceGroups; }
}