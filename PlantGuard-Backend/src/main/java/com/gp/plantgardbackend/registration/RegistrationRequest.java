package com.gp.plantgardbackend.registration;

import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.ToString;

@Getter
@EqualsAndHashCode
@ToString
public class RegistrationRequest {
    private  final String firstName;
    private final String lastName;
    private  final String email;
    private  final String password;

    public RegistrationRequest(String firstName , String lastName, String email,String password ) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.password = password;
    }

    public RegistrationRequest(){
        this("","","","");
    }

    public String  getEmail() {
        return email;
    }

    public String  getFirstName() {
        return firstName;
    }

    public String  getLastName() {
        return lastName;
    }

    public String  getPassword() {
        return password;
    }


}