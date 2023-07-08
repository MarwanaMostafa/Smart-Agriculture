package com.gp.plantgardbackend.dao;

import com.gp.plantgardbackend.model.Field;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface FieldRepository extends JpaRepository<Field, Long> {

}