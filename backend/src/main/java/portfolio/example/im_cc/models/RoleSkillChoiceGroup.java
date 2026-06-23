package portfolio.example.im_cc.models;

import jakarta.persistence.*;

@Entity
public class RoleSkillChoiceGroup {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    private RoleChoiceGroup roleChoiceGroup;

    @ManyToOne
    private Skill skill;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public RoleChoiceGroup getRoleChoiceGroup() {
        return roleChoiceGroup;
    }

    public void setRoleChoiceGroup(RoleChoiceGroup roleChoiceGroup) {
        this.roleChoiceGroup = roleChoiceGroup;
    }

    public Skill getSkill() {
        return skill;
    }

    public void setSkill(Skill skill) {
        this.skill = skill;
    }
}
