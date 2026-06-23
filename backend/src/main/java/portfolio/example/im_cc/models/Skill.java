package portfolio.example.im_cc.models;

import jakarta.persistence.*;

import java.util.List;

@Entity
public class Skill {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(columnDefinition = "text")
    private String name;
    @Column(columnDefinition = "text")
    private String description;

    @ManyToOne
    @JoinColumn
    private Characteristics characteristics;

    @Transient
    private List<Specialization> specializationList;

    public List<Specialization> getSpecializationList() { return specializationList; }
    public void setSpecializationList(List<Specialization> specializationList) { this.specializationList = specializationList; }

    public Characteristics getCharacteristics() { return characteristics; }
    public void setCharacteristics(Characteristics characteristics) { this.characteristics = characteristics; }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }
}
