package portfolio.example.im_cc.repositories.lobby;

import org.springframework.data.jpa.repository.JpaRepository;
import portfolio.example.im_cc.models.lobby.GameRoom;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface GameRoomRepository extends JpaRepository<GameRoom, UUID> {
    Optional<GameRoom> findByJoinCode(String joinCode);

    // used when generating a fresh unique code
    boolean existsByJoinCode(String joinCode);

    // "my rooms" — rooms this user runs as GM
    List<GameRoom> findByGmId(Long gmId);
}
