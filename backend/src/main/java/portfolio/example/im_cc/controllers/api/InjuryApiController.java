package portfolio.example.im_cc.controllers.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;
import portfolio.example.im_cc.models.characterwizard.Injury;
import portfolio.example.im_cc.repositories.characterwizard.InjuryRepository;

import java.util.List;

@Transactional(readOnly = true)
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