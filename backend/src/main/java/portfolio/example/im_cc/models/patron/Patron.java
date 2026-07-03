package portfolio.example.im_cc.models.patron;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import portfolio.example.im_cc.models.characterwizard.Faction;

import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "patron")
public class Patron {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(length = 200)
    private String name;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "faction_id")
    private Faction faction;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "duty_id")
    private PatronDuty duty;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "motivation_id")
    private PatronMotivation motivation;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "demeanour_id")
    private PatronDemeanour demeanour;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "payment_grade_id")
    private PatronPaymentGrade paymentGrade;

    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(
            name = "patron_selected_boons",
            joinColumns = @JoinColumn(name = "patron_id"),
            inverseJoinColumns = @JoinColumn(name = "boon_id")
    )
    private List<PatronBoon> boons = new ArrayList<>();

    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(
            name = "patron_selected_liabilities",
            joinColumns = @JoinColumn(name = "patron_id"),
            inverseJoinColumns = @JoinColumn(name = "liability_id")
    )
    private List<PatronLiability> liabilities = new ArrayList<>();
}