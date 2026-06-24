package portfolio.example.im_cc.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import portfolio.example.im_cc.repositories.AppUserRepository;

@Service
public class AppUserDetailsService implements UserDetailsService {

    private final AppUserRepository users;
    public AppUserDetailsService(AppUserRepository users) { this.users = users; }

    @Override
    public UserDetails loadUserByUsername(String email) {
        var u = users.findByEmail(email.toLowerCase())
                .orElseThrow(() -> new UsernameNotFoundException(email));
        return User.withUsername(u.getEmail())
                .password(u.getPasswordHash())                       // уже хеш — Spring сам сверит энкодером
                .authorities(new SimpleGrantedAuthority("ROLE_" + u.getRole()))
                .build();
    }
}
