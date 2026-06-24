package portfolio.example.im_cc.models;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "character_save")
public class CharacterSave {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, length = 8)
    private String saveCode;

    @Column(columnDefinition = "text")
    private String data;

    @Column
    private LocalDateTime createdAt;

    @Column
    private LocalDateTime updatedAt;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn
    private AppUser owner;

    @Column
    private String characterName;

    @Column(columnDefinition = "bytea")
    private byte[] imageData;

    @Column
    private String imageContentType;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getSaveCode() { return saveCode; }
    public void setSaveCode(String saveCode) { this.saveCode = saveCode; }

    public String getData() { return data; }
    public void setData(String data) { this.data = data; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    public AppUser getOwner() {
        return owner;
    }

    public void setOwner(AppUser owner) {
        this.owner = owner;
    }

    public String getCharacterName() {
        return characterName;
    }

    public void setCharacterName(String characterName) {
        this.characterName = characterName;
    }

    public byte[] getImageData() { return imageData; }
    public void setImageData(byte[] imageData) { this.imageData = imageData; }

    public String getImageContentType() { return imageContentType; }
    public void setImageContentType(String imageContentType) { this.imageContentType = imageContentType; }
}