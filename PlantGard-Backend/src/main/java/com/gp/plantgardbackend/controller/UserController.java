package com.gp.plantgardbackend.controller;


import com.gp.plantgardbackend.appuser.AppUserService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

@CrossOrigin(origins = "*", allowedHeaders = "*")
@RestController

public class UserController {
    AppUserService appUserService;
    @GetMapping("/")
  public ResponseEntity<String> getLogedInUser(){
        String email;
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        if (principal instanceof UserDetails) {
            email = ((UserDetails)principal).getUsername();
        } else {
            email = principal.toString();
        }
        String message = "The current logged in user is: "+email;
        return ResponseEntity.status(HttpStatus.OK).body(message);
    }


}