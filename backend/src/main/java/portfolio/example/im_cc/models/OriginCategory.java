package portfolio.example.im_cc.models;

import jakarta.persistence.*;

@Entity
@Table(name = "origin_category")
public class OriginCategory {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(columnDefinition = "text")
    private String name;

    @Column(columnDefinition = "text")
    private String description;

    @Enumerated(EnumType.STRING)
    @Column(name = "source_book")
    private SourceBook sourceBook;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public SourceBook getSourceBook() { return sourceBook; }
    public void setSourceBook(SourceBook sourceBook) { this.sourceBook = sourceBook; }
}