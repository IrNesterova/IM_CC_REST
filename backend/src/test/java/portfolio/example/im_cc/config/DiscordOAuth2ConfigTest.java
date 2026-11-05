package portfolio.example.im_cc.config;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.runner.ApplicationContextRunner;
import org.springframework.security.oauth2.client.registration.ClientRegistrationRepository;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;

class DiscordOAuth2ConfigTest {

    private final ApplicationContextRunner runner = new ApplicationContextRunner()
            .withUserConfiguration(DiscordOAuth2Config.class)
            .withPropertyValues("app.discord.redirect-uri=http://localhost:8081/login/oauth2/code/discord");

    @Test
    void noRegistrationWhenClientIdIsBlank() {
        runner.withPropertyValues("app.discord.client-id=")
                .run(context -> assertFalse(context.containsBean("clientRegistrationRepository")));
    }

    @Test
    void registersDiscordWhenClientIdIsSet() {
        runner.withPropertyValues("app.discord.client-id=abc", "app.discord.client-secret=secret")
                .run(context -> {
                    var registration = context.getBean(ClientRegistrationRepository.class)
                            .findByRegistrationId("discord");
                    assertEquals("abc", registration.getClientId());
                    assertEquals("id", registration.getProviderDetails().getUserInfoEndpoint().getUserNameAttributeName());
                });
    }
}
