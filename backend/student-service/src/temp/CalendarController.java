package com.school.studentservice.controller;

import com.school.studentservice.dto.CalendarEventDTO;
import com.school.studentservice.model.CalendarEvent;
import com.school.studentservice.service.CalendarService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/api/calendar")
@CrossOrigin(origins = "*")
public class CalendarController {
    
    @Autowired
    private CalendarService calendarService;
    
    // Get all events
    @GetMapping("/events")
    public ResponseEntity<List<CalendarEventDTO>> getAllEvents() {
        try {
            List<CalendarEventDTO> events = calendarService.getAllEvents();
            return ResponseEntity.ok(events);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    // Get all holidays
    @GetMapping("/holidays")
    public ResponseEntity<List<CalendarEventDTO>> getAllHolidays() {
        try {
            List<CalendarEventDTO> holidays = calendarService.getAllHolidays();
            return ResponseEntity.ok(holidays);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    // Get events by date range
    @GetMapping("/events/range")
    public ResponseEntity<List<CalendarEventDTO>> getEventsByDateRange(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate) {
        try {
            List<CalendarEventDTO> events = calendarService.getEventsByDateRange(startDate, endDate);
            return ResponseEntity.ok(events);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    // Get events by month
    @GetMapping("/events/month")
    public ResponseEntity<List<CalendarEventDTO>> getEventsByMonth(
            @RequestParam int year,
            @RequestParam int month) {
        try {
            List<CalendarEventDTO> events = calendarService.getEventsByMonth(year, month);
            return ResponseEntity.ok(events);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    // Get events by specific date
    @GetMapping("/events/date")
    public ResponseEntity<List<CalendarEventDTO>> getEventsByDate(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date) {
        try {
            List<CalendarEventDTO> events = calendarService.getEventsByDate(date);
            return ResponseEntity.ok(events);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    // Get events by type and date range
    @GetMapping("/events/type-range")
    public ResponseEntity<List<CalendarEventDTO>> getEventsByTypeAndDateRange(
            @RequestParam CalendarEvent.EventType type,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate) {
        try {
            List<CalendarEventDTO> events = calendarService.getEventsByTypeAndDateRange(type, startDate, endDate);
            return ResponseEntity.ok(events);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    // Get event by ID
    @GetMapping("/events/{eventId}")
    public ResponseEntity<CalendarEventDTO> getEventById(@PathVariable Long eventId) {
        try {
            CalendarEventDTO event = calendarService.getEventById(eventId);
            return ResponseEntity.ok(event);
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    // Create new event
    @PostMapping("/events")
    public ResponseEntity<CalendarEventDTO> createEvent(@RequestBody CalendarEventDTO eventDTO) {
        try {
            CalendarEventDTO createdEvent = calendarService.createEvent(eventDTO);
            return ResponseEntity.ok(createdEvent);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    // Update event
    @PutMapping("/events/{eventId}")
    public ResponseEntity<CalendarEventDTO> updateEvent(
            @PathVariable Long eventId,
            @RequestBody CalendarEventDTO eventDTO) {
        try {
            CalendarEventDTO updatedEvent = calendarService.updateEvent(eventId, eventDTO);
            return ResponseEntity.ok(updatedEvent);
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    // Delete event
    @DeleteMapping("/events/{eventId}")
    public ResponseEntity<Void> deleteEvent(@PathVariable Long eventId) {
        try {
            calendarService.deleteEvent(eventId);
            return ResponseEntity.ok().build();
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    // Get events by creator
    @GetMapping("/events/creator/{createdBy}")
    public ResponseEntity<List<CalendarEventDTO>> getEventsByCreator(@PathVariable Long createdBy) {
        try {
            List<CalendarEventDTO> events = calendarService.getEventsByCreator(createdBy);
            return ResponseEntity.ok(events);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    // Get recurring events
    @GetMapping("/events/recurring")
    public ResponseEntity<List<CalendarEventDTO>> getRecurringEvents() {
        try {
            List<CalendarEventDTO> events = calendarService.getRecurringEvents();
            return ResponseEntity.ok(events);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    // Health check endpoint
    @GetMapping("/health")
    public ResponseEntity<String> health() {
        return ResponseEntity.ok("Calendar service is running");
    }
} 