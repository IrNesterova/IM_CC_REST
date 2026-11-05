package portfolio.example.im_cc.services;

import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.http.HttpStatus;
import org.springframework.http.ProblemDetail;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

// Must run before GlobalExceptionHandler, whose catch-all would otherwise turn these into 500s.
@Order(Ordered.HIGHEST_PRECEDENCE)
@RestControllerAdvice
public class LobbyExceptionHandler {
    @ExceptionHandler(LobbyException.class)
    public ProblemDetail handle(LobbyException ex) {
        HttpStatus status = switch (ex.getReason()) {
            case ROOM_NOT_FOUND    -> HttpStatus.NOT_FOUND;   // 404
            case ROOM_CLOSED       -> HttpStatus.FORBIDDEN;   // 403
            case ALREADY_MEMBER    -> HttpStatus.CONFLICT;    // 409
            case NOT_GM            -> HttpStatus.FORBIDDEN;   // 403
            case MEMBER_NOT_FOUND  -> HttpStatus.NOT_FOUND;   // 404
        };
        return ProblemDetail.forStatusAndDetail(status, ex.getMessage());
    }
}
