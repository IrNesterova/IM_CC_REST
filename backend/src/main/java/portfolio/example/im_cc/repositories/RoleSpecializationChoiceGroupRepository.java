package portfolio.example.im_cc.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import portfolio.example.im_cc.models.RoleChoiceGroup;
import portfolio.example.im_cc.models.RoleSpecializationChoiceGroup;

import java.util.List;

@Repository
public interface RoleSpecializationChoiceGroupRepository extends JpaRepository<RoleSpecializationChoiceGroup, Long> {
    List<RoleSpecializationChoiceGroup> findByRoleChoiceGroup(RoleChoiceGroup roleChoiceGroup);
    List<RoleSpecializationChoiceGroup> findByRoleChoiceGroupIn(List<RoleChoiceGroup> roleChoiceGroups);
}