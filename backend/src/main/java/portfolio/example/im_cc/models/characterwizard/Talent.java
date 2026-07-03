package portfolio.example.im_cc.models.characterwizard;

import jakarta.persistence.*;
import portfolio.example.im_cc.models.enums.SourceBook;
import java.util.List;

@Entity
@Table
public class Talent {

    @Enumerated(EnumType.STRING)
    @Column(name = "source_book")
    private SourceBook sourceBook;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    public void setId(Long id) {
        this.id = id;
    }

    public Long getId() {
        return id;
    }

    @Column(columnDefinition = "text")
    private String name;
    @Column(columnDefinition = "text")
    private String description;

    @Column(name = "max_advances")
    private Integer maxAdvances = 1;

    @OneToMany(mappedBy = "talent", fetch = FetchType.EAGER, cascade = CascadeType.ALL, orphanRemoval = true)
    private List<TalentRequirement> requirements = new java.util.ArrayList<>();

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

    public Integer getMaxAdvances() { return maxAdvances; }
    public void setMaxAdvances(Integer maxAdvances) { this.maxAdvances = maxAdvances; }

    public SourceBook getSourceBook() { return sourceBook; }
    public void setSourceBook(SourceBook sourceBook) { this.sourceBook = sourceBook; }

    public List<TalentRequirement> getRequirements() { return requirements; }
    public void setRequirements(List<TalentRequirement> requirements) { this.requirements = requirements; }
}
