package portfolio.example.im_cc.models.lobby;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;
import portfolio.example.im_cc.models.AppUser;
import portfolio.example.im_cc.models.enums.SourceBook;

import java.time.Instant;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;
import java.util.UUID;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "game_room")
public class GameRoom {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(nullable = false, length = 120)
    private String name;

    @Column(name = "join_code", nullable = false, unique = true, length = 8)
    private String joinCode;
    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 16)
    private RoomStatus status = RoomStatus.LOBBY;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "gm_user_id", nullable = false)
    private AppUser gm;

    // Read the FK column directly so callers outside a transaction can get the GM's ID
    // without triggering a LazyInitializationException on the gm association.
    @Column(name = "gm_user_id", insertable = false, updatable = false)
    private Long gmId;

    @Column(name = "webhook_url", length = 512)
    private String webhookUrl;

    @Column(name = "patron_save_code", length = 8)
    private String patronSaveCode;

    @ElementCollection(fetch = FetchType.EAGER)
    @Enumerated(EnumType.STRING)
    @CollectionTable(name = "game_room_source_books", joinColumns = @JoinColumn(name = "room_id"))
    @Column(name = "source_book")
    private Set<SourceBook> allowedSourceBooks = new HashSet<>(Arrays.asList(SourceBook.values()));

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private Instant createdAt;
    public enum RoomStatus {
        LOBBY,   // assembling, players can join
        ACTIVE,  // GM started the session
        CLOSED   // finished; kept for history, not deleted
    }

    public GameRoom(String name, String joinCode, AppUser gm) {
        this.name = name;
        this.joinCode = joinCode;
        this.gm = gm;
    }
}
