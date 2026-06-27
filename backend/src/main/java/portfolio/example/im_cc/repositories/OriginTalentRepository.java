package portfolio.example.im_cc.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import portfolio.example.im_cc.models.OriginTalent;

import java.util.List;

@Repository
public interface OriginTalentRepository extends JpaRepository<OriginTalent, Long> {
    List<OriginTalent> findByOriginId(Long originId);
}