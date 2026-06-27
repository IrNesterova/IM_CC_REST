package portfolio.example.im_cc.models;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;

@Entity
@Table(name = "faction_grade_talent_choice")
public class FactionGradeTalentChoice {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "choice_group_id")
    @JsonIgnore
    private FactionGradeChoiceGroup choiceGroup;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "talent_id")
    private Talent talent;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public FactionGradeChoiceGroup getChoiceGroup() { return choiceGroup; }
    public void setChoiceGroup(FactionGradeChoiceGroup choiceGroup) { this.choiceGroup = choiceGroup; }

    public Talent getTalent() { return talent; }
    public void setTalent(Talent talent) { this.talent = talent; }
}