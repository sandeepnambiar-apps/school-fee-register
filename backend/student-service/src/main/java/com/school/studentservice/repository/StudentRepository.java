package com.school.studentservice.repository;

import com.school.studentservice.model.Student;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface StudentRepository extends JpaRepository<Student, Long> {
    
    Optional<Student> findByStudentId(String studentId);
    
    List<Student> findByClassId(Long classId);
    
    List<Student> findByAcademicYearId(Long academicYearId);
    
    List<Student> findByIsActive(Boolean isActive);
    
    @Query("SELECT s FROM Student s WHERE s.firstName LIKE %:name% OR s.lastName LIKE %:name%")
    List<Student> findByNameContaining(@Param("name") String name);
    
    @Query("SELECT s FROM Student s WHERE s.classId = :classId AND s.academicYearId = :academicYearId")
    List<Student> findByClassIdAndAcademicYearId(@Param("classId") Long classId, 
                                                @Param("academicYearId") Long academicYearId);
    
    @Query("SELECT s FROM Student s WHERE s.parentEmail = :parentEmail")
    List<Student> findByParentEmail(@Param("parentEmail") String parentEmail);
    
    @Query("SELECT s FROM Student s WHERE s.parentPhone = :parentPhone")
    List<Student> findByParentPhone(@Param("parentPhone") String parentPhone);
    
    boolean existsByStudentId(String studentId);
    
    boolean existsByEmail(String email);
    
    // Dashboard methods
    long countByIsActive(Boolean isActive);
    
    long countByParentPhone(String parentPhone);
} 