package portfolio.example.im_cc.models;

import jakarta.persistence.*;

@Table(name="character_origin")
@Entity
public class CharacteristicsOrigin {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name="origin_id")
    private Origin origin;

    @ManyToOne
    @JoinColumn(name = "character_id")
    private Characteristics characteristics;
    @Column(name = "primary_char")
    private boolean primaryChar;

    public Characteristics getCharacteristics() {
        return characteristics;
    }

    public void setCharacteristics(Characteristics characteristics) {
        this.characteristics = characteristics;
    }

    public Origin getOrigin() {
        return origin;
    }

    public void setOrigin(Origin origin) {
        this.origin = origin;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public boolean isPrimaryChar() {
        return primaryChar;
    }

    public void setPrimaryChar(boolean primaryChar) {
        this.primaryChar = primaryChar;
    }
}
