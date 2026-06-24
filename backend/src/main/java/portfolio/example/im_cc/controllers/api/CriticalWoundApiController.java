package portfolio.example.im_cc.controllers.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import portfolio.example.im_cc.models.BodyLocation;
import portfolio.example.im_cc.models.CriticalWound;
import portfolio.example.im_cc.repositories.CriticalWoundRepository;

import java.util.List;

@RestController
@RequestMapping("/api/critical-wounds")
public class CriticalWoundApiController {

    @Autowired
    private CriticalWoundRepository repository;

    // GET /api/critical-wounds?location=HEAD
    // GET /api/critical-wounds?location=HEAD&roll=13
    @GetMapping
    public ResponseEntity<?> get(
            @RequestParam BodyLocation location,
            @RequestParam(required = false) Integer roll) {

        if (roll != null) {
            return repository.findByLocationAndRoll(location, roll)
                    .map(ResponseEntity::ok)
                    .orElse(ResponseEntity.notFound().build());
        }

        List<CriticalWound> results = repository.findByLocationOrderByRollMin(location);
        return ResponseEntity.ok(results);
    }
}