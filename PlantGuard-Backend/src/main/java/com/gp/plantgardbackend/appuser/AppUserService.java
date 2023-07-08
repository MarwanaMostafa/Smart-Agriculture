package com.gp.plantgardbackend.appuser;



import com.gp.plantgardbackend.dto.LoginDTO;
import com.gp.plantgardbackend.registration.token.ConfirmationToken;
import com.gp.plantgardbackend.registration.token.ConfirmationTokenRepository;
import com.gp.plantgardbackend.registration.token.ConfirmationTokenService;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.UUID;

@Service
public class AppUserService implements UserDetailsService {

    private final static String USER_NOT_FOUND_MSG =
            "user with email %s not found";

    private final AppUserRepository appUserRepository;
    private final ConfirmationTokenRepository tokenRepository;
    private final BCryptPasswordEncoder bCryptPasswordEncoder;
    private final ConfirmationTokenService confirmationTokenService;

    public AppUserService(
        AppUserRepository appUserRepository, 
        BCryptPasswordEncoder bCryptPasswordEncoder, 
        ConfirmationTokenService confirmationTokenService, 
        ConfirmationTokenRepository tokenRepository
        ) {
        this.appUserRepository = appUserRepository;
        this.bCryptPasswordEncoder = bCryptPasswordEncoder;
        this.confirmationTokenService = confirmationTokenService;
        this.tokenRepository = tokenRepository;
    }



    @Override
    public UserDetails loadUserByUsername(String email)
            throws UsernameNotFoundException {
        return appUserRepository.findByEmail(email)
                .orElseThrow(() ->
                        new UsernameNotFoundException(
                                String.format(USER_NOT_FOUND_MSG, email)));
    }

    public String signUpUser(AppUser appUser) {
        var userOptional = appUserRepository.findByEmail(appUser.getEmail());

        if (userOptional.isPresent()) {
            var retrievedUser = userOptional.get();
            if(!retrievedUser.isEnabled()){
                var optionalToken = tokenRepository.findByAppUser(retrievedUser);
                if(optionalToken.isPresent()){
                    return optionalToken.get().getToken();
                }
            }
            throw new IllegalStateException("email already taken");
        }

        String encodedPassword = bCryptPasswordEncoder
                .encode(appUser.getPassword());

        appUser.setPassword(encodedPassword);

        appUserRepository.save(appUser);

        String token = UUID.randomUUID().toString();

        ConfirmationToken confirmationToken = new ConfirmationToken(
                token,
                LocalDateTime.now(),
                LocalDateTime.now().plusMinutes(30),
                appUser
        );

        confirmationTokenService.saveConfirmationToken(
                confirmationToken);

//         SEND EMAIL

        return token;
    }

    public int enableAppUser(String email) {
        return appUserRepository.enableAppUser(email);
    }


    public boolean checkUser(LoginDTO loginDTO){
        String email = loginDTO.getEmail();
        String password = loginDTO.getPassword();
        if(email.equals("") || password.equals("")) return false;
            
        var userOptional = appUserRepository.findByEmail(email);

        if(!userOptional.isPresent()) return false;

        var actualUserPassword = userOptional.get().getPassword();

        return bCryptPasswordEncoder.matches(password, actualUserPassword);

    }
    public AppUser getLogedInUser(){
        AppUser appUser;
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        if (principal instanceof UserDetails) {
            appUser = (AppUser) principal;
            return appUser;
        } else {
            throw new IllegalStateException("User not valid");        }
    }
}