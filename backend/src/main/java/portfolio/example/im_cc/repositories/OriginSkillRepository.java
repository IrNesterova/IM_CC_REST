package portfolio.example.im_cc.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import portfolio.example.im_cc.models.OriginSkill;

import java.util.List;

public interface OriginSkillRepository extends JpaRepository<OriginSkill, Long> {
    List<OriginSkill> findByOriginId(Long originId);
}
