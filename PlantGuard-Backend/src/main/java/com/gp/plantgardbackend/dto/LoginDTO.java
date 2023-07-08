package com.gp.plantgardbackend.dto;

public class LoginDTO {
    private String email;
    private String password;

    public LoginDTO(){
        email = "";
        password = "";
    }

    public String getEmail(){ return email; }
    public String getPassword() { return password; }
}
