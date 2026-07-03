package portfolio.example.im_cc.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import portfolio.example.im_cc.dto.PatronReferenceDTO;
import portfolio.example.im_cc.repositories.characterwizard.FactionRepository;
import portfolio.example.im_cc.repositories.patron.*;

import java.util.stream.Collectors;

@Service
@Transactional(readOnly = true)
public class PatronService {

    @Autowired private FactionRepository factionRepository;
    @Autowired private PatronMotivationRepository motivationRepo;
    @Autowired private PatronDemeanourRepository demeanourRepo;
    @Autowired private PatronPaymentGradeRepository paymentGradeRepo;
    @Autowired private PatronDutyRepository dutyRepo;

    public PatronReferenceDTO getReference() {
        return new PatronReferenceDTO(
                factionRepository.findAllSimple(),
                motivationRepo.findAll(),
                demeanourRepo.findAll(),
                paymentGradeRepo.findAll(),
                dutyRepo.findAll().stream().distinct().collect(Collectors.toList())
        );
    }
}