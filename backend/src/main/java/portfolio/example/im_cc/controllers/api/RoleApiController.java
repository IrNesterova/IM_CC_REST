package portfolio.example.im_cc.controllers.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import portfolio.example.im_cc.models.characterwizard.Role;
import portfolio.example.im_cc.services.RoleServiceImpl;

import java.util.List;

@Transactional(readOnly = true)
@RestController
@RequestMapping("/api/roles")
public class RoleApiController {

    @Autowired private RoleServiceImpl roleService;

    @GetMapping
    public List<Role> getAll() {
        return roleService.getAllRolesWithAdds();
    }
}
