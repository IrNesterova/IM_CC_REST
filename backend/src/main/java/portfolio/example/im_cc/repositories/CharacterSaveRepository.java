package portfolio.example.im_cc.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import portfolio.example.im_cc.models.CharacterSave;

import java.util.Optional;

@Repository
public interface CharacterSaveRepository extends JpaRepository<CharacterSave, Long> {
    Optional<CharacterSave> findBySaveCode(String saveCode);
}