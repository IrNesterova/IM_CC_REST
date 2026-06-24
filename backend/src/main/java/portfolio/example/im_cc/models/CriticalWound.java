package portfolio.example.im_cc.models;

import jakarta.persistence.*;

@Entity
@Table(name = "critical_wound", uniqueConstraints = {
        @UniqueConstraint(columnNames = {"location", "roll_min"})
})
public class CriticalWound {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private BodyLocation location;

    @Column(name = "roll_min", nullable = false)
    private Integer rollMin;

    // 99 означает «и выше» (для записей типа 15+, 20+)
    @Column(name = "roll_max", nullable = false)
    private Integer rollMax;

    @Column(nullable = false)
    private String title;

    @Column(columnDefinition = "text", nullable = false)
    private String effect;

    @Column(columnDefinition = "text")
    private String injury;

    @Column(columnDefinition = "text")
    private String treatment;

    @Column(nullable = false)
    private boolean fatal = false;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public BodyLocation getLocation() { return location; }
    public void setLocation(BodyLocation location) { this.location = location; }

    public Integer getRollMin() { return rollMin; }
    public void setRollMin(Integer rollMin) { this.rollMin = rollMin; }

    public Integer getRollMax() { return rollMax; }
    public void setRollMax(Integer rollMax) { this.rollMax = rollMax; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getEffect() { return effect; }
    public void setEffect(String effect) { this.effect = effect; }

    public String getInjury() { return injury; }
    public void setInjury(String injury) { this.injury = injury; }

    public String getTreatment() { return treatment; }
    public void setTreatment(String treatment) { this.treatment = treatment; }

    public boolean isFatal() { return fatal; }
    public void setFatal(boolean fatal) { this.fatal = fatal; }
}