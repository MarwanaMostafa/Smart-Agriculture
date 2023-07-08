package com.gp.plantgardbackend.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.gp.plantgardbackend.appuser.AppUser;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

import javax.persistence.*;

@Entity
@Table(name = "field_analysis")
public class FieldAnalysis {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "field_generator")
    private long field_analysis_id;

    public long getField_analysis_id() {
        return field_analysis_id;
    }

    public void setField_analysis_id(long field_analysis_id) {
        this.field_analysis_id = field_analysis_id;
    }

    public String getDate() {
        return Date;
    }

    public void setDate(String date) {
        Date = date;
    }

    public int getTotal_disiese_percenatge() {
        return total_disiese_percenatge;
    }

    public void setTotal_disiese_percenatge(int total_disiese_percenatge) {
        this.total_disiese_percenatge = total_disiese_percenatge;
    }

    public int getPepper_Bacterial_spot_percenatge() {
        return Pepper_Bacterial_spot_percenatge;
    }

    public void setPepper_Bacterial_spot_percenatge(int pepper_Bacterial_spot_percenatge) {
        Pepper_Bacterial_spot_percenatge = pepper_Bacterial_spot_percenatge;
    }

    public int getStrawberry_Leaf_scorch_percenatge() {
        return Strawberry_Leaf_scorch_percenatge;
    }

    public void setStrawberry_Leaf_scorch_percenatge(int strawberry_Leaf_scorch_percenatge) {
        Strawberry_Leaf_scorch_percenatge = strawberry_Leaf_scorch_percenatge;
    }

    public Field getField() {
        return field;
    }

    public void setField(Field field) {
        this.field = field;
    }

    @Column(name = "date")
    private String Date;
    @Column(name = "total_disiese_percenatge ")
    private int total_disiese_percenatge ;
    @Column(name = "heathy_percenatge")
    private int heathy_percenatge ;

    public int getHeathy_percenatge() {
        return heathy_percenatge;
    }

    public void setHeathy_percenatge(int heathy_percenatge) {
        this.heathy_percenatge = heathy_percenatge;
    }

    @Column(name = "Pepper_Bacterial_spot_percenatge")
    private int Pepper_Bacterial_spot_percenatge ;
    @Column(name = "Strawberry_Leaf_scorch_percenatge")
    private int Strawberry_Leaf_scorch_percenatge ;
    @ManyToOne(fetch = FetchType.EAGER, optional = false)
    @JoinColumn(name = "filed_id", nullable = false)
    @OnDelete(action = OnDeleteAction.CASCADE)
    @JsonIgnore
    private Field field;
}
