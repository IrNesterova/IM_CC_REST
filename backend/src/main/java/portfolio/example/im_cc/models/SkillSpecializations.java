package portfolio.example.im_cc.models;

import jakarta.persistence.*;

@Entity
public class SkillSpecializations {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn
    private Skill skill;
    @ManyToOne
    @JoinColumn
    private Specialization specialization;

    public Skill getSkill() { return skill; }
    public Specialization getSpecialization() { return specialization; }
}
