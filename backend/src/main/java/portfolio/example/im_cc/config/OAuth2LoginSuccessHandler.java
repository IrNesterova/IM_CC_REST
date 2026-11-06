package portfolio.example.im_cc.config;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler;
import org.springframework.security.web.context.HttpSessionSecurityContextRepository;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import portfolio.example.im_cc.models.AppUser;
import portfolio.example.im_cc.repositories.AppUserRepository;
import portfolio.example.im_cc.services.AppUserDetailsService;

import java.io.IOException;
import java.util.UUID;

@Component
public class OAuth2LoginSuccessHandler extends SimpleUrlAuthenticationSuccessHandler {

    private final AppUserRepository users;
    private final AppUserDetailsService uds;
    private final PasswordEncoder encoder;
    private final HttpSessionSecurityContextRepository contextRepo = new HttpSessionSecurityContextRepository();

    @Value("${FRONTEND_URL:http://localhost:3000}")
    private String frontendUrl;

    public OAuth2LoginSuccessHandler(AppUserRepository users, AppUserDetailsService uds, PasswordEncoder encoder) {
        this.users = users;
        this.uds = uds;
        this.encoder = encoder;
    }

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
                                        Authentication authentication) throws IOException {
        OAuth2User oauthUser = (OAuth2User) authentication.getPrincipal();

        Object rawId = oauthUser.getAttribute("id");
        String discordId = rawId == null ? null : rawId.toString();
        Object rawEmail = oauthUser.getAttribute("email");
        String email = rawEmail == null ? null : rawEmail.toString();
        Object rawUsername = oauthUser.getAttribute("username");
        String username = rawUsername == null ? null : rawUsername.toString();
        boolean emailVerified = Boolean.TRUE.equals(oauthUser.getAttribute("verified"));

        AppUser appUser = findOrCreate(discordId, email, username, emailVerified);

        // Swap to our email-based principal so principal.getName() == email everywhere
        UserDetails userDetails = uds.loadUserByUsername(appUser.getEmail());
        UsernamePasswordAuthenticationToken token =
                new UsernamePasswordAuthenticationToken(userDetails, null, userDetails.getAuthorities());

        SecurityContext ctx = SecurityContextHolder.createEmptyContext();
        ctx.setAuthentication(token);
        SecurityContextHolder.setContext(ctx);
        contextRepo.saveContext(ctx, request, response);

        getRedirectStrategy().sendRedirect(request, response, frontendUrl + "/cabinet?auth=discord");
    }

    AppUser findOrCreate(String discordId, String email, String username, boolean emailVerified) {
        if (discordId == null) throw new IllegalStateException("Discord did not return a user id");

        // 1. already linked by discord id
        return users.findByDiscordId(discordId).orElseGet(() -> {
            // Only an address Discord has verified may claim or reserve an account email. Otherwise
            // anyone could add a victim's address to their Discord profile and log in as the victim.
            String verifiedEmail = emailVerified && email != null ? email.toLowerCase() : null;

            // 2. existing email account → link it
            if (verifiedEmail != null) {
                AppUser existing = users.findByEmail(verifiedEmail).orElse(null);
                if (existing != null) {
                    existing.setDiscordId(discordId);
                    return users.save(existing);
                }
            }
            // 3. brand new user
            AppUser u = new AppUser();
            u.setDiscordId(discordId);
            u.setEmail(verifiedEmail != null ? verifiedEmail : discordId + "@discord.user");
            u.setDisplayName(username);
            // random unguessable password so form-login is impossible for OAuth-only accounts
            u.setPasswordHash(encoder.encode(UUID.randomUUID().toString()));
            return users.save(u);
        });
    }
}
