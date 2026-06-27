package portfolio.example.im_cc.models;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;

@Entity
@Table(name = "origin_talent")
public class OriginTalent {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "origin_id")
    @JsonIgnore
    private Origin origin;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "talent_id")
    private Talent talent;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Origin getOrigin() { return origin; }
    public void setOrigin(Origin origin) { this.origin = origin; }

    public Talent getTalent() { return talent; }
    public void setTalent(Talent talent) { this.talent = talent; }
}