package com.school.repository;

import com.school.entity.School;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface SchoolRepository extends JpaRepository<School, Long> {
    
    Optional<School> findByName(String name);
    
    List<School> findByIsActiveTrue();
    
    boolean existsByName(String name);
}


