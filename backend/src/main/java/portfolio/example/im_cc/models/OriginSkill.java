package portfolio.example.im_cc.models;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;

@Entity
@Table(name = "origin_skill")
public class OriginSkill {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "origin_id")
    @JsonIgnore
    private Origin origin;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "skill_id")
    private Skill skill;

    private int advances = 1;

    @Column(name = "is_choice")
    private boolean isChoice;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Origin getOrigin() { return origin; }
    public void setOrigin(Origin origin) { this.origin = origin; }

    public Skill getSkill() { return skill; }
    public void setSkill(Skill skill) { this.skill = skill; }

    public int getAdvances() { return advances; }
    public void setAdvances(int advances) { this.advances = advances; }

    public boolean isChoice() { return isChoice; }
    public void setChoice(boolean choice) { isChoice = choice; }
}