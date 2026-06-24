package portfolio.example.im_cc.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import portfolio.example.im_cc.models.AppUser;

import java.util.Optional;

public interface AppUserRepository extends JpaRepository<AppUser, Long> {
    Optional<AppUser> findByEmail(String email);
    boolean existsByEmail(String email);
    Optional<AppUser> findByDiscordId(String discordId);
}
