package portfolio.example.im_cc.controllers.api;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ProblemDetail;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.context.request.ServletWebRequest;
import org.springframework.web.context.request.WebRequest;
import org.springframework.web.servlet.mvc.method.annotation.ResponseEntityExceptionHandler;
import portfolio.example.im_cc.models.ErrorLog;
import portfolio.example.im_cc.repositories.AppUserRepository;
import portfolio.example.im_cc.repositories.ErrorLogRepository;

import java.io.PrintWriter;
import java.io.StringWriter;

/**
 * Standard Spring MVC errors (400, 404, 405...) keep their status via the base class.
 * Only server errors (5xx) are logged and stored in the database.
 */
@RestControllerAdvice
@RequiredArgsConstructor
public class GlobalExceptionHandler extends ResponseEntityExceptionHandler {

    private static final Logger log = LoggerFactory.getLogger(GlobalExceptionHandler.class);

    private final ErrorLogRepository errorLogs;
    private final AppUserRepository users;

    @ExceptionHandler(Exception.class)
    public ProblemDetail handleAll(Exception ex, HttpServletRequest request) {
        recordServerError(ex, request);
        return ProblemDetail.forStatusAndDetail(HttpStatus.INTERNAL_SERVER_ERROR, "An unexpected error occurred.");
    }

    @Override
    protected ResponseEntity<Object> handleExceptionInternal(Exception ex, Object body, HttpHeaders headers,
                                                             HttpStatusCode statusCode, WebRequest request) {
        if (statusCode.is5xxServerError() && request instanceof ServletWebRequest servletRequest) {
            recordServerError(ex, servletRequest.getRequest());
        }
        return super.handleExceptionInternal(ex, body, headers, statusCode, request);
    }

    private void recordServerError(Exception ex, HttpServletRequest request) {
        log.error("Unhandled exception at {}", request.getRequestURI(), ex);
        saveToDb(ex, request);
    }

    private void saveToDb(Exception ex, HttpServletRequest request) {
        try {
            String stack = stackTrace(ex);
            if (stack.length() > 8000) stack = stack.substring(0, 8000);

            String msg = ex.getMessage();
            if (msg != null && msg.length() > 2000) msg = msg.substring(0, 2000);

            Long userId = resolveUserId();
            errorLogs.save(new ErrorLog(
                    "BACKEND",
                    ex.getClass().getSimpleName(),
                    msg,
                    stack,
                    request.getRequestURI(),
                    userId
            ));
        } catch (Exception ignore) {
            // Never let error-logging crash the response
        }
    }

    private Long resolveUserId() {
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            if (auth == null || !auth.isAuthenticated() || "anonymousUser".equals(auth.getPrincipal())) {
                return null;
            }
            return users.findByEmail(auth.getName()).map(u -> u.getId()).orElse(null);
        } catch (Exception e) {
            return null;
        }
    }

    private static String stackTrace(Exception ex) {
        StringWriter sw = new StringWriter();
        ex.printStackTrace(new PrintWriter(sw));
        return sw.toString();
    }
}
