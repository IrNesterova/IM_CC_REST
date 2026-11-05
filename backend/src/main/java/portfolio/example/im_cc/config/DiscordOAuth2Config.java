package portfolio.example.im_cc.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnExpression;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.oauth2.client.registration.ClientRegistration;
import org.springframework.security.oauth2.client.registration.ClientRegistrationRepository;
import org.springframework.security.oauth2.client.registration.InMemoryClientRegistrationRepository;
import org.springframework.security.oauth2.core.AuthorizationGrantType;

/**
 * Registers Discord login only when a client id is configured, so the app can run
 * without Discord credentials (email/password login stays available).
 */
@Configuration
public class DiscordOAuth2Config {

    @Bean
    @ConditionalOnExpression("!'${app.discord.client-id:}'.isBlank()")
    public ClientRegistrationRepository clientRegistrationRepository(
            @Value("${app.discord.client-id}") String clientId,
            @Value("${app.discord.client-secret:}") String clientSecret,
            @Value("${app.discord.redirect-uri}") String redirectUri) {
        ClientRegistration discord = ClientRegistration.withRegistrationId("discord")
                .clientId(clientId)
                .clientSecret(clientSecret)
                .authorizationGrantType(AuthorizationGrantType.AUTHORIZATION_CODE)
                .redirectUri(redirectUri)
                .scope("identify", "email")
                .clientName("Discord")
                .authorizationUri("https://discord.com/api/oauth2/authorize")
                .tokenUri("https://discord.com/api/oauth2/token")
                .userInfoUri("https://discord.com/api/users/@me")
                .userNameAttributeName("id")
                .build();
        return new InMemoryClientRegistrationRepository(discord);
    }
}
