package portfolio.example.im_cc.models.characterwizard;

import jakarta.persistence.*;

@Entity
@Table(name = "talent_requirement")
public class TalentRequirement {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "talent_id", nullable = false)
    private Talent talent;

    // CHAR_GTE, CHAR_LTE, SKILL_GTE, SPEC_GTE, SKILL_ZERO, TALENT_HAVE, TALENT_LACK, CREATION_ONLY
    @Column(name = "req_type", nullable = false, length = 20)
    private String reqType;

    // characteristic name, skill name, spec name, or talent name
    @Column(length = 100)
    private String target;

    // threshold for CHAR_GTE/LTE, advance count for SKILL_GTE/SPEC_GTE; null otherwise
    @Column
    private Integer value;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Talent getTalent() { return talent; }
    public void setTalent(Talent talent) { this.talent = talent; }

    public String getReqType() { return reqType; }
    public void setReqType(String reqType) { this.reqType = reqType; }

    public String getTarget() { return target; }
    public void setTarget(String target) { this.target = target; }

    public Integer getValue() { return value; }
    public void setValue(Integer value) { this.value = value; }
}