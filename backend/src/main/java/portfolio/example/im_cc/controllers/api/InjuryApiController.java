package portfolio.example.im_cc.controllers.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import portfolio.example.im_cc.models.Injury;
import portfolio.example.im_cc.repositories.InjuryRepository;

import java.util.List;

@RestController
@RequestMapping("/api/injuries")
public class InjuryApiController {

    @Autowired
    private InjuryRepository injuryRepository;

    @GetMapping
    public List<Injury> getAll() {
        return injuryRepository.findAll();
    }
}