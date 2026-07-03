package portfolio.example.im_cc.repositories.characterwizard;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import portfolio.example.im_cc.models.characterwizard.Role;
import portfolio.example.im_cc.models.characterwizard.RoleInventory;

import java.util.List;

@Repository
public interface RoleInventoryRepository extends JpaRepository<RoleInventory, Long> {
    List<RoleInventory> findByRole(Role role);
    List<RoleInventory> findByRoleIn(List<Role> roles);
}