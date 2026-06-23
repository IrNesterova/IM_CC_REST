package portfolio.example.im_cc.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import portfolio.example.im_cc.models.RoleSkillChoiceGroup;

public interface RoleSkillChoiceRepository extends JpaRepository<RoleSkillChoiceGroup, Long> {

}
