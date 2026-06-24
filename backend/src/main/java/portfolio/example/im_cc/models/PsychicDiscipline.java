package portfolio.example.im_cc.models;

import jakarta.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "psychic_discipline")
public class PsychicDiscipline {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;

    @Column(columnDefinition = "text")
    private String description;

    @OneToMany(mappedBy = "discipline", fetch = FetchType.EAGER)
    @OrderBy("id ASC")
    private List<PsychicPower> powers = new ArrayList<>();

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public List<PsychicPower> getPowers() { return powers; }
    public void setPowers(List<PsychicPower> powers) { this.powers = powers; }
}
