package portfolio.example.im_cc.models;

import jakarta.persistence.*;
import org.hibernate.annotations.ColumnDefault;

@Table
@Entity
public class FactionInventory {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    private Faction faction;
    @ManyToOne
    private Inventory inventory;
    @ColumnDefault("1")
    private Integer quantity;

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
}
