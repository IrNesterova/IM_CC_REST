package portfolio.example.im_cc.services;

import portfolio.example.im_cc.models.characterwizard.Origin;

import java.util.List;

public interface OriginService {
    List<Origin> getAllOrigins();
    void save(Origin origin);
    Origin getById(Long id);
    void deleteById(Long id);
}
