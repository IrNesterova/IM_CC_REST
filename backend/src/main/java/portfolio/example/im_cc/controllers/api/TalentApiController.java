package portfolio.example.im_cc.controllers.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import portfolio.example.im_cc.models.characterwizard.Talent;
import portfolio.example.im_cc.models.characterwizard.TalentRequirement;
import portfolio.example.im_cc.repositories.characterwizard.TalentRepository;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/talents")
public class TalentApiController {

    @Autowired
    private TalentRepository repo;

    @GetMapping
    public List<Map<String, Object>> getAll() {
        return repo.findAll().stream()
                .sorted((a, b) -> a.getName().compareToIgnoreCase(b.getName()))
                .map(this::toMap)
                .toList();
    }

    private Map<String, Object> toMap(Talent t) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("id", t.getId());
        m.put("name", t.getName());
        m.put("description", t.getDescription());
        m.put("maxAdvances", t.getMaxAdvances());
        m.put("sourceBook", t.getSourceBook());
        m.put("requirements", t.getRequirements().stream().map(this::reqToMap).toList());
        return m;
    }

    private Map<String, Object> reqToMap(TalentRequirement r) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("reqType", r.getReqType());
        m.put("target", r.getTarget());
        m.put("value", r.getValue());
        return m;
    }
}