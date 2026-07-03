package portfolio.example.im_cc.services;

import portfolio.example.im_cc.models.characterwizard.Characteristics;

import java.util.List;

public interface CharacteristicsService {
    List<Characteristics> getAllCharacteristics();
    void save(Characteristics characteristics);
    Characteristics getById(Long id);
    void deleteById(Long id);
}
