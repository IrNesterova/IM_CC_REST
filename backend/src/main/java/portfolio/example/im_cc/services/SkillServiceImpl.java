package portfolio.example.im_cc.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import portfolio.example.im_cc.models.*;
import portfolio.example.im_cc.repositories.CharacteristicsOriginRepository;
import portfolio.example.im_cc.repositories.OriginRepository;
import portfolio.example.im_cc.repositories.SkillRepository;
import portfolio.example.im_cc.repositories.SkillSpecializationsRepository;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

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
