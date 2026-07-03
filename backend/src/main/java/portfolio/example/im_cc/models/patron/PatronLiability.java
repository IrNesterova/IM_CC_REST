package portfolio.example.im_cc.models.patron;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import portfolio.example.im_cc.models.enums.SourceBook;

@Getter
@NoArgsConstructor
@Entity
@Table(name = "patron_liability")
public class PatronLiability {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    @Column(columnDefinition = "text")
    private String description;

    @Enumerated(EnumType.STRING)
    @Column(name = "source_book", length = 10)
    private SourceBook sourceBook = SourceBook.IM;
}