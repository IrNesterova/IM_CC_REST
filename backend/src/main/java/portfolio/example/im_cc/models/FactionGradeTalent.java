package portfolio.example.im_cc.models;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;

@Entity
@Table(name = "faction_grade_talent")
public class FactionGradeTalent {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "grade_id")
    @JsonIgnore
    private FactionGrade grade;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "talent_id")
    private Talent talent;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public FactionGrade getGrade() { return grade; }
    public void setGrade(FactionGrade grade) { this.grade = grade; }

    public Talent getTalent() { return talent; }
    public void setTalent(Talent talent) { this.talent = talent; }
}