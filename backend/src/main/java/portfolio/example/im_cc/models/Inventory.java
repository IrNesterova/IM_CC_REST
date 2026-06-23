package portfolio.example.im_cc.models;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;

@Entity
@Table
@Inheritance(strategy = InheritanceType.JOINED)
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
public abstract class Inventory {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(columnDefinition = "text")
    private String name;

    @Enumerated(EnumType.STRING)
    private InventoryCategory inventoryCategory;
    @Enumerated(EnumType.STRING)
    private InventorySubcategory inventorySubcategory;
    @Enumerated(EnumType.STRING)
    private Availability availability;
    private Integer encumbrance;
    private Integer cost;
    @Enumerated(EnumType.STRING)
    @Column(name = "source_book")
    private SourceBook sourceBook;
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }



    public InventorySubcategory getInventorySubcategory() {
        return inventorySubcategory;
    }

    public void setInventorySubcategory(InventorySubcategory inventorySubcategory) {
        this.inventorySubcategory = inventorySubcategory;
    }

    public InventoryCategory getInventoryCategory() {
        return inventoryCategory;
    }

    public void setInventoryCategory(InventoryCategory inventoryCategory) {
        this.inventoryCategory = inventoryCategory;
    }

    public Integer getEncumbrance() {
        return encumbrance;
    }

    public void setEncumbrance(Integer encumbrance) {
        this.encumbrance = encumbrance;
    }

    public Availability getAvailability() {
        return availability;
    }

    public void setAvailability(Availability availability) {
        this.availability = availability;
    }

    public Integer getCost() {
        return cost;
    }

    public void setCost(Integer cost) {
        this.cost = cost;
    }

    public SourceBook getSourceBook() {
        return sourceBook;
    }

    public void setSourceBook(SourceBook sourceBook) {
        this.sourceBook = sourceBook;
    }
}
