package portfolio.example.im_cc.models;

import jakarta.persistence.*;

@Entity
@Table(name = "game_condition")
public class GameCondition {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false)
    private String name;

    @Column(columnDefinition = "text")
    private String description;

    @Column(name = "minor_effect", columnDefinition = "text")
    private String minorEffect;

    @Column(name = "major_effect", columnDefinition = "text")
    private String majorEffect;

    @Column(columnDefinition = "text")
    private String removal;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getMinorEffect() { return minorEffect; }
    public void setMinorEffect(String minorEffect) { this.minorEffect = minorEffect; }

    public String getMajorEffect() { return majorEffect; }
    public void setMajorEffect(String majorEffect) { this.majorEffect = majorEffect; }

    public String getRemoval() { return removal; }
    public void setRemoval(String removal) { this.removal = removal; }
}