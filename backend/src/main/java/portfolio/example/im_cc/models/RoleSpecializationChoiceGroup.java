package portfolio.example.im_cc.models;

import jakarta.persistence.*;

@Entity
public class RoleSpecializationChoiceGroup {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @ManyToOne
    private RoleChoiceGroup roleChoiceGroup;

    @ManyToOne
    private Specialization specialization;

    public Specialization getSpecialization() {
        return specialization;
    }

    public void setSpecialization(Specialization specialization) {
        this.specialization = specialization;
    }

    public RoleChoiceGroup getRoleChoiceGroup() {
        return roleChoiceGroup;
    }

    public void setRoleChoiceGroup(RoleChoiceGroup roleChoiceGroup) {
        this.roleChoiceGroup = roleChoiceGroup;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }
}
