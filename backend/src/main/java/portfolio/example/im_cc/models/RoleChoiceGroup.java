package portfolio.example.im_cc.models;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;

import java.util.List;

@Entity
public class RoleChoiceGroup {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @JsonIgnore
    @ManyToOne
    private Role role;
    private Integer choicesRequired;

    @Enumerated(EnumType.STRING)
    private ChoiceType choiceType;

    @Transient
    private List<Talent> talentOptions;
    @Transient
    private List<Inventory> inventoryOptions;
    @Transient
    private List<Skill> skillOptions;
    @Transient
    private List<Specialization> specializationOptions;
    @Transient
    private List<Skill> specsBySkill;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Integer getChoicesRequired() {
        return choicesRequired;
    }

    public void setChoicesRequired(Integer choicesRequired) {
        this.choicesRequired = choicesRequired;
    }

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }

    public ChoiceType getChoiceType() {
        return choiceType;
    }

    public void setChoiceType(ChoiceType choiceType) {
        this.choiceType = choiceType;
    }

    public List<Talent> getTalentOptions() {
        return talentOptions;
    }

    public void setTalentOptions(List<Talent> talentOptions) {
        this.talentOptions = talentOptions;
    }

    public List<Inventory> getInventoryOptions() {
        return inventoryOptions;
    }

    public void setInventoryOptions(List<Inventory> inventoryOptions) {
        this.inventoryOptions = inventoryOptions;
    }

    public List<Skill> getSkillOptions() {
        return skillOptions;
    }

    public void setSkillOptions(List<Skill> skillOptions) {
        this.skillOptions = skillOptions;
    }

    public List<Specialization> getSpecializationOptions() {
        return specializationOptions;
    }

    public void setSpecializationOptions(List<Specialization> specializationOptions) {
        this.specializationOptions = specializationOptions;
    }

    public List<Skill> getSpecsBySkill() {
        return specsBySkill;
    }

    public void setSpecsBySkill(List<Skill> specsBySkill) {
        this.specsBySkill = specsBySkill;
    }
}
