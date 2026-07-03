package portfolio.example.im_cc.models.patron;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.List;

@Getter
@NoArgsConstructor
@Entity
@Table(name = "patron_duty")
public class PatronDuty {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    @Column(columnDefinition = "text")
    private String description;

    @Column(name = "duty_boon_name")
    private String dutyBoonName;

    @Column(name = "duty_boon_description", columnDefinition = "text")
    private String dutyBoonDescription;

    @Column(name = "faction_id")
    private Long factionId;

    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(
            name = "patron_boon_duties",
            joinColumns = @JoinColumn(name = "duty_id"),
            inverseJoinColumns = @JoinColumn(name = "boon_id")
    )
    private List<PatronBoon> boons;

    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(
            name = "patron_liability_duties",
            joinColumns = @JoinColumn(name = "duty_id"),
            inverseJoinColumns = @JoinColumn(name = "liability_id")
    )
    private List<PatronLiability> liabilities;
}