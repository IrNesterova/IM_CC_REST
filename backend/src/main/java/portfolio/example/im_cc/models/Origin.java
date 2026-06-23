package portfolio.example.im_cc.models;


import jakarta.persistence.*;
import org.hibernate.annotations.Type;

import java.util.List;

@Entity
@Table(name="origin")
public class Origin {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(columnDefinition = "text")
    private String name;
    @Column(columnDefinition = "text")
    private String examples;
    @Column(columnDefinition = "text")
    private String description;


    @Transient
    private List<Characteristics> primaryCharacteristsics;

    @Transient
    private List<Characteristics> secondaryCharacteristsics;

    @Transient
    private List<String> inventory;

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

    public String getExamples() {
        return examples;
    }

    public void setExamples(String examples) {
        this.examples = examples;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }


    public List<Characteristics> getPrimaryCharacteristsics() {
        return primaryCharacteristsics;
    }

    public void setPrimaryCharacteristsics(List<Characteristics> primaryCharacteristsics) {
        this.primaryCharacteristsics = primaryCharacteristsics;
    }

    public List<Characteristics> getSecondaryCharacteristsics() {
        return secondaryCharacteristsics;
    }

    public void setSecondaryCharacteristsics(List<Characteristics> secondaryCharacteristsics) {
        this.secondaryCharacteristsics = secondaryCharacteristsics;
    }
}
