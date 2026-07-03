package portfolio.example.im_cc.dto;

import portfolio.example.im_cc.models.patron.*;

import java.util.List;

public record PatronReferenceDTO(
        List<PatronFactionEntry> factions,
        List<PatronMotivation> motivations,
        List<PatronDemeanour> demeanours,
        List<PatronPaymentGrade> paymentGrades,
        List<PatronDuty> duties
) {}