package portfolio.example.im_cc.models;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;

@Entity
@Table(name = "psychic_power")
public class PsychicPower {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;

    @Column(name = "warp_rating")
    private Integer warpRating;

    private String difficulty;

    private String range;

    private String target;

    private String duration;

    @Column(columnDefinition = "text")
    private String effect;

    @JsonIgnore
    @ManyToOne
    @JoinColumn(name = "discipline_id")
    private PsychicDiscipline discipline;

    @Enumerated(EnumType.STRING)
    @Column(name = "source_book")
    private SourceBook sourceBook;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public Integer getWarpRating() { return warpRating; }
    public void setWarpRating(Integer warpRating) { this.warpRating = warpRating; }

    public String getDifficulty() { return difficulty; }
    public void setDifficulty(String difficulty) { this.difficulty = difficulty; }

    public String getRange() { return range; }
    public void setRange(String range) { this.range = range; }

    public String getTarget() { return target; }
    public void setTarget(String target) { this.target = target; }

    public String getDuration() { return duration; }
    public void setDuration(String duration) { this.duration = duration; }

    public String getEffect() { return effect; }
    public void setEffect(String effect) { this.effect = effect; }

    public PsychicDiscipline getDiscipline() { return discipline; }
    public void setDiscipline(PsychicDiscipline discipline) { this.discipline = discipline; }

    public SourceBook getSourceBook() { return sourceBook; }
    public void setSourceBook(SourceBook sourceBook) { this.sourceBook = sourceBook; }
}
