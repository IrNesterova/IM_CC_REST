package portfolio.example.im_cc.models;

import jakarta.persistence.*;

@Table
@Entity
public class CharacteristicsFaction {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn
    private Faction faction;

    @ManyToOne
    @JoinColumn
    private Characteristics characteristics;

    private boolean primaryChar;

    public Characteristics getCharacteristics() {
        return characteristics;
    }

    public void setCharacteristics(Characteristics characteristics) {
        this.characteristics = characteristics;
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

    public Faction getFaction() {
        return faction;
    }

    public void setFaction(Faction faction) {
        this.faction = faction;
    }
}
