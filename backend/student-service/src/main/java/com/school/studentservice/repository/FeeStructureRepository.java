package com.school.studentservice.repository;

import com.school.studentservice.model.FeeStructure;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface FeeStructureRepository extends JpaRepository<FeeStructure, Long> {
    
    // Dashboard methods
    long countByIsActive(Boolean isActive);
} 