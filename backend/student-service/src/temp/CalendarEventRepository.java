package com.school.studentservice.repository;

import com.school.studentservice.model.CalendarEvent;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface CalendarEventRepository extends JpaRepository<CalendarEvent, Long> {
    
    // Find events by type
    List<CalendarEvent> findByType(CalendarEvent.EventType type);
    
    // Find events within a date range
    @Query("SELECT e FROM CalendarEvent e WHERE " +
           "(e.startDate BETWEEN :startDate AND :endDate) OR " +
           "(e.endDate BETWEEN :startDate AND :endDate) OR " +
           "(e.startDate <= :startDate AND e.endDate >= :endDate)")
    List<CalendarEvent> findEventsInDateRange(@Param("startDate") LocalDate startDate, 
                                             @Param("endDate") LocalDate endDate);
    
    // Find events for a specific month
    @Query("SELECT e FROM CalendarEvent e WHERE " +
           "YEAR(e.startDate) = :year AND MONTH(e.startDate) = :month")
    List<CalendarEvent> findEventsByMonth(@Param("year") int year, @Param("month") int month);
    
    // Find events for a specific date
    @Query("SELECT e FROM CalendarEvent e WHERE " +
           "e.startDate <= :date AND e.endDate >= :date")
    List<CalendarEvent> findEventsByDate(@Param("date") LocalDate date);
    
    // Find recurring events
    List<CalendarEvent> findByIsRecurringTrue();
    
    // Find events by creator
    List<CalendarEvent> findByCreatedBy(Long createdBy);
    
    // Find events by type and date range
    @Query("SELECT e FROM CalendarEvent e WHERE e.type = :type AND " +
           "((e.startDate BETWEEN :startDate AND :endDate) OR " +
           "(e.endDate BETWEEN :startDate AND :endDate) OR " +
           "(e.startDate <= :startDate AND e.endDate >= :endDate))")
    List<CalendarEvent> findEventsByTypeAndDateRange(@Param("type") CalendarEvent.EventType type,
                                                    @Param("startDate") LocalDate startDate,
                                                    @Param("endDate") LocalDate endDate);
} 