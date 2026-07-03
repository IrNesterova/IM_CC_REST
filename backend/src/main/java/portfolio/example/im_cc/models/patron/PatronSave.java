package portfolio.example.im_cc.models.patron;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "patron_save")
public class PatronSave {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, length = 8)
    private String saveCode;

    @Column(columnDefinition = "text")
    private String data;

    @Column
    private String patronName;

    @Column
    private LocalDateTime createdAt;

    @Column
    private LocalDateTime updatedAt;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getSaveCode() { return saveCode; }
    public void setSaveCode(String saveCode) { this.saveCode = saveCode; }

    public String getData() { return data; }
    public void setData(String data) { this.data = data; }

    public String getPatronName() { return patronName; }
    public void setPatronName(String patronName) { this.patronName = patronName; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}