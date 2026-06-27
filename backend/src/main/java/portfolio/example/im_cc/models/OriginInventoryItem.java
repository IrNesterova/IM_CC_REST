package portfolio.example.im_cc.models;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "origin_inventory_item")
public class OriginInventoryItem {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "origin_id")
    @JsonIgnore
    private Origin origin;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "inventory_id")
    private Inventory inventory;

    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(
        name = "origin_inventory_modifier",
        joinColumns = @JoinColumn(name = "origin_inventory_id"),
        inverseJoinColumns = @JoinColumn(name = "modifier_id")
    )
    private List<ItemModifier> modifiers = new ArrayList<>();

    @Column(columnDefinition = "text")
    private String notes;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Origin getOrigin() { return origin; }
    public void setOrigin(Origin origin) { this.origin = origin; }

    public Inventory getInventory() { return inventory; }
    public void setInventory(Inventory inventory) { this.inventory = inventory; }

    public List<ItemModifier> getModifiers() { return modifiers; }
    public void setModifiers(List<ItemModifier> modifiers) { this.modifiers = modifiers; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }
}