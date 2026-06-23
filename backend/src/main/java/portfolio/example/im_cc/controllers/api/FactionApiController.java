package portfolio.example.im_cc.controllers.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import portfolio.example.im_cc.models.Faction;
import portfolio.example.im_cc.services.FactionServiceImpl;

import java.util.List;

@RestController
@RequestMapping("/api/factions")
public class FactionApiController {

    @Autowired private FactionServiceImpl factionService;

    @GetMapping
    public List<Faction> getAll() {
        return factionService.getAllFactionsWithAdds();
    }
}
