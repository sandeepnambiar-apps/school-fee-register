package com.school.studentservice.controller;

import com.school.studentservice.dto.StudentMarksDTO;
import com.school.studentservice.service.StudentMarksService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/students/marks")
@CrossOrigin(origins = "*")
public class StudentMarksController {
    
    @Autowired
    private StudentMarksService studentMarksService;
    
    // Get all marks
    @GetMapping
    public ResponseEntity<List<StudentMarksDTO>> getAllMarks() {
        try {
            List<StudentMarksDTO> marks = studentMarksService.getAllMarks();
            return ResponseEntity.ok(marks);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    // Get marks by ID
    @GetMapping("/{id}")
    public ResponseEntity<StudentMarksDTO> getMarksById(@PathVariable Long id) {
        try {
            StudentMarksDTO marks = studentMarksService.getMarksById(id);
            return ResponseEntity.ok(marks);
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    // Get marks by student ID
    @GetMapping("/student/{studentId}")
    public ResponseEntity<List<StudentMarksDTO>> getMarksByStudentId(@PathVariable Long studentId) {
        try {
            List<StudentMarksDTO> marks = studentMarksService.getMarksByStudentId(studentId);
            return ResponseEntity.ok(marks);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    // Get marks by teacher ID
    @GetMapping("/teacher/{teacherId}")
    public ResponseEntity<List<StudentMarksDTO>> getMarksByTeacherId(@PathVariable Long teacherId) {
        try {
            List<StudentMarksDTO> marks = studentMarksService.getMarksByTeacherId(teacherId);
            return ResponseEntity.ok(marks);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    // Get marks by parent ID (for their children)
    @GetMapping("/parent/{parentId}")
    public ResponseEntity<List<StudentMarksDTO>> getMarksByParentId(@PathVariable Long parentId) {
        try {
            List<StudentMarksDTO> marks = studentMarksService.getMarksByParentId(parentId);
            return ResponseEntity.ok(marks);
        } catch (UnsupportedOperationException e) {
            // Return empty list since parent-student relationship is not properly implemented
            return ResponseEntity.ok(List.of());
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    // Get marks by parent email (for their children)
    @GetMapping("/parent/email/{parentEmail}")
    public ResponseEntity<List<StudentMarksDTO>> getMarksByParentEmail(@PathVariable String parentEmail) {
        try {
            List<StudentMarksDTO> marks = studentMarksService.getMarksByParentEmail(parentEmail);
            return ResponseEntity.ok(marks);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    // Get marks by class ID
    @GetMapping("/class/{classId}")
    public ResponseEntity<List<StudentMarksDTO>> getMarksByClassId(@PathVariable Long classId) {
        try {
            List<StudentMarksDTO> marks = studentMarksService.getMarksByClassId(classId);
            return ResponseEntity.ok(marks);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    // Get marks by subject ID
    @GetMapping("/subject/{subjectId}")
    public ResponseEntity<List<StudentMarksDTO>> getMarksBySubjectId(@PathVariable Long subjectId) {
        try {
            List<StudentMarksDTO> marks = studentMarksService.getMarksBySubjectId(subjectId);
            return ResponseEntity.ok(marks);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    // Get recent marks (last 30 days)
    @GetMapping("/recent")
    public ResponseEntity<List<StudentMarksDTO>> getRecentMarks() {
        try {
            List<StudentMarksDTO> marks = studentMarksService.getRecentMarks();
            return ResponseEntity.ok(marks);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    // Create new marks
    @PostMapping
    public ResponseEntity<StudentMarksDTO> createMarks(@RequestBody StudentMarksDTO marksDTO) {
        try {
            StudentMarksDTO createdMarks = studentMarksService.createMarks(marksDTO);
            return ResponseEntity.ok(createdMarks);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    // Update marks
    @PutMapping("/{id}")
    public ResponseEntity<StudentMarksDTO> updateMarks(@PathVariable Long id, @RequestBody StudentMarksDTO marksDTO) {
        try {
            StudentMarksDTO updatedMarks = studentMarksService.updateMarks(id, marksDTO);
            return ResponseEntity.ok(updatedMarks);
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    // Delete marks
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteMarks(@PathVariable Long id) {
        try {
            studentMarksService.deleteMarks(id);
            return ResponseEntity.ok().build();
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    // Delete marks by teacher (for authorization)
    @DeleteMapping("/{id}/teacher")
    public ResponseEntity<Void> deleteMarksByTeacher(@PathVariable Long id, @RequestParam Long teacherId) {
        try {
            studentMarksService.deleteMarksByTeacher(id, teacherId);
            return ResponseEntity.ok().build();
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().build();
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
} 