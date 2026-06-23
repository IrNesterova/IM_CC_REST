package portfolio.example.im_cc.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import portfolio.example.im_cc.models.Characteristics;
import portfolio.example.im_cc.repositories.CharacteristicsRepository;

import java.util.List;
import java.util.Optional;

@Service
public class CharacteristicsServiceImpl implements CharacteristicsService{

    @Autowired
    private CharacteristicsRepository characteristicsRepository;
    @Override
    public List<Characteristics> getAllCharacteristics() {
        return characteristicsRepository.findAll(Sort.by(Sort.Direction.ASC, "id"));
    }

    @Override
    public void save(Characteristics characteristics) {

        characteristicsRepository.save(characteristics);
    }

    @Override
    public Characteristics getById(Long id) {
        Optional<Characteristics> optional = characteristicsRepository.findById(id);
        Characteristics characteristics = null;
        if (optional.isPresent()){
            characteristics = optional.get();

        } else{
            throw new RuntimeException("Characteristics not found by id: " + id);
        }
        return characteristics;

    }

    @Override
    public void deleteById(Long id) {
        characteristicsRepository.deleteById(id);
    }
}
