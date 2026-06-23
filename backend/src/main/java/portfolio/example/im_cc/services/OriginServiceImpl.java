package portfolio.example.im_cc.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import portfolio.example.im_cc.models.Characteristics;
import portfolio.example.im_cc.models.CharacteristicsOrigin;
import portfolio.example.im_cc.models.Origin;
import portfolio.example.im_cc.repositories.CharacteristicsOriginRepository;
import portfolio.example.im_cc.repositories.OriginRepository;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class OriginServiceImpl implements OriginService {

    @Autowired
    private OriginRepository originRepository;
    @Autowired
    private CharacteristicsOriginRepository characteristicsOriginRepository;

    @Override
    public List<Origin> getAllOrigins() {

        List<Origin> originsList = originRepository.findAll(Sort.by(Sort.Direction.ASC, "id"));
        for (Origin or : originsList){
            List<CharacteristicsOrigin> PrimeChar = characteristicsOriginRepository.findByOriginIdAndPrimaryChar(or.getId(), true);
            List<Characteristics> primeC = new ArrayList<>();
            for (CharacteristicsOrigin ch : PrimeChar){
                primeC.add(ch.getCharacteristics());
            }
            or.setPrimaryCharacteristsics(primeC);

            List<CharacteristicsOrigin> SecOChar = characteristicsOriginRepository.findByOriginIdAndPrimaryChar(or.getId(),false);
            List<Characteristics> secChar = new ArrayList<>();
            for (CharacteristicsOrigin ch: SecOChar){
                secChar.add(ch.getCharacteristics());
            }
            or.setSecondaryCharacteristsics(secChar);
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
        Origin origin = null;
        if (optional.isPresent()){
            origin = optional.get();

        } else{
            throw new RuntimeException("Origin is not found by id: " + id);
        }
        return origin;

    }

    @Override
    public void deleteById(Long id) {
        originRepository.deleteById(id);
    }
}
