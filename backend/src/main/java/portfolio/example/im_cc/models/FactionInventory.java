package portfolio.example.im_cc.models;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;

import java.util.ArrayList;
import java.util.List;

@Table
@Entity
public class FactionInventory {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @JsonIgnore
    @ManyToOne
    private Faction faction;
    @ManyToOne
    private Inventory inventory;
    private String quantity;

    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(
        name = "faction_inventory_modifier",
        joinColumns = @JoinColumn(name = "faction_inventory_id"),
        inverseJoinColumns = @JoinColumn(name = "modifier_id")
    )
    private List<ItemModifier> modifiers = new ArrayList<>();

    @JsonIgnore
    public Faction getFaction() {
        return faction;
    }

    public void setFaction(Faction faction) {
        this.faction = faction;
    }

    public Inventory getInventory() {
        return inventory;
    }

    public void setInventory(Inventory inventory) {
        this.inventory = inventory;
    }

    public String getQuantity() {
        return quantity;
    }

    public void setQuantity(String quantity) {
        this.quantity = quantity;
    }

    public List<ItemModifier> getModifiers() {
        return modifiers;
    }

    public void setModifiers(List<ItemModifier> modifiers) {
        this.modifiers = modifiers;
    }
}
