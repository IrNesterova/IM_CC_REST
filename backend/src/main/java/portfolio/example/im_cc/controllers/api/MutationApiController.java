package portfolio.example.im_cc.controllers.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import portfolio.example.im_cc.models.Mutation;
import portfolio.example.im_cc.models.SubtleMutationTableEntry;
import portfolio.example.im_cc.repositories.SubtleMutationTableRepository;

import java.util.*;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/mutations")
public class MutationApiController {

    @Autowired private SubtleMutationTableRepository subtleMutationTableRepository;

    @GetMapping("/subtle")
    public List<Map<String, Object>> getSubtleTable() {
        return subtleMutationTableRepository.findAllByOrderByD100MinAsc().stream()
            .map(this::entryToMap)
            .collect(Collectors.toList());
    }

    private Map<String, Object> entryToMap(SubtleMutationTableEntry e) {
        Map<String, Object> row = new LinkedHashMap<>();
        row.put("d100Min", e.getD100Min());
        row.put("d100Max", e.getD100Max());
        row.put("positive", mutationToMap(e.getPositiveMutation()));
        row.put("negative", mutationToMap(e.getNegativeMutation()));
        return row;
    }

    private Map<String, Object> mutationToMap(Mutation m) {
        Map<String, Object> map = new LinkedHashMap<>();
        map.put("id", m.getId());
        map.put("name", m.getName());
        map.put("description", m.getDescription());
        map.put("mutationType", m.getMutationType());
        map.put("d100Range", m.getD100Range());
        return map;
    }
}