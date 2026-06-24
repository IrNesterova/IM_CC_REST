package portfolio.example.im_cc.controllers.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;
import portfolio.example.im_cc.models.CharacterInjury;
import portfolio.example.im_cc.models.CharacterSheetDTO;
import portfolio.example.im_cc.models.Injury;
import portfolio.example.im_cc.repositories.CharacterInjuryRepository;
import portfolio.example.im_cc.repositories.CharacterSaveRepository;
import portfolio.example.im_cc.repositories.InjuryRepository;

import java.util.List;

@RestController
@RequestMapping("/api/character/{code}/injuries")
public class CharacterInjuryApiController {

    @Autowired private CharacterInjuryRepository characterInjuryRepository;
    @Autowired private CharacterSaveRepository characterSaveRepository;
    @Autowired private InjuryRepository injuryRepository;

    // GET /api/character/{code}/injuries
    @GetMapping
    public ResponseEntity<List<CharacterSheetDTO.InjuryEntry>> getInjuries(@PathVariable String code) {
        return characterSaveRepository.findBySaveCode(code)
                .map(save -> {
                    List<CharacterSheetDTO.InjuryEntry> entries = characterInjuryRepository
                            .findByCharacterSaveIdOrderByAcquiredAt(save.getId())
                            .stream()
                            .map(ci -> new CharacterSheetDTO.InjuryEntry(
                                    ci.getInjury().getName(),
                                    ci.getInjury().getAffectedPart(),
                                    ci.getInjury().getEffect(),
                                    ci.getInjury().getTreatment(),
                                    ci.getNotes()))
                            .toList();
                    return ResponseEntity.ok(entries);
                })
                .orElse(ResponseEntity.notFound().build());
    }

    // POST /api/character/{code}/injuries
    // body: { "injuryId": 5, "notes": "потерял 3 пальца" }
    @PostMapping
    public ResponseEntity<Void> addInjury(@PathVariable String code, @RequestBody AddInjuryRequest req) {
        var save = characterSaveRepository.findBySaveCode(code).orElse(null);
        if (save == null) return ResponseEntity.notFound().build();

        Injury injury = injuryRepository.findById(req.injuryId()).orElse(null);
        if (injury == null) return ResponseEntity.badRequest().build();

        CharacterInjury ci = new CharacterInjury();
        ci.setCharacterSave(save);
        ci.setInjury(injury);
        ci.setNotes(req.notes());
        characterInjuryRepository.save(ci);

        return ResponseEntity.ok().build();
    }

    // DELETE /api/character/{code}/injuries/{injuryId}
    @DeleteMapping("/{injuryId}")
    @Transactional
    public ResponseEntity<Void> removeInjury(@PathVariable String code, @PathVariable Long injuryId) {
        return characterSaveRepository.findBySaveCode(code)
                .map(save -> {
                    characterInjuryRepository.deleteByCharacterSaveIdAndInjuryId(save.getId(), injuryId);
                    return ResponseEntity.ok().<Void>build();
                })
                .orElse(ResponseEntity.notFound().build());
    }

    public record AddInjuryRequest(Long injuryId, String notes) {}
}