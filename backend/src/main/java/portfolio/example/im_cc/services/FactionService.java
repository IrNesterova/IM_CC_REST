package portfolio.example.im_cc.services;

import portfolio.example.im_cc.models.Characteristics;
import portfolio.example.im_cc.models.Faction;

import java.util.List;

public interface FactionService {
    List<Faction> getAllFactions();
    List<Faction> getAllFactionsWithAdds();
    Faction getById(Long id);
    Faction getFactionWithAdds(Long id);

}
