package portfolio.example.im_cc.controllers.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import portfolio.example.im_cc.models.PsychicDiscipline;
import portfolio.example.im_cc.repositories.PsychicDisciplineRepository;

import java.util.List;

@RestController
@RequestMapping("/api/psychic-disciplines")
public class PsychicDisciplineApiController {

    @Autowired
    private PsychicDisciplineRepository repository;

    @GetMapping
    public List<PsychicDiscipline> getAll() {
        return repository.findAll();
    }
}
