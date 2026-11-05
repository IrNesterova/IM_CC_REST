package portfolio.example.im_cc.controllers.api;

import org.junit.jupiter.api.Test;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import portfolio.example.im_cc.models.ErrorLog;
import portfolio.example.im_cc.repositories.AppUserRepository;
import portfolio.example.im_cc.repositories.ErrorLogRepository;
import portfolio.example.im_cc.services.LobbyException;
import portfolio.example.im_cc.services.LobbyExceptionHandler;

import java.util.Map;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

class GlobalExceptionHandlerTest {

    @RestController
    static class TestController {
        @PostMapping("/body")
        void body(@RequestBody Map<String, String> body) {}

        @GetMapping("/param")
        void param(@RequestParam String required) {}

        @GetMapping("/room-missing")
        void roomMissing() {
            throw new LobbyException(LobbyException.Reason.ROOM_NOT_FOUND, "missing");
        }

        @GetMapping("/not-gm")
        void notGm() {
            throw new LobbyException(LobbyException.Reason.NOT_GM, "forbidden");
        }

        @GetMapping("/boom")
        void boom() {
            throw new IllegalStateException("boom");
        }
    }

    private final ErrorLogRepository errorLogs = mock(ErrorLogRepository.class);

    // The global handler is listed first on purpose: LobbyExceptionHandler must still win through @Order.
    private final MockMvc mvc = MockMvcBuilders.standaloneSetup(new TestController())
            .setControllerAdvice(
                    new GlobalExceptionHandler(errorLogs, mock(AppUserRepository.class)),
                    new LobbyExceptionHandler())
            .build();

    @Test
    void malformedJsonIsBadRequestAndNotStored() throws Exception {
        mvc.perform(post("/body").contentType(MediaType.APPLICATION_JSON).content("{not json"))
                .andExpect(status().isBadRequest());
        verifyNoInteractions(errorLogs);
    }

    @Test
    void missingParameterIsBadRequestAndNotStored() throws Exception {
        mvc.perform(get("/param")).andExpect(status().isBadRequest());
        verifyNoInteractions(errorLogs);
    }

    @Test
    void wrongMethodIsMethodNotAllowedAndNotStored() throws Exception {
        mvc.perform(get("/body")).andExpect(status().isMethodNotAllowed());
        verifyNoInteractions(errorLogs);
    }

    @Test
    void lobbyExceptionsKeepTheirStatusAndAreNotStored() throws Exception {
        mvc.perform(get("/room-missing")).andExpect(status().isNotFound());
        mvc.perform(get("/not-gm")).andExpect(status().isForbidden());
        verifyNoInteractions(errorLogs);
    }

    @Test
    void unexpectedErrorIsServerErrorAndStored() throws Exception {
        mvc.perform(get("/boom")).andExpect(status().isInternalServerError());
        verify(errorLogs).save(any(ErrorLog.class));
    }
}
