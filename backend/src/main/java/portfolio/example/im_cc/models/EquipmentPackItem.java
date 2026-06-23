package portfolio.example.im_cc.models;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;

@Table
@Entity
public class EquipmentPackItem {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @JsonIgnore
    @ManyToOne
    private EquipmentPack equipmentPack;

    @ManyToOne
    @JoinColumn(nullable = true)
    private Inventory inventory;

    private Integer quantity;

    @Column(columnDefinition = "text")
    private String note;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public EquipmentPack getEquipmentPack() { return equipmentPack; }
    public void setEquipmentPack(EquipmentPack equipmentPack) { this.equipmentPack = equipmentPack; }
    public Inventory getInventory() { return inventory; }
    public void setInventory(Inventory inventory) { this.inventory = inventory; }
    public Integer getQuantity() { return quantity; }
    public void setQuantity(Integer quantity) { this.quantity = quantity; }
    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }
}
