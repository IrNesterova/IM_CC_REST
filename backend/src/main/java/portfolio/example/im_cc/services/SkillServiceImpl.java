package portfolio.example.im_cc.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import portfolio.example.im_cc.models.characterwizard.Skill;
import portfolio.example.im_cc.repositories.characterwizard.SkillRepository;
import portfolio.example.im_cc.repositories.characterwizard.SkillSpecializationsRepository;

import java.util.List;

@Service
public class SkillServiceImpl implements SkillService{
    @Autowired
    private SkillRepository skillRepository;
    @Autowired
    private SkillSpecializationsRepository skillSpecializationsRepository;

    @Override
    public List<Skill> getAllSkills() {
        return skillRepository.findAll();
    }

    @Override
    public List<Skill> getAllSkillsWithSpecs() {
        return skillRepository.findAll();
    }

    @Override
    public void save(Skill skill) {
        skillRepository.save(skill);
    }

    @Override
    public Skill getById(Long id) {
        return skillRepository.getById(id);
    }

    @Override
    public void deleteById(Long id) {
        skillRepository.deleteById(id);
    }
}
