package com.gp.plantgardbackend.controller;

import com.gp.plantgardbackend.dto.FieldDTO;
import com.gp.plantgardbackend.model.Field;
import com.gp.plantgardbackend.service.FieldService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.Set;

@CrossOrigin(origins = "*", allowedHeaders = "*")
@RestController
public class FieldController {
    private final FieldService fieldService;
    public FieldController(FieldService fieldService) {
        this.fieldService = fieldService;
    }

    @PostMapping("/addField")
    public ResponseEntity<?> addField(@RequestBody FieldDTO fieldDTO){
        try {
    fieldService.addField(fieldDTO);
    return ResponseEntity.ok("New field added successfully");
        }catch (IllegalStateException exception){
            throw new ResponseStatusException(
                    HttpStatus.BAD_REQUEST,
                    exception.getMessage()
            );
        }
    }
    @GetMapping("/getFields")
    public List<Field> getFields(){
       return fieldService.getFields();
    }
}
