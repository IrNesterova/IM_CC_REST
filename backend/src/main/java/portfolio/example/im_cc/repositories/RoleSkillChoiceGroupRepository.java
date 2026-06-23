package portfolio.example.im_cc.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import portfolio.example.im_cc.models.RoleChoiceGroup;
import portfolio.example.im_cc.models.RoleSkillChoiceGroup;

import java.util.List;

@Repository
public interface RoleSkillChoiceGroupRepository extends JpaRepository<RoleSkillChoiceGroup, Long> {
    List<RoleSkillChoiceGroup> findByRoleChoiceGroup(RoleChoiceGroup roleChoiceGroup);
    List<RoleSkillChoiceGroup> findByRoleChoiceGroupIn(List<RoleChoiceGroup> roleChoiceGroup);

}