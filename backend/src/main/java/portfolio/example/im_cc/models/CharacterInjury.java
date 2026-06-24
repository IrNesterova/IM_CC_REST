package portfolio.example.im_cc.models;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "character_injury")
public class CharacterInjury {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "character_save_id", nullable = false)
    private CharacterSave characterSave;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "injury_id", nullable = false)
    private Injury injury;

    // дополнительное описание конкретного случая, например "потерял 3 пальца"
    @Column(columnDefinition = "text")
    private String notes;

    @Column(nullable = false)
    private LocalDateTime acquiredAt = LocalDateTime.now();

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public CharacterSave getCharacterSave() { return characterSave; }
    public void setCharacterSave(CharacterSave characterSave) { this.characterSave = characterSave; }

    public Injury getInjury() { return injury; }
    public void setInjury(Injury injury) { this.injury = injury; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public LocalDateTime getAcquiredAt() { return acquiredAt; }
    public void setAcquiredAt(LocalDateTime acquiredAt) { this.acquiredAt = acquiredAt; }
}