package com.gp.plantgardbackend.dao;

import com.gp.plantgardbackend.model.Field;
import com.gp.plantgardbackend.model.FieldAnalysis;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface FieldAnalysisRepository extends JpaRepository<FieldAnalysis, Long>{
}
