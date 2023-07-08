package com.gp.plantgardbackend.model;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.gp.plantgardbackend.appuser.AppUser;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

import javax.persistence.*;
import java.util.Set;

@Entity
@Table(name = "field")
public class Field {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "field_generator")
    private long field_id;

    public long getField_id() {
        return field_id;
    }

    public AppUser getAppUser() {
        return appUser;
    }

    @Column(name = "plant")
    private FieldsPlants plant;
    @Column(name = "size")
    private long size;
    @Column(name = "address")
    private String address;

    public Field() {
    }
    public FieldsPlants getPlant() {
        return plant;
    }

    public void setPlant(FieldsPlants plant) {
        this.plant = plant;
    }

    public long getSize() {
        return size;
    }

    public void setSize(long size) {
        this.size = size;
    }

    public String getAddress() {
        return address;
    }

    public Set<FieldAnalysis> getFieldAnalysis() {
        return fieldAnalysis;
    }

    public void setFieldAnalysis(Set<FieldAnalysis> fieldAnalysis) {
        this.fieldAnalysis = fieldAnalysis;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public void setAppUser(AppUser appUser) {
        this.appUser = appUser;
    }

    @ManyToOne( optional = false)
    @JoinColumn(name = "user_id", nullable = false)
    @OnDelete(action = OnDeleteAction.CASCADE)
    private AppUser appUser;

    @OneToMany(mappedBy = "field",
            cascade = CascadeType.ALL)
    private Set<FieldAnalysis> fieldAnalysis;
}
