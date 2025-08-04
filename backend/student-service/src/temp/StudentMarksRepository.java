package com.school.studentservice.repository;

import com.school.studentservice.model.StudentMarks;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface StudentMarksRepository extends JpaRepository<StudentMarks, Long> {
    
    // Find marks by student ID
    List<StudentMarks> findByStudentId(Long studentId);
    
    // Find marks by teacher ID
    List<StudentMarks> findByTeacherId(Long teacherId);
    
    // Find marks by class ID
    List<StudentMarks> findByClassId(Long classId);
    
    // Find marks by subject ID
    List<StudentMarks> findBySubjectId(Long subjectId);
    
    // Find marks by student and subject
    List<StudentMarks> findByStudentIdAndSubjectId(Long studentId, Long subjectId);
    
    // Find marks by student and class
    List<StudentMarks> findByStudentIdAndClassId(Long studentId, Long classId);
    
    // Find marks by teacher and class
    List<StudentMarks> findByTeacherIdAndClassId(Long teacherId, Long classId);
    
    // Find marks by exam type
    List<StudentMarks> findByExamType(StudentMarks.ExamType examType);
    
    // Find marks by student, subject, and exam type
    List<StudentMarks> findByStudentIdAndSubjectIdAndExamType(Long studentId, Long subjectId, StudentMarks.ExamType examType);
    
    // Custom query to find marks for students of a specific parent
    // Note: This is a placeholder since Student entity doesn't have parentId
    // You may need to implement this based on your parent-student relationship
    @Query("SELECT sm FROM StudentMarks sm, Student s " +
           "WHERE sm.studentId = s.id AND s.parentEmail = :parentEmail")
    List<StudentMarks> findByParentEmail(@Param("parentEmail") String parentEmail);
    
    // Custom query to find marks with student, subject, and class details
    @Query("SELECT sm FROM StudentMarks sm, Student s, Subject sub, Class c " +
           "WHERE sm.studentId = s.id AND sm.subjectId = sub.id AND sm.classId = c.id AND sm.studentId = :studentId")
    List<StudentMarks> findMarksWithDetailsByStudentId(@Param("studentId") Long studentId);
    
    // Custom query to find marks for a teacher's students
    @Query("SELECT sm FROM StudentMarks sm, Student s " +
           "WHERE sm.studentId = s.id AND sm.teacherId = :teacherId")
    List<StudentMarks> findMarksByTeacherId(@Param("teacherId") Long teacherId);
    
    // Custom query to find recent marks (last 30 days)
    @Query("SELECT sm FROM StudentMarks sm " +
           "WHERE sm.examDate >= :startDate")
    List<StudentMarks> findRecentMarks(@Param("startDate") String startDate);
    
    // Custom query to find marks by date range
    @Query("SELECT sm FROM StudentMarks sm " +
           "WHERE sm.examDate BETWEEN :startDate AND :endDate")
    List<StudentMarks> findMarksByDateRange(@Param("startDate") String startDate, @Param("endDate") String endDate);
} 