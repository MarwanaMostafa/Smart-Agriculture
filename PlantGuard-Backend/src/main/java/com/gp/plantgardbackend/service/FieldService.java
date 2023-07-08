package com.gp.plantgardbackend.service;

import com.gp.plantgardbackend.appuser.AppUser;
import com.gp.plantgardbackend.appuser.AppUserService;
import com.gp.plantgardbackend.dao.FieldRepository;
import com.gp.plantgardbackend.dto.FieldDTO;
import com.gp.plantgardbackend.model.Field;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

@Service
public class FieldService {
@Autowired
FieldRepository fieldRepository;
private final AppUserService appUserService;

    public FieldService(AppUserService appUserService) {
        this.appUserService = appUserService;
    }

    public void addField(FieldDTO fieldDTO){
    Field field=new Field();
    field.setPlant(fieldDTO.getPlantDTO());
    field.setSize(fieldDTO.getSizeDTO());
    field.setAddress(fieldDTO.getAddressDTO());
    field.setAppUser(appUserService.getLogedInUser());
    fieldRepository.save(field);
       Set<Field> f= appUserService.getLogedInUser().getFields();
       f.add(field);
       appUserService.getLogedInUser().setFields(f);
}
public List<Field>  getFields(){

    List<Field> l=fieldRepository.findAll();
    List<Field> l1=new ArrayList<>();

    for (int i = 0; i < l.size(); i++) {
        long id1=appUserService.getLogedInUser().getId();
        long id2=l.get(i).getAppUser().getId();
        if(l.get(i).getAppUser().getId()==appUserService.getLogedInUser().getId()){
         l1.add(l.get(i));
        }
    }
    return l1;
}

}
