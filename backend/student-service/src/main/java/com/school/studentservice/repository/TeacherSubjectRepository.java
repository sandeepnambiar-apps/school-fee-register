package com.school.studentservice.repository;

import com.school.studentservice.model.TeacherSubject;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TeacherSubjectRepository extends JpaRepository<TeacherSubject, Long> {
    
    List<TeacherSubject> findByTeacherIdAndIsActiveTrue(Long teacherId);
    
    List<TeacherSubject> findBySubjectIdAndIsActiveTrue(Long subjectId);
    
    List<TeacherSubject> findByClassIdAndIsActiveTrue(Long classId);
    
    List<TeacherSubject> findByClassIdAndSectionAndIsActiveTrue(Long classId, String section);
    
    List<TeacherSubject> findByTeacherIdAndClassIdAndIsActiveTrue(Long teacherId, Long classId);
    
    List<TeacherSubject> findByTeacherIdAndSubjectIdAndIsActiveTrue(Long teacherId, Long subjectId);
    
    @Query("SELECT ts FROM TeacherSubject ts WHERE ts.teacherId = :teacherId AND ts.classId = :classId AND ts.section = :section AND ts.isActive = true")
    List<TeacherSubject> findByTeacherIdAndClassIdAndSectionAndIsActiveTrue(
            @Param("teacherId") Long teacherId, 
            @Param("classId") Long classId, 
            @Param("section") String section);
    
    @Query("SELECT ts FROM TeacherSubject ts WHERE ts.teacherId = :teacherId AND ts.subjectId = :subjectId AND ts.classId = :classId AND ts.section = :section AND ts.isActive = true")
    List<TeacherSubject> findByTeacherIdAndSubjectIdAndClassIdAndSectionAndIsActiveTrue(
            @Param("teacherId") Long teacherId, 
            @Param("subjectId") Long subjectId, 
            @Param("classId") Long classId, 
            @Param("section") String section);
    
    List<TeacherSubject> findByAcademicYearIdAndIsActiveTrue(Long academicYearId);
    
    @Query("SELECT ts FROM TeacherSubject ts WHERE ts.teacherId = :teacherId AND ts.academicYearId = :academicYearId AND ts.isActive = true")
    List<TeacherSubject> findByTeacherIdAndAcademicYearIdAndIsActiveTrue(
            @Param("teacherId") Long teacherId, 
            @Param("academicYearId") Long academicYearId);
} 