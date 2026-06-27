package portfolio.example.im_cc.models;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;

@Entity
@Table(name = "faction_grade_char_choice")
public class FactionGradeCharChoice {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "grade_id")
    @JsonIgnore
    private FactionGrade grade;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "characteristics_id")
    private Characteristics characteristics;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public FactionGrade getGrade() { return grade; }
    public void setGrade(FactionGrade grade) { this.grade = grade; }

    public Characteristics getCharacteristics() { return characteristics; }
    public void setCharacteristics(Characteristics characteristics) { this.characteristics = characteristics; }
}