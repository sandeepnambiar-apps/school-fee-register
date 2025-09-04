package com.school.repository;

import com.school.entity.Student;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface StudentRepository extends JpaRepository<Student, Long> {
    
    List<Student> findBySchool_Id(Long schoolId);
    
    List<Student> findBySchool_IdAndIsActiveTrue(Long schoolId);
    
    List<Student> findByIsActiveTrue();
    
    List<Student> findBySchool_IdAndClassName(Long schoolId, String className);
    
    List<Student> findBySchool_IdAndClassNameAndSection(Long schoolId, String className, String section);
    
    boolean existsByEmailAndSchool_Id(String email, Long schoolId);
    
    boolean existsByRollNumberAndSchool_IdAndClassName(String rollNumber, Long schoolId, String className);
}
