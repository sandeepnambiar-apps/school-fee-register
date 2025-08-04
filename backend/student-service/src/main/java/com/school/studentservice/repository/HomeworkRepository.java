package com.school.studentservice.repository;

import com.school.studentservice.model.Homework;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface HomeworkRepository extends JpaRepository<Homework, Long> {
    
    // Find by teacher
    List<Homework> findByTeacherIdOrderByCreatedAtDesc(Long teacherId);
    
    // Find by subject
    List<Homework> findBySubjectIdOrderByCreatedAtDesc(Long subjectId);
    
    // Find by class
    List<Homework> findByClassIdOrderByCreatedAtDesc(Long classId);
    
    // Find by class and section
    List<Homework> findByClassIdAndSectionOrderByCreatedAtDesc(Long classId, String section);
    
    // Find by subject and class
    List<Homework> findBySubjectIdAndClassIdOrderByCreatedAtDesc(Long subjectId, Long classId);
    
    // Find by subject, class and section
    List<Homework> findBySubjectIdAndClassIdAndSectionOrderByCreatedAtDesc(Long subjectId, Long classId, String section);
    
    // Find by teacher and subject
    List<Homework> findByTeacherIdAndSubjectIdOrderByCreatedAtDesc(Long teacherId, Long subjectId);
    
    // Find by teacher and class
    List<Homework> findByTeacherIdAndClassIdOrderByCreatedAtDesc(Long teacherId, Long classId);
    
    // Find by teacher, class and section
    List<Homework> findByTeacherIdAndClassIdAndSectionOrderByCreatedAtDesc(Long teacherId, Long classId, String section);
    
    // Find by status
    List<Homework> findByStatusOrderByCreatedAtDesc(Homework.Status status);
    
    // Find by priority
    List<Homework> findByPriorityOrderByCreatedAtDesc(Homework.Priority priority);
    
    // Find by due date range
    List<Homework> findByDueDateBetweenOrderByDueDateAsc(LocalDate startDate, LocalDate endDate);
    
    // Find by assigned date range
    List<Homework> findByAssignedDateBetweenOrderByAssignedDateDesc(LocalDate startDate, LocalDate endDate);
    
    // Find overdue homework
    @Query("SELECT h FROM Homework h WHERE h.dueDate < :today AND h.status = 'ACTIVE' ORDER BY h.dueDate ASC")
    List<Homework> findOverdueHomework(@Param("today") LocalDate today);
    
    // Find upcoming homework (due in next 7 days)
    @Query("SELECT h FROM Homework h WHERE h.dueDate BETWEEN :today AND :nextWeek AND h.status = 'ACTIVE' ORDER BY h.dueDate ASC")
    List<Homework> findUpcomingHomework(@Param("today") LocalDate today, @Param("nextWeek") LocalDate nextWeek);
    
    // Find by academic year
    List<Homework> findByAcademicYearIdOrderByCreatedAtDesc(Long academicYearId);
    
    // Find by teacher and academic year
    List<Homework> findByTeacherIdAndAcademicYearIdOrderByCreatedAtDesc(Long teacherId, Long academicYearId);
    
    // Find by class and academic year
    List<Homework> findByClassIdAndAcademicYearIdOrderByCreatedAtDesc(Long classId, Long academicYearId);
    
    // Find by subject, class, section and academic year
    List<Homework> findBySubjectIdAndClassIdAndSectionAndAcademicYearIdOrderByCreatedAtDesc(
            Long subjectId, Long classId, String section, Long academicYearId);
    
    // Find active homework for a specific class and section
    List<Homework> findByClassIdAndSectionAndStatusOrderByCreatedAtDesc(Long classId, String section, Homework.Status status);
    
    // Find active homework for a specific subject, class and section
    List<Homework> findBySubjectIdAndClassIdAndSectionAndStatusOrderByCreatedAtDesc(
            Long subjectId, Long classId, String section, Homework.Status status);
    
    // Count homework by teacher
    @Query("SELECT COUNT(h) FROM Homework h WHERE h.teacherId = :teacherId")
    Long countByTeacherId(@Param("teacherId") Long teacherId);
    
    // Count homework by class
    @Query("SELECT COUNT(h) FROM Homework h WHERE h.classId = :classId")
    Long countByClassId(@Param("classId") Long classId);
    
    // Count homework by subject
    @Query("SELECT COUNT(h) FROM Homework h WHERE h.subjectId = :subjectId")
    Long countBySubjectId(@Param("subjectId") Long subjectId);
    
    // Count active homework by teacher
    @Query("SELECT COUNT(h) FROM Homework h WHERE h.teacherId = :teacherId AND h.status = 'ACTIVE'")
    Long countActiveByTeacherId(@Param("teacherId") Long teacherId);
    
    // Find by teacher and status
    List<Homework> findByTeacherIdAndStatusOrderByCreatedAtDesc(Long teacherId, Homework.Status status);
} 