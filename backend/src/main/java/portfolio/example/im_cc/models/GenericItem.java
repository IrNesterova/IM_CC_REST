package portfolio.example.im_cc.models;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;

@Entity
@Table
public class GenericItem extends Inventory{
    @Column(columnDefinition = "text")
    private String description;

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
}
