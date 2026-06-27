package portfolio.example.im_cc.models;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;

import java.util.List;

@Entity
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
public class Role {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(columnDefinition = "text")
    private String name;

    @Transient
    private List<Inventory> inventoryList;

    @Transient
    private List<RoleChoiceGroup> choiceGroups;

    @Enumerated(EnumType.STRING)
    @Column(name = "source_book")
    private SourceBook sourceBook;

    public List<Inventory> getInventoryList() {
        return inventoryList;
    }

    public void setInventoryList(List<Inventory> inventoryList) {
        this.inventoryList = inventoryList;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public List<RoleChoiceGroup> getChoiceGroups() {
        return choiceGroups;
    }

    public void setChoiceGroups(List<RoleChoiceGroup> choiceGroups) {
        this.choiceGroups = choiceGroups;
    }

    public SourceBook getSourceBook() {
        return sourceBook;
    }

    public void setSourceBook(SourceBook sourceBook) {
        this.sourceBook = sourceBook;
    }
}
