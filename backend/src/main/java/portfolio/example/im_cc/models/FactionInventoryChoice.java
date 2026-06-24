package portfolio.example.im_cc.models;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;

import java.util.ArrayList;
import java.util.List;

@Entity
public class FactionInventoryChoice {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @JsonIgnore
    @ManyToOne
    private FactionChoiceGroup factionChoiceGroup;

    @ManyToOne
    private Inventory inventory;

    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(
        name = "faction_inv_choice_modifier",
        joinColumns = @JoinColumn(name = "faction_inv_choice_id"),
        inverseJoinColumns = @JoinColumn(name = "modifier_id")
    )
    private List<ItemModifier> modifiers = new ArrayList<>();

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

    public List<ItemModifier> getModifiers() {
        return modifiers;
    }

    public void setModifiers(List<ItemModifier> modifiers) {
        this.modifiers = modifiers;
    }
}
