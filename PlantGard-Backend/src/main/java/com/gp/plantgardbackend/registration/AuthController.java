package com.gp.plantgardbackend.registration;


import com.gp.plantgardbackend.dto.ConfirmTokenDTO;
import com.gp.plantgardbackend.dto.LoginDTO;
import org.springframework.http.HttpStatus;
import org.springframework.http.RequestEntity;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;


@CrossOrigin(origins = "*", allowedHeaders = "*")

@RestController
@RequestMapping(path = "auth")
public class AuthController {
    private  AuthService authService;
    public AuthController(AuthService authService) {
        this.authService = authService;
    }
    @PostMapping("register")
    public ResponseEntity<ConfirmTokenDTO> register(@RequestBody RegistrationRequest request) {
        try{
            var registerationToken = authService.register(request);
            return ResponseEntity.ok(
                new ConfirmTokenDTO(registerationToken)
            );
        }catch(IllegalStateException exception){
            throw new ResponseStatusException(
                HttpStatus.BAD_REQUEST,
                exception.getMessage()
            );
        }
    }

    // since we're using basic auth. this endpoints only checks if the user creds are valid
    @PostMapping("login")
    public ResponseEntity login(@RequestBody LoginDTO loginDto){
        var userExists = authService.checkUser(loginDto);
        
        return userExists
            ? ResponseEntity.ok().build()
            : ResponseEntity.status(HttpStatus.FORBIDDEN).build();
    }

    @GetMapping(path = "confirm")
    public String confirm(@RequestParam("token") String token) {
        return authService.confirmToken(token);
    }
}