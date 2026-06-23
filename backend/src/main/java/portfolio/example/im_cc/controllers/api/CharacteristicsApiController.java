package portfolio.example.im_cc.controllers.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import portfolio.example.im_cc.models.Characteristics;
import portfolio.example.im_cc.services.CharacteristicsServiceImpl;

import java.util.List;

@RestController
@RequestMapping("/api/characteristics")
public class CharacteristicsApiController {

    @Autowired private CharacteristicsServiceImpl characteristicsService;

    @GetMapping
    public List<Characteristics> getAll() {
        return characteristicsService.getAllCharacteristics();
    }
}
