package com.gp.plantgardbackend.service;

import com.gp.plantgardbackend.dao.FieldAnalysisRepository;
import com.gp.plantgardbackend.dao.FieldRepository;
import com.gp.plantgardbackend.model.Field;
import com.gp.plantgardbackend.model.FieldAnalysis;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Set;
@Service

public class FieldAnalysisService {

    @Autowired
    FieldAnalysisRepository fieldAnalysisRepository;
    @Autowired
    FieldRepository fieldRepository;



    public long addNewFieldAnalysis(String disease[][] , long FieldID, long FieldAnalysisID){

        FieldAnalysis fieldAnalysis = new FieldAnalysis();
        Date date = new Date();
        SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yy");
        String str = formatter.format(date);
        fieldAnalysis.setDate(str);
        Field field =fieldRepository.findById(FieldID).get();
        fieldAnalysis.setField(field);
        for (int i = 0; i < disease.length; i++) {
            if (disease[i][0].equals("Pepper_Bacterial_spot")) {
                fieldAnalysis.setPepper_Bacterial_spot_percenatge(Integer.parseInt(disease[i][1]));
            } else if (disease[i][0].equals("Strawberry___Leaf_scorch")) {
                fieldAnalysis.setStrawberry_Leaf_scorch_percenatge(Integer.parseInt(disease[i][1]));
            } else if (disease[i][0].equals("Pepper_healthy") || disease[i][0].equals("Strawberry___healthy")) {
                fieldAnalysis.setHeathy_percenatge(Integer.parseInt(disease[i][1]));
            }
        }
        fieldAnalysisRepository.save(fieldAnalysis);
        Set<FieldAnalysis> F=field.getFieldAnalysis();
        F.add(fieldAnalysis);

        return fieldAnalysis.getField_analysis_id();

    }    public void ModifyFieldAnalysis(String disease[][] ,long FieldAnalysisID){

        FieldAnalysis fieldAnalysis = fieldAnalysisRepository.getReferenceById(FieldAnalysisID);
        for (int i = 0; i < disease.length; i++) {
            if (disease[i][0].equals("Pepper_Bacterial_spot")) {
                fieldAnalysis.setPepper_Bacterial_spot_percenatge(Integer.parseInt(disease[i][1])+fieldAnalysis.getPepper_Bacterial_spot_percenatge());
            } else if (disease[i][0].equals("Strawberry___Leaf_scorch")) {
                fieldAnalysis.setStrawberry_Leaf_scorch_percenatge(Integer.parseInt(disease[i][1])+fieldAnalysis.getStrawberry_Leaf_scorch_percenatge());
            } else if (disease[i][0].equals("Pepper_healthy") || disease[i][0].equals("Strawberry___healthy")) {
                fieldAnalysis.setHeathy_percenatge(Integer.parseInt(disease[i][1])+fieldAnalysis.getHeathy_percenatge());
            }
        }
        fieldAnalysisRepository.save(fieldAnalysis);

    }
}
