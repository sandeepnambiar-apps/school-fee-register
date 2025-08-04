package com.school.studentservice.repository;

import com.school.studentservice.model.Class;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ClassRepository extends JpaRepository<Class, Long> {
    
    List<Class> findByIsActiveTrue();
    
    Optional<Class> findByIdAndIsActiveTrue(Long id);
    
    List<Class> findByGradeLevel(Integer gradeLevel);
} 