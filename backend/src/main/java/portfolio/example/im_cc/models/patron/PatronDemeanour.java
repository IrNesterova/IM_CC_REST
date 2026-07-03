package portfolio.example.im_cc.models.patron;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@Entity
@Table(name = "patron_demeanour")
public class PatronDemeanour {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    @Column(columnDefinition = "text")
    private String description;

    @Column(name = "roll_min", nullable = false)
    private Integer rollMin;

    @Column(name = "roll_max", nullable = false)
    private Integer rollMax;
}