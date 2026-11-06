package portfolio.example.im_cc.config;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.security.crypto.password.PasswordEncoder;
import portfolio.example.im_cc.models.AppUser;
import portfolio.example.im_cc.repositories.AppUserRepository;
import portfolio.example.im_cc.services.AppUserDetailsService;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;

class OAuth2LoginSuccessHandlerTest {

    private final AppUserRepository users = mock(AppUserRepository.class);
    private final PasswordEncoder encoder = mock(PasswordEncoder.class);
    private final OAuth2LoginSuccessHandler handler =
            new OAuth2LoginSuccessHandler(users, mock(AppUserDetailsService.class), encoder);

    private AppUser victim;

    @BeforeEach
    void setUp() {
        victim = new AppUser();
        victim.setId(7L);
        victim.setEmail("victim@example.com");
        when(users.findByDiscordId(anyString())).thenReturn(Optional.empty());
        when(users.findByEmail("victim@example.com")).thenReturn(Optional.of(victim));
        when(users.save(any(AppUser.class))).thenAnswer(inv -> inv.getArgument(0));
        when(encoder.encode(anyString())).thenReturn("hash");
    }

    @Test
    void unverifiedEmailDoesNotTakeOverExistingAccount() {
        AppUser result = handler.findOrCreate("123", "Victim@Example.com", "attacker", false);

        assertNotSame(victim, result);
        assertNull(victim.getDiscordId());
        assertEquals("123@discord.user", result.getEmail());
        verify(users, never()).findByEmail(anyString());
    }

    @Test
    void verifiedEmailLinksExistingAccount() {
        AppUser result = handler.findOrCreate("123", "Victim@Example.com", "victim", true);

        assertSame(victim, result);
        assertEquals("123", victim.getDiscordId());
    }

    @Test
    void unverifiedEmailIsNotStoredOnNewAccount() {
        AppUser result = handler.findOrCreate("456", "someone@example.com", "someone", false);

        assertEquals("456@discord.user", result.getEmail());
    }

    @Test
    void alreadyLinkedAccountIsReturnedAsIs() {
        AppUser linked = new AppUser();
        when(users.findByDiscordId("789")).thenReturn(Optional.of(linked));

        assertSame(linked, handler.findOrCreate("789", "victim@example.com", "x", false));
        verify(users, never()).save(any());
    }
}
