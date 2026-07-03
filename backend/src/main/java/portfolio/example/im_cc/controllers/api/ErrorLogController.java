package portfolio.example.im_cc.controllers.api;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import portfolio.example.im_cc.models.ErrorLog;
import portfolio.example.im_cc.repositories.AppUserRepository;
import portfolio.example.im_cc.repositories.ErrorLogRepository;

import java.security.Principal;

@RestController
@RequestMapping("/api/error-log")
@RequiredArgsConstructor
public class ErrorLogController {

    private final ErrorLogRepository errorLogs;
    private final AppUserRepository users;

    public record FrontendErrorRequest(String errorType, String message, String stackTrace, String url) {}

    @PostMapping
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void log(@RequestBody FrontendErrorRequest req, Principal principal) {
        Long userId = null;
        if (principal != null) {
            userId = users.findByEmail(principal.getName()).map(u -> u.getId()).orElse(null);
        }
        String msg = req.message();
        String stack = req.stackTrace();
        // Truncate to avoid storing massive payloads
        if (msg != null && msg.length() > 2000) msg = msg.substring(0, 2000);
        if (stack != null && stack.length() > 8000) stack = stack.substring(0, 8000);

        errorLogs.save(new ErrorLog("FRONTEND", req.errorType(), msg, stack, req.url(), userId));
    }
}
