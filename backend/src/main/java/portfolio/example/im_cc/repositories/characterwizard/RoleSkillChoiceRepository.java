package portfolio.example.im_cc.repositories.characterwizard;

import org.springframework.data.jpa.repository.JpaRepository;
import portfolio.example.im_cc.models.characterwizard.RoleSkillChoiceGroup;

public interface RoleSkillChoiceRepository extends JpaRepository<RoleSkillChoiceGroup, Long> {

}
