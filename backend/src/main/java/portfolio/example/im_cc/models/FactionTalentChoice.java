package portfolio.example.im_cc.models;

import jakarta.persistence.*;

@Entity
public class FactionTalentChoice {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @ManyToOne
    private FactionChoiceGroup factionChoiceGroup;
    @ManyToOne
    private Talent talent;

    private Long option_id;
    public FactionChoiceGroup getFactionChoiceGroup() {
        return factionChoiceGroup;
    }

    public void setFactionChoiceGroup(FactionChoiceGroup factionChoiceGroup) {
        this.factionChoiceGroup = factionChoiceGroup;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Talent getTalent() {
        return talent;
    }

    public void setTalent(Talent talent) {
        this.talent = talent;
    }

    public Long getOption_id() {
        return option_id;
    }

    public void setOption_id(Long option_id) {
        this.option_id = option_id;
    }
}
