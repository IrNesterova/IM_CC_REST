package portfolio.example.im_cc.models;

import jakarta.persistence.*;

import java.util.List;

@Entity
@Table(name = "origin")
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

    @Enumerated(EnumType.STRING)
    @Column(name = "source_book")
    private SourceBook sourceBook;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "category_id")
    private OriginCategory category;

    @Transient
    private List<Characteristics> primaryCharacteristsics;

    @Transient
    private List<Characteristics> secondaryCharacteristsics;

    @Transient
    private List<Talent> talentList;

    @Transient
    private List<OriginInventoryItem> startingItems;

    @Transient
    private List<OriginSkill> skillAdvances;

    @Transient
    private List<OriginSpecialization> specAdvances;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getExamples() { return examples; }
    public void setExamples(String examples) { this.examples = examples; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public List<Characteristics> getPrimaryCharacteristsics() { return primaryCharacteristsics; }
    public void setPrimaryCharacteristsics(List<Characteristics> primaryCharacteristsics) { this.primaryCharacteristsics = primaryCharacteristsics; }

    public List<Characteristics> getSecondaryCharacteristsics() { return secondaryCharacteristsics; }
    public void setSecondaryCharacteristsics(List<Characteristics> secondaryCharacteristsics) { this.secondaryCharacteristsics = secondaryCharacteristsics; }

    public List<Talent> getTalentList() { return talentList; }
    public void setTalentList(List<Talent> talentList) { this.talentList = talentList; }

    public List<OriginInventoryItem> getStartingItems() { return startingItems; }
    public void setStartingItems(List<OriginInventoryItem> startingItems) { this.startingItems = startingItems; }

    public SourceBook getSourceBook() { return sourceBook; }
    public void setSourceBook(SourceBook sourceBook) { this.sourceBook = sourceBook; }

    public OriginCategory getCategory() { return category; }
    public void setCategory(OriginCategory category) { this.category = category; }

    public List<OriginSkill> getSkillAdvances() { return skillAdvances; }
    public void setSkillAdvances(List<OriginSkill> skillAdvances) { this.skillAdvances = skillAdvances; }

    public List<OriginSpecialization> getSpecAdvances() { return specAdvances; }
    public void setSpecAdvances(List<OriginSpecialization> specAdvances) { this.specAdvances = specAdvances; }
}