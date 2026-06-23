package portfolio.example.im_cc.services;

import portfolio.example.im_cc.models.Characteristics;
import portfolio.example.im_cc.models.Skill;

import java.util.List;

public interface SkillService {
    List<Skill> getAllSkills();
    List<Skill> getAllSkillsWithSpecs();
    void save(Skill skill);
    Skill getById(Long id);
    void deleteById(Long id);
}
