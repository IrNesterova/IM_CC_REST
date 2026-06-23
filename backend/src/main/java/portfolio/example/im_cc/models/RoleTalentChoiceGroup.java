package portfolio.example.im_cc.models;

import jakarta.persistence.*;

@Entity
public class RoleTalentChoiceGroup {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    private RoleChoiceGroup roleChoiceGroup;
    @ManyToOne
    private Talent talent;

    public Talent getTalent() {
        return talent;
    }

    public void setTalent(Talent talent) {
        this.talent = talent;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getId() {
        return id;
    }

    public RoleChoiceGroup getRoleChoiceGroup() {
        return roleChoiceGroup;
    }

    public void setRoleChoiceGroup(RoleChoiceGroup roleChoiceGroup) {
        this.roleChoiceGroup = roleChoiceGroup;
    }
}
