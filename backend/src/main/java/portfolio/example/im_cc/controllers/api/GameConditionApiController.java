package portfolio.example.im_cc.controllers.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import portfolio.example.im_cc.models.GameCondition;
import portfolio.example.im_cc.repositories.GameConditionRepository;

import java.util.List;

@RestController
@RequestMapping("/api/conditions")
public class GameConditionApiController {

    @Autowired
    private GameConditionRepository repository;

    @GetMapping
    public List<GameCondition> getAll() {
        return repository.findAll();
    }
}