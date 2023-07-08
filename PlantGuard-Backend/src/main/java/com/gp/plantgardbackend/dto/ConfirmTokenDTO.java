package com.gp.plantgardbackend.dto;

public class ConfirmTokenDTO {
    private String confirmToken;

    public String getConfirmToken() {
        return confirmToken;
    }

    public void setConfirmToken(String confirmToken) {
        this.confirmToken = confirmToken;
    }

    public ConfirmTokenDTO(String token){
        this.confirmToken = token;
    }

    
}
