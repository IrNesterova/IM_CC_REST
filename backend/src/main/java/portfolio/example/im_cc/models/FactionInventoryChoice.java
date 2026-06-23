package portfolio.example.im_cc.models;

import jakarta.persistence.*;

@Entity
public class FactionInventoryChoice {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    private FactionChoiceGroup factionChoiceGroup;

    @ManyToOne
    private Inventory inventory;

    public FactionChoiceGroup getFactionChoiceGroup() {
        return factionChoiceGroup;
    }

    public void setFactionChoiceGroup(FactionChoiceGroup factionChoiceGroup) {
        this.factionChoiceGroup = factionChoiceGroup;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Inventory getInventory() {
        return inventory;
    }

    public void setInventory(Inventory inventory) {
        this.inventory = inventory;
    }
}
