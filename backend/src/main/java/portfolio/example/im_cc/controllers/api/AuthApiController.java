package portfolio.example.im_cc.controllers.api;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.context.HttpSessionSecurityContextRepository;
import org.springframework.security.web.context.SecurityContextRepository;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import portfolio.example.im_cc.models.AppUser;
import portfolio.example.im_cc.repositories.AppUserRepository;

import java.util.Map;

@RestController
@RequestMapping("/api/auth")
public class AuthApiController {
    private final AuthenticationManager authenticationManager;
    private final AppUserRepository users;
    private final PasswordEncoder encoder;
    private final SecurityContextRepository contextRepository = new HttpSessionSecurityContextRepository();

    public AuthApiController(AuthenticationManager authenticationManager, AppUserRepository users, PasswordEncoder encoder) {
        this.authenticationManager = authenticationManager;
        this.users = users;
        this.encoder = encoder;
    }

    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestBody Map<String, String> body) {
        String email = body.get("email").toLowerCase();
        if (users.existsByEmail(email))
            return ResponseEntity.status(409).body(Map.of("error", "email already taken"));

        AppUser u = new AppUser();
        u.setEmail(email);
        u.setDisplayName(body.getOrDefault("displayName", email));
        u.setPasswordHash(encoder.encode(body.get("password")));
        users.save(u);
        return ResponseEntity.status(201).body(Map.of("email", email));
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody Map<String, String> body,
                                   HttpServletRequest req, HttpServletResponse res) {
        String email = body.get("email").toLowerCase();
        try {
            Authentication auth = authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(email, body.get("password")));

            SecurityContext ctx = SecurityContextHolder.createEmptyContext();
            ctx.setAuthentication(auth);
            SecurityContextHolder.setContext(ctx);
            contextRepository.saveContext(ctx, req, res);

            return ResponseEntity.ok(Map.of("email", auth.getName()));
        } catch (AuthenticationException e) {
            return ResponseEntity.status(401).body(Map.of("error", "Invalid email or password"));
        }
    }

    @PostMapping("/logout")
    public ResponseEntity<?> logout(HttpServletRequest req) {
        var session = req.getSession(false);
        if (session != null) session.invalidate();
        SecurityContextHolder.clearContext();
        return ResponseEntity.noContent().build();
    }
}
