package portfolio.example.im_cc.repositories.characterwizard;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import portfolio.example.im_cc.models.characterwizard.Role;
import portfolio.example.im_cc.models.characterwizard.RoleChoiceGroup;

import java.util.List;

@Repository
public interface RoleChoiceGroupRepository extends JpaRepository<RoleChoiceGroup, Long> {
    List<RoleChoiceGroup> findByRole(Role role);
    List<RoleChoiceGroup> findByRoleIn(List<Role> roles);
}
