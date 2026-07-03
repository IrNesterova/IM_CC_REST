package portfolio.example.im_cc.repositories.characterwizard;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import portfolio.example.im_cc.models.characterwizard.RoleChoiceGroup;
import portfolio.example.im_cc.models.characterwizard.RoleSpecializationChoiceGroup;

import java.util.List;

@Repository
public interface RoleSpecializationChoiceGroupRepository extends JpaRepository<RoleSpecializationChoiceGroup, Long> {
    List<RoleSpecializationChoiceGroup> findByRoleChoiceGroup(RoleChoiceGroup roleChoiceGroup);
    List<RoleSpecializationChoiceGroup> findByRoleChoiceGroupIn(List<RoleChoiceGroup> roleChoiceGroups);
}