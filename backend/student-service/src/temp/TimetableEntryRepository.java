package com.school.studentservice.repository;

import com.school.studentservice.model.TimetableEntry;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TimetableEntryRepository extends JpaRepository<TimetableEntry, Long> {
    
    // Find entries by day of week
    List<TimetableEntry> findByDayOfWeek(TimetableEntry.DayOfWeek dayOfWeek);
    
    // Find entries by class and section
    List<TimetableEntry> findByClassIdAndSection(Long classId, String section);
    
    // Find entries by class, section and day
    List<TimetableEntry> findByClassIdAndSectionAndDayOfWeek(Long classId, String section, TimetableEntry.DayOfWeek dayOfWeek);
    
    // Find entries by teacher
    List<TimetableEntry> findByTeacherId(Long teacherId);
    
    // Find entries by teacher and day
    List<TimetableEntry> findByTeacherIdAndDayOfWeek(Long teacherId, TimetableEntry.DayOfWeek dayOfWeek);
    
    // Find entries by subject
    List<TimetableEntry> findBySubjectId(Long subjectId);
    
    // Find entries by period number
    List<TimetableEntry> findByPeriodNumber(Integer periodNumber);
    
    // Find entries by class, section, day and period
    @Query("SELECT t FROM TimetableEntry t WHERE t.classId = :classId AND t.section = :section AND t.dayOfWeek = :dayOfWeek AND t.periodNumber = :periodNumber")
    TimetableEntry findByClassSectionDayPeriod(@Param("classId") Long classId, 
                                              @Param("section") String section, 
                                              @Param("dayOfWeek") TimetableEntry.DayOfWeek dayOfWeek, 
                                              @Param("periodNumber") Integer periodNumber);
    
    // Find entries by teacher, day and period
    @Query("SELECT t FROM TimetableEntry t WHERE t.teacherId = :teacherId AND t.dayOfWeek = :dayOfWeek AND t.periodNumber = :periodNumber")
    TimetableEntry findByTeacherDayPeriod(@Param("teacherId") Long teacherId, 
                                         @Param("dayOfWeek") TimetableEntry.DayOfWeek dayOfWeek, 
                                         @Param("periodNumber") Integer periodNumber);
    
    // Find entries by creator
    List<TimetableEntry> findByCreatedBy(Long createdBy);
    
    // Find all entries ordered by day and period
    @Query("SELECT t FROM TimetableEntry t ORDER BY t.dayOfWeek, t.periodNumber")
    List<TimetableEntry> findAllOrderedByDayAndPeriod();
    
    // Find entries by class and section ordered by day and period
    @Query("SELECT t FROM TimetableEntry t WHERE t.classId = :classId AND t.section = :section ORDER BY t.dayOfWeek, t.periodNumber")
    List<TimetableEntry> findByClassAndSectionOrdered(@Param("classId") Long classId, @Param("section") String section);
    
    // Find entries by teacher ordered by day and period
    @Query("SELECT t FROM TimetableEntry t WHERE t.teacherId = :teacherId ORDER BY t.dayOfWeek, t.periodNumber")
    List<TimetableEntry> findByTeacherOrdered(@Param("teacherId") Long teacherId);
} 