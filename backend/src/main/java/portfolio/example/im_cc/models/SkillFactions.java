package portfolio.example.im_cc.models;

import jakarta.persistence.*;

@Table
@Entity
public class SkillFactions {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;


    public void setId(Long id) {
        this.id = id;
    }

    public Long getId() {
        return id;

    }
    @ManyToOne
    @JoinColumn
    private Faction faction;
    @ManyToOne
    @JoinColumn
    private Skill skill;

    public Skill getSkill() {
        return skill;
    }

    public void setSkill(Skill skill) {
        this.skill = skill;
    }

    public Faction getFaction() {
        return faction;
    }

    public void setFaction(Faction faction) {
        this.faction = faction;
    }
}
