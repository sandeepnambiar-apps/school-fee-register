package com.school.studentservice.repository;

import com.school.studentservice.model.Subject;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface SubjectRepository extends JpaRepository<Subject, Long> {
    
    List<Subject> findByIsActiveTrue();
    
    Optional<Subject> findByCode(String code);
    
    Optional<Subject> findByName(String name);
    
    List<Subject> findByNameContainingIgnoreCase(String name);
    
    boolean existsByCode(String code);
    
    boolean existsByName(String name);
} 