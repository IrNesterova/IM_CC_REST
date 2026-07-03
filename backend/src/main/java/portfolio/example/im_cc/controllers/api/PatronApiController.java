package portfolio.example.im_cc.controllers.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import portfolio.example.im_cc.dto.PatronReferenceDTO;
import portfolio.example.im_cc.services.PatronService;

@RestController
@RequestMapping("/api/patron")
public class PatronApiController {

    @Autowired private PatronService patronService;

    @GetMapping("/reference")
    public PatronReferenceDTO getReference() {
        return patronService.getReference();
    }
}
