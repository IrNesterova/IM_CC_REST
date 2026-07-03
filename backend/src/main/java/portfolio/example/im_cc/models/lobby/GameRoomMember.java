package portfolio.example.im_cc.models.lobby;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;
import portfolio.example.im_cc.models.AppUser;
import portfolio.example.im_cc.models.characterwizard.CharacterSave;

import java.time.Instant;
import java.util.UUID;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "game_room_member",
        // The key invariant: one user can be in a given room at most once.
        // This is what stops a double-click on "join" from creating a duplicate member.
        uniqueConstraints = @UniqueConstraint(name = "uq_room_user", columnNames = {"room_id", "user_id"}))
public class GameRoomMember {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "room_id")
    private GameRoom room;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private AppUser user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "character_id")
    private CharacterSave character;
    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 16)
    private MemberRole role = MemberRole.PLAYER;

    // Membership state in the campaign — NOT online presence.
    // Presence (the live green dot) is ephemeral and stays in memory, never in the DB.
    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 16)
    private MemberStatus status = MemberStatus.ACTIVE;

    @CreationTimestamp
    @Column(name = "joined_at", nullable = false, updatable = false)
    private Instant joinedAt;

    public enum MemberRole { GM, PLAYER }

    public enum MemberStatus { ACTIVE, LEFT, KICKED }

    public GameRoomMember(GameRoom room, AppUser user, MemberRole role) {
        this.room = room;
        this.user = user;
        this.role = role;
    }
}
