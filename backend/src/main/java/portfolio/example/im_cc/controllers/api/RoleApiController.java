package portfolio.example.im_cc.controllers.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import portfolio.example.im_cc.models.Role;
import portfolio.example.im_cc.services.RoleServiceImpl;

import java.util.List;

@RestController
@RequestMapping("/api/roles")
public class RoleApiController {

    @Autowired private RoleServiceImpl roleService;

    @GetMapping
    public List<Role> getAll() {
        return roleService.getAllRolesWithAdds();
    }
}
