package com.gp.plantgardbackend.controller;


import com.gp.plantgardbackend.dao.FieldAnalysisRepository;
import com.gp.plantgardbackend.dao.FieldRepository;
import com.gp.plantgardbackend.model.Field;
import com.gp.plantgardbackend.model.FieldAnalysis;
import com.gp.plantgardbackend.service.FieldAnalysisService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Set;

@CrossOrigin(origins = "*", allowedHeaders = "*")
@RestController
public class FieldAnalysisController {


    public static class DiseaseData {
        public String[][] d;

        public String[][] getDisease() {
            return d;
        }

        public void setDisease(String[][] disease) {
            this.d = disease;
        }
    }

    @Autowired
    FieldAnalysisRepository fieldAnalysisRepository;
    @Autowired
    FieldRepository fieldRepository;
    private final FieldAnalysisService fieldAnalysisService;
    public FieldAnalysisController(FieldAnalysisService fieldAnalysisService) {
        this.fieldAnalysisService = fieldAnalysisService;
    }
    @PostMapping("/addFieldAnalysis")
    public ResponseEntity<?> addFieldAnalysis(@RequestBody DiseaseData request,@RequestParam long FieldID,@RequestParam long FieldAnalysisID){
       String disease[][]=request.getDisease();
       if(FieldAnalysisID<0||!fieldAnalysisRepository.existsById(FieldAnalysisID)){
           try {
               long fieldAnalysisID= fieldAnalysisService.addNewFieldAnalysis(disease,FieldID,FieldAnalysisID);
               return  ResponseEntity.ok("New Field Analysis added successfully , the newly created ID: "+fieldAnalysisID);
           }catch (Exception e){
               return (ResponseEntity<?>) ResponseEntity.badRequest();
           }
       }else {
           try {
               fieldAnalysisService.ModifyFieldAnalysis(disease,FieldAnalysisID);
               return  ResponseEntity.ok("Field Analysis Modified successfully");
           }catch (Exception e){
               return (ResponseEntity<?>) ResponseEntity.badRequest();
           }
       }
    }

    @GetMapping("/getFieldAnalysis")
    public Set<FieldAnalysis> getFieldAnalysis(@RequestParam long FieldID){
        Field field =fieldRepository.findById(FieldID).get();
        return field.getFieldAnalysis();
    }
}
