package portfolio.example.im_cc.models;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;

@Entity
@Table(name = "faction_grade_inventory_choice")
public class FactionGradeInventoryChoice {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "choice_group_id")
    @JsonIgnore
    private FactionGradeChoiceGroup choiceGroup;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "inventory_id")
    private Inventory inventory;

    @Column
    private Integer quantity;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public FactionGradeChoiceGroup getChoiceGroup() { return choiceGroup; }
    public void setChoiceGroup(FactionGradeChoiceGroup choiceGroup) { this.choiceGroup = choiceGroup; }

    public Inventory getInventory() { return inventory; }
    public void setInventory(Inventory inventory) { this.inventory = inventory; }

    public Integer getQuantity() { return quantity; }
    public void setQuantity(Integer quantity) { this.quantity = quantity; }
}