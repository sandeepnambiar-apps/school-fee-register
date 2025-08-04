package com.school.studentservice.controller;

import com.school.studentservice.dto.TimetableEntryDTO;
import com.school.studentservice.model.TimetableEntry;
import com.school.studentservice.service.TimetableService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/timetable")
@CrossOrigin(origins = "*")
public class TimetableController {
    
    @Autowired
    private TimetableService timetableService;
    
    // Get all timetable entries
    @GetMapping
    public ResponseEntity<List<TimetableEntryDTO>> getAllTimetableEntries() {
        try {
            List<TimetableEntryDTO> entries = timetableService.getAllTimetableEntries();
            return ResponseEntity.ok(entries);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    // Get timetable by class and section
    @GetMapping("/class/{classId}/section/{section}")
    public ResponseEntity<List<TimetableEntryDTO>> getTimetableByClassAndSection(
            @PathVariable Long classId,
            @PathVariable String section) {
        try {
            List<TimetableEntryDTO> entries = timetableService.getTimetableByClassAndSection(classId, section);
            return ResponseEntity.ok(entries);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    // Get timetable by teacher
    @GetMapping("/teacher/{teacherId}")
    public ResponseEntity<List<TimetableEntryDTO>> getTimetableByTeacher(@PathVariable Long teacherId) {
        try {
            List<TimetableEntryDTO> entries = timetableService.getTimetableByTeacher(teacherId);
            return ResponseEntity.ok(entries);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    // Get timetable by day
    @GetMapping("/day/{dayOfWeek}")
    public ResponseEntity<List<TimetableEntryDTO>> getTimetableByDay(
            @PathVariable TimetableEntry.DayOfWeek dayOfWeek) {
        try {
            List<TimetableEntryDTO> entries = timetableService.getTimetableByDay(dayOfWeek);
            return ResponseEntity.ok(entries);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    // Get timetable by class, section and day
    @GetMapping("/class/{classId}/section/{section}/day/{dayOfWeek}")
    public ResponseEntity<List<TimetableEntryDTO>> getTimetableByClassSectionAndDay(
            @PathVariable Long classId,
            @PathVariable String section,
            @PathVariable TimetableEntry.DayOfWeek dayOfWeek) {
        try {
            List<TimetableEntryDTO> entries = timetableService.getTimetableByClassSectionAndDay(classId, section, dayOfWeek);
            return ResponseEntity.ok(entries);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    // Get timetable by teacher and day
    @GetMapping("/teacher/{teacherId}/day/{dayOfWeek}")
    public ResponseEntity<List<TimetableEntryDTO>> getTimetableByTeacherAndDay(
            @PathVariable Long teacherId,
            @PathVariable TimetableEntry.DayOfWeek dayOfWeek) {
        try {
            List<TimetableEntryDTO> entries = timetableService.getTimetableByTeacherAndDay(teacherId, dayOfWeek);
            return ResponseEntity.ok(entries);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    // Get timetable by subject
    @GetMapping("/subject/{subjectId}")
    public ResponseEntity<List<TimetableEntryDTO>> getTimetableBySubject(@PathVariable Long subjectId) {
        try {
            List<TimetableEntryDTO> entries = timetableService.getTimetableBySubject(subjectId);
            return ResponseEntity.ok(entries);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    // Get timetable by period
    @GetMapping("/period/{periodNumber}")
    public ResponseEntity<List<TimetableEntryDTO>> getTimetableByPeriod(@PathVariable Integer periodNumber) {
        try {
            List<TimetableEntryDTO> entries = timetableService.getTimetableByPeriod(periodNumber);
            return ResponseEntity.ok(entries);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    // Get timetable entry by ID
    @GetMapping("/{entryId}")
    public ResponseEntity<TimetableEntryDTO> getTimetableEntryById(@PathVariable Long entryId) {
        try {
            TimetableEntryDTO entry = timetableService.getTimetableEntryById(entryId);
            return ResponseEntity.ok(entry);
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    // Create new timetable entry
    @PostMapping
    public ResponseEntity<?> createTimetableEntry(@RequestBody TimetableEntryDTO entryDTO) {
        try {
            TimetableEntryDTO createdEntry = timetableService.createTimetableEntry(entryDTO);
            return ResponseEntity.ok(createdEntry);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    // Update timetable entry
    @PutMapping("/{entryId}")
    public ResponseEntity<?> updateTimetableEntry(
            @PathVariable Long entryId,
            @RequestBody TimetableEntryDTO entryDTO) {
        try {
            TimetableEntryDTO updatedEntry = timetableService.updateTimetableEntry(entryId, entryDTO);
            return ResponseEntity.ok(updatedEntry);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    // Delete timetable entry
    @DeleteMapping("/{entryId}")
    public ResponseEntity<Void> deleteTimetableEntry(@PathVariable Long entryId) {
        try {
            timetableService.deleteTimetableEntry(entryId);
            return ResponseEntity.ok().build();
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    // Get timetable entries by creator
    @GetMapping("/creator/{createdBy}")
    public ResponseEntity<List<TimetableEntryDTO>> getTimetableEntriesByCreator(@PathVariable Long createdBy) {
        try {
            List<TimetableEntryDTO> entries = timetableService.getTimetableEntriesByCreator(createdBy);
            return ResponseEntity.ok(entries);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    // Check for conflicts
    @GetMapping("/check-conflict")
    public ResponseEntity<Boolean> checkConflict(
            @RequestParam Long classId,
            @RequestParam String section,
            @RequestParam TimetableEntry.DayOfWeek dayOfWeek,
            @RequestParam Integer periodNumber,
            @RequestParam(required = false) Long excludeEntryId) {
        try {
            boolean hasConflict = timetableService.hasConflict(classId, section, dayOfWeek, periodNumber, excludeEntryId);
            return ResponseEntity.ok(hasConflict);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    // Check for teacher conflicts
    @GetMapping("/check-teacher-conflict")
    public ResponseEntity<Boolean> checkTeacherConflict(
            @RequestParam Long teacherId,
            @RequestParam TimetableEntry.DayOfWeek dayOfWeek,
            @RequestParam Integer periodNumber,
            @RequestParam(required = false) Long excludeEntryId) {
        try {
            boolean hasConflict = timetableService.hasTeacherConflict(teacherId, dayOfWeek, periodNumber, excludeEntryId);
            return ResponseEntity.ok(hasConflict);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    // Health check endpoint
    @GetMapping("/health")
    public ResponseEntity<String> health() {
        return ResponseEntity.ok("Timetable service is running");
    }
} 