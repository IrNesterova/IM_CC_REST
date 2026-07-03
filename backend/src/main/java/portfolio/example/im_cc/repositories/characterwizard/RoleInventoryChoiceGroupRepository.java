package portfolio.example.im_cc.repositories.characterwizard;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import portfolio.example.im_cc.models.characterwizard.RoleChoiceGroup;
import portfolio.example.im_cc.models.characterwizard.RoleInventoryChoiceGroup;

import java.util.List;

@Repository
public interface RoleInventoryChoiceGroupRepository extends JpaRepository<RoleInventoryChoiceGroup, Long> {
    List<RoleInventoryChoiceGroup> findByRoleChoiceGroup(RoleChoiceGroup roleChoiceGroup);
    List<RoleInventoryChoiceGroup> findByRoleChoiceGroupIn(List<RoleChoiceGroup> roleChoiceGroups);
}