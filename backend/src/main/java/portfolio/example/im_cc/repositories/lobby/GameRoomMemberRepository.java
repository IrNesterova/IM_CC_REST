package portfolio.example.im_cc.repositories.lobby;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import portfolio.example.im_cc.models.lobby.GameRoomMember;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface GameRoomMemberRepository extends JpaRepository<GameRoomMember, UUID> {
    boolean existsByRoomIdAndUserId(UUID roomId, Long userId);

    // Members who left (or were kicked) keep their row for history but lose access to the room.
    boolean existsByRoomIdAndUserIdAndStatus(UUID roomId, Long userId, GameRoomMember.MemberStatus status);

    Optional<GameRoomMember> findByRoomIdAndUserId(UUID roomId, Long userId);

    long countByRoomId(UUID roomId);

    // Roster for one room. join-fetch user + character so rendering the member list
    // doesn't fire an N+1 storm (one query per member to load user/character lazily).
    @Query("""
        select m from GameRoomMember m
        join fetch m.user
        left join fetch m.character
        where m.room.id = :roomId
        """)
    List<GameRoomMember> findRosterByRoomId(UUID roomId);

    // Active memberships for a user, with room pre-fetched (for "my rooms" listing).
    @Query("select m from GameRoomMember m join fetch m.room where m.user.id = :userId and m.status = :status")
    List<GameRoomMember> findByUserIdAndStatusFetchRoom(@Param("userId") Long userId,
                                                        @Param("status") GameRoomMember.MemberStatus status);
}
