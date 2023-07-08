package com.gp.plantgardbackend.dto;
import com.gp.plantgardbackend.model.FieldsPlants;


public class FieldDTO {

    private FieldsPlants plantDTO;
    private long sizeDTO;

    private String addressDTO;

    public FieldsPlants getPlantDTO() {
        return plantDTO;
    }

    public long getSizeDTO() {
        return sizeDTO;
    }

    public String getAddressDTO() {
        return addressDTO;
    }

}
