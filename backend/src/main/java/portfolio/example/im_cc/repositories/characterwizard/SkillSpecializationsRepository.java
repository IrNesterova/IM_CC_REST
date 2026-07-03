package portfolio.example.im_cc.repositories.characterwizard;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import portfolio.example.im_cc.models.characterwizard.Specialization;
import portfolio.example.im_cc.models.characterwizard.SkillSpecializations;

import java.util.List;

@Repository
public interface SkillSpecializationsRepository extends JpaRepository<SkillSpecializations, Long> {
    List<SkillSpecializations> findBySpecializationIn(List<Specialization> specs);
}
