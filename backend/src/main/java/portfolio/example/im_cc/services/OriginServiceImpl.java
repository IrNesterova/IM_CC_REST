package portfolio.example.im_cc.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import portfolio.example.im_cc.models.*;
import portfolio.example.im_cc.repositories.*;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class OriginServiceImpl implements OriginService {

    @Autowired private OriginRepository originRepository;
    @Autowired private CharacteristicsOriginRepository characteristicsOriginRepository;
    @Autowired private OriginTalentRepository originTalentRepository;
    @Autowired private OriginInventoryItemRepository originInventoryItemRepository;
    @Autowired private OriginSkillRepository originSkillRepository;
    @Autowired private OriginSpecializationRepository originSpecializationRepository;

    @Override
    public List<Origin> getAllOrigins() {
        List<Origin> originsList = originRepository.findAll(Sort.by(Sort.Direction.ASC, "id"));
        for (Origin or : originsList) {
            List<CharacteristicsOrigin> primeCharRows = characteristicsOriginRepository.findByOriginIdAndPrimaryChar(or.getId(), true);
            List<Characteristics> primeC = new ArrayList<>();
            for (CharacteristicsOrigin ch : primeCharRows) primeC.add(ch.getCharacteristics());
            or.setPrimaryCharacteristsics(primeC);

            List<CharacteristicsOrigin> secCharRows = characteristicsOriginRepository.findByOriginIdAndPrimaryChar(or.getId(), false);
            List<Characteristics> secC = new ArrayList<>();
            for (CharacteristicsOrigin ch : secCharRows) secC.add(ch.getCharacteristics());
            or.setSecondaryCharacteristsics(secC);

            List<OriginTalent> talentRows = originTalentRepository.findByOriginId(or.getId());
            List<Talent> talents = new ArrayList<>();
            for (OriginTalent ot : talentRows) talents.add(ot.getTalent());
            or.setTalentList(talents);

            or.setStartingItems(originInventoryItemRepository.findByOriginId(or.getId()));
            or.setSkillAdvances(originSkillRepository.findByOriginId(or.getId()));
            or.setSpecAdvances(originSpecializationRepository.findByOriginId(or.getId()));
        }
        return originsList;
    }

    @Override
    public void save(Origin origin) {
        originRepository.save(origin);
    }

    @Override
    public Origin getById(Long id) {
        Optional<Origin> optional = originRepository.findById(id);
        if (optional.isPresent()) return optional.get();
        throw new RuntimeException("Origin is not found by id: " + id);
    }

    @Override
    public void deleteById(Long id) {
        originRepository.deleteById(id);
    }
}