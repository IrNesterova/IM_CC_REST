package portfolio.example.im_cc.models;

import jakarta.persistence.*;

@Entity
@Table(name = "talent_advancement")
public class TalentAdvancement {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "talent_id")
    private Talent talent;

    @Column(name = "advance_number")
    private Integer advanceNumber;

    private String name;

    @Column(columnDefinition = "text")
    private String effect;

    @Column
    private boolean choice = false;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Talent getTalent() { return talent; }
    public void setTalent(Talent talent) { this.talent = talent; }

    public Integer getAdvanceNumber() { return advanceNumber; }
    public void setAdvanceNumber(Integer advanceNumber) { this.advanceNumber = advanceNumber; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getEffect() { return effect; }
    public void setEffect(String effect) { this.effect = effect; }

    public boolean isChoice() { return choice; }
    public void setChoice(boolean choice) { this.choice = choice; }
}