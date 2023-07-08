package com.gp.plantgardbackend.email;

public interface EmailSender {
    void send(String to, String email);
}