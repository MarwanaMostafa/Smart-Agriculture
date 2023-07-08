package com.gp.plantgardbackend.registration;

import com.gp.plantgardbackend.appuser.AppUser;
import com.gp.plantgardbackend.appuser.AppUserRole;
import com.gp.plantgardbackend.appuser.AppUserService;
import com.gp.plantgardbackend.dto.LoginDTO;
import com.gp.plantgardbackend.email.EmailBuilder;
import com.gp.plantgardbackend.email.EmailSender;
import com.gp.plantgardbackend.email.EmailValidator;
import com.gp.plantgardbackend.registration.token.ConfirmationToken;
import com.gp.plantgardbackend.registration.token.ConfirmationTokenService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import javax.transaction.Transactional;
import java.time.LocalDateTime;

@Service
public class AuthService {
    @Value("${app.link}")
    private String appLink;

    private final AppUserService appUserService;
    private final EmailValidator emailValidator;
    private final ConfirmationTokenService confirmationTokenService;
    private final EmailSender emailSender;
    private final EmailBuilder emailBuilder;

    public AuthService(
        AppUserService appUserService, 
        EmailValidator emailValidator, 
        ConfirmationTokenService confirmationTokenService, 
        EmailSender emailSender, EmailBuilder builder
    ) {
        this.appUserService = appUserService;
        this.emailValidator = emailValidator;
        this.confirmationTokenService = confirmationTokenService;
        this.emailSender = emailSender;
        this.emailBuilder = builder;
    }


    public String register(RegistrationRequest request){
        boolean isValidEmail = emailValidator.
                test(request.getEmail());

        if (!isValidEmail){
            throw new IllegalStateException("email not valid");
        }

        String token = appUserService.signUpUser(
                new AppUser(
                        request.getFirstName(),
                        request.getLastName(),
                        request.getEmail(),
                        request.getPassword(),
                        AppUserRole.USER
                )
        );

        String link = appLink + token;
        emailSender.send(
                request.getEmail(),
                emailBuilder.confirmationEmail(request.getFirstName(), link));

        return token;
    }

    public boolean checkUser(LoginDTO loginDTO){
        return appUserService.checkUser(loginDTO);
    }

    @Transactional
    public String confirmToken(String token) {
        ConfirmationToken confirmationToken = confirmationTokenService
                .getToken(token)
                .orElseThrow(() ->
                        new IllegalStateException("token not found"));

        if (confirmationToken.getConfirmedAt() != null) {
            throw new IllegalStateException("email already confirmed");
        }

        LocalDateTime expiredAt = confirmationToken.getExpiresAt();

        if (expiredAt.isBefore(LocalDateTime.now())) {
            throw new IllegalStateException("token expired");
        }
        confirmationTokenService.setConfirmedAt(token);
        appUserService.enableAppUser(
                confirmationToken.getAppUser().getEmail());
        return "confirmed";
    }
}

