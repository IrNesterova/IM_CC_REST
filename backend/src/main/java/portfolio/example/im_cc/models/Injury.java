package portfolio.example.im_cc.models;

import jakarta.persistence.*;

@Entity
@Table(name = "injury")
public class Injury {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false)
    private String name;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private InjuryType injuryType;

    // null для обобщённых записей ("Broken Bone (Minor)" без конкретной части)
    private String affectedPart;

    @Column(columnDefinition = "text", nullable = false)
    private String effect;

    @Column(columnDefinition = "text")
    private String treatment;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public InjuryType getInjuryType() { return injuryType; }
    public void setInjuryType(InjuryType injuryType) { this.injuryType = injuryType; }

    public String getAffectedPart() { return affectedPart; }
    public void setAffectedPart(String affectedPart) { this.affectedPart = affectedPart; }

    public String getEffect() { return effect; }
    public void setEffect(String effect) { this.effect = effect; }

    public String getTreatment() { return treatment; }
    public void setTreatment(String treatment) { this.treatment = treatment; }
}