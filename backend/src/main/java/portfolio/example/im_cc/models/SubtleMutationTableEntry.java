package portfolio.example.im_cc.models;

import jakarta.persistence.*;

@Entity
@Table(name = "subtle_mutation_table")
public class SubtleMutationTableEntry {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "d100_min")
    private int d100Min;

    @Column(name = "d100_max")
    private int d100Max;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "positive_mutation_id")
    private Mutation positiveMutation;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "negative_mutation_id")
    private Mutation negativeMutation;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public int getD100Min() { return d100Min; }
    public void setD100Min(int d100Min) { this.d100Min = d100Min; }

    public int getD100Max() { return d100Max; }
    public void setD100Max(int d100Max) { this.d100Max = d100Max; }

    public Mutation getPositiveMutation() { return positiveMutation; }
    public void setPositiveMutation(Mutation positiveMutation) { this.positiveMutation = positiveMutation; }

    public Mutation getNegativeMutation() { return negativeMutation; }
    public void setNegativeMutation(Mutation negativeMutation) { this.negativeMutation = negativeMutation; }
}