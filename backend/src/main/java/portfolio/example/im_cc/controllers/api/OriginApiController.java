package portfolio.example.im_cc.controllers.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import portfolio.example.im_cc.models.characterwizard.Origin;
import portfolio.example.im_cc.services.OriginServiceImpl;

import java.util.List;

@Transactional(readOnly = true)
@RestController
@RequestMapping("/api/origins")
public class OriginApiController {

    @Autowired private OriginServiceImpl originService;

    @GetMapping
    public List<Origin> getAll() {
        return originService.getAllOrigins();
    }
}
