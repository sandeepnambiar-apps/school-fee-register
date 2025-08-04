package com.school.studentservice.service;

import com.school.studentservice.dto.CalendarEventDTO;
import com.school.studentservice.model.CalendarEvent;
import com.school.studentservice.repository.CalendarEventRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class CalendarService {
    
    @Autowired
    private CalendarEventRepository calendarEventRepository;
    
    // Get all events
    public List<CalendarEventDTO> getAllEvents() {
        return calendarEventRepository.findAll()
                .stream()
                .map(CalendarEventDTO::new)
                .collect(Collectors.toList());
    }
    
    // Get all holidays
    public List<CalendarEventDTO> getAllHolidays() {
        return calendarEventRepository.findByType(CalendarEvent.EventType.HOLIDAY)
                .stream()
                .map(CalendarEventDTO::new)
                .collect(Collectors.toList());
    }
    
    // Get all events (non-holidays)
    public List<CalendarEventDTO> getAllEventsOnly() {
        return calendarEventRepository.findByType(CalendarEvent.EventType.EVENT)
                .stream()
                .map(CalendarEventDTO::new)
                .collect(Collectors.toList());
    }
    
    // Get events by date range
    public List<CalendarEventDTO> getEventsByDateRange(LocalDate startDate, LocalDate endDate) {
        return calendarEventRepository.findEventsInDateRange(startDate, endDate)
                .stream()
                .map(CalendarEventDTO::new)
                .collect(Collectors.toList());
    }
    
    // Get events by month
    public List<CalendarEventDTO> getEventsByMonth(int year, int month) {
        return calendarEventRepository.findEventsByMonth(year, month)
                .stream()
                .map(CalendarEventDTO::new)
                .collect(Collectors.toList());
    }
    
    // Get events by specific date
    public List<CalendarEventDTO> getEventsByDate(LocalDate date) {
        return calendarEventRepository.findEventsByDate(date)
                .stream()
                .map(CalendarEventDTO::new)
                .collect(Collectors.toList());
    }
    
    // Get events by type and date range
    public List<CalendarEventDTO> getEventsByTypeAndDateRange(CalendarEvent.EventType type, 
                                                             LocalDate startDate, 
                                                             LocalDate endDate) {
        return calendarEventRepository.findEventsByTypeAndDateRange(type, startDate, endDate)
                .stream()
                .map(CalendarEventDTO::new)
                .collect(Collectors.toList());
    }
    
    // Create new event
    public CalendarEventDTO createEvent(CalendarEventDTO eventDTO) {
        CalendarEvent event = eventDTO.toEntity();
        CalendarEvent savedEvent = calendarEventRepository.save(event);
        return new CalendarEventDTO(savedEvent);
    }
    
    // Update event
    public CalendarEventDTO updateEvent(Long eventId, CalendarEventDTO eventDTO) {
        CalendarEvent existingEvent = calendarEventRepository.findById(eventId)
                .orElseThrow(() -> new RuntimeException("Event not found"));
        
        existingEvent.setTitle(eventDTO.getTitle());
        existingEvent.setDescription(eventDTO.getDescription());
        existingEvent.setStartDate(eventDTO.getStartDate());
        existingEvent.setEndDate(eventDTO.getEndDate());
        existingEvent.setType(eventDTO.getType());
        existingEvent.setColor(eventDTO.getColor());
        existingEvent.setIsRecurring(eventDTO.getIsRecurring());
        existingEvent.setRecurringType(eventDTO.getRecurringType());
        existingEvent.setUpdatedBy(eventDTO.getUpdatedBy());
        
        CalendarEvent updatedEvent = calendarEventRepository.save(existingEvent);
        return new CalendarEventDTO(updatedEvent);
    }
    
    // Delete event
    public void deleteEvent(Long eventId) {
        if (!calendarEventRepository.existsById(eventId)) {
            throw new RuntimeException("Event not found");
        }
        calendarEventRepository.deleteById(eventId);
    }
    
    // Get event by ID
    public CalendarEventDTO getEventById(Long eventId) {
        CalendarEvent event = calendarEventRepository.findById(eventId)
                .orElseThrow(() -> new RuntimeException("Event not found"));
        return new CalendarEventDTO(event);
    }
    
    // Get events by creator
    public List<CalendarEventDTO> getEventsByCreator(Long createdBy) {
        return calendarEventRepository.findByCreatedBy(createdBy)
                .stream()
                .map(CalendarEventDTO::new)
                .collect(Collectors.toList());
    }
    
    // Get recurring events
    public List<CalendarEventDTO> getRecurringEvents() {
        return calendarEventRepository.findByIsRecurringTrue()
                .stream()
                .map(CalendarEventDTO::new)
                .collect(Collectors.toList());
    }
} 