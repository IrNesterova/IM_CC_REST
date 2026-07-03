package portfolio.example.im_cc.repositories.characterwizard;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import portfolio.example.im_cc.models.characterwizard.RoleChoiceGroup;
import portfolio.example.im_cc.models.characterwizard.RoleTalentChoiceGroup;

import java.util.List;

@Repository
public interface RoleTalentChoiceGroupRepository extends JpaRepository<RoleTalentChoiceGroup, Long> {
    List<RoleTalentChoiceGroup> findByRoleChoiceGroup(RoleChoiceGroup roleChoiceGroup);
    List<RoleTalentChoiceGroup> findByRoleChoiceGroupIn(List<RoleChoiceGroup> roleChoiceGroups);
}