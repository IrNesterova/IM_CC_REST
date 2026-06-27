package portfolio.example.im_cc.models;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;

import java.util.List;

@Entity
@Table(name = "faction_grade_choice_group")
public class FactionGradeChoiceGroup {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "grade_id")
    @JsonIgnore
    private FactionGrade grade;

    @Column(name = "choices_required")
    private int choicesRequired;

    @Enumerated(EnumType.STRING)
    @Column(name = "choice_type")
    private ChoiceType choiceType;

    @Transient
    private List<FactionGradeInventoryChoice> inventoryOptions;

    @Transient
    private List<Talent> talentOptions;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public FactionGrade getGrade() { return grade; }
    public void setGrade(FactionGrade grade) { this.grade = grade; }

    public int getChoicesRequired() { return choicesRequired; }
    public void setChoicesRequired(int choicesRequired) { this.choicesRequired = choicesRequired; }

    public ChoiceType getChoiceType() { return choiceType; }
    public void setChoiceType(ChoiceType choiceType) { this.choiceType = choiceType; }

    public List<FactionGradeInventoryChoice> getInventoryOptions() { return inventoryOptions; }
    public void setInventoryOptions(List<FactionGradeInventoryChoice> inventoryOptions) { this.inventoryOptions = inventoryOptions; }

    public List<Talent> getTalentOptions() { return talentOptions; }
    public void setTalentOptions(List<Talent> talentOptions) { this.talentOptions = talentOptions; }
}