package portfolio.example.im_cc.repositories.patron;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import portfolio.example.im_cc.models.patron.PatronSave;

import java.util.Optional;

@Repository
public interface PatronSaveRepository extends JpaRepository<PatronSave, Long> {
    Optional<PatronSave> findBySaveCode(String saveCode);
}