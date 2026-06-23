package portfolio.example.im_cc.models;

import jakarta.persistence.*;

@Entity
@Table(name = "mutation")
public class Mutation {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(columnDefinition = "text")
    private String name;

    @Column(columnDefinition = "text")
    private String description;

    @Column(columnDefinition = "text")
    private String mutationType; // "mutation" or "malignancy"

    @Column(columnDefinition = "text")
    private String d100Range; // e.g. "01–05"

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getMutationType() { return mutationType; }
    public void setMutationType(String mutationType) { this.mutationType = mutationType; }

    public String getD100Range() { return d100Range; }
    public void setD100Range(String d100Range) { this.d100Range = d100Range; }
}