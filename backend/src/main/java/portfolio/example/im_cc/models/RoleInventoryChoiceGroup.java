package portfolio.example.im_cc.models;

import jakarta.persistence.*;

@Entity
public class RoleInventoryChoiceGroup {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    private RoleChoiceGroup roleChoiceGroup;
    @ManyToOne
    private Inventory inventory;

    public RoleChoiceGroup getRoleChoiceGroup() {
        return roleChoiceGroup;
    }

    public void setRoleChoiceGroup(RoleChoiceGroup roleChoiceGroup) {
        this.roleChoiceGroup = roleChoiceGroup;
    }

    public Inventory getInventory() {
        return inventory;
    }

    public void setInventory(Inventory inventory) {
        this.inventory = inventory;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }
}
