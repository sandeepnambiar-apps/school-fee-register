package com.school.studentservice.controller;

import com.school.studentservice.dto.HomeworkDTO;
import com.school.studentservice.model.Homework;
import com.school.studentservice.service.HomeworkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import jakarta.validation.Valid;
import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/api/students/homework")
@CrossOrigin(origins = "*")
public class HomeworkController {
    
    @Autowired
    private HomeworkService homeworkService;
    
    /**
     * Create new homework assignment
     */
    @PostMapping
    public ResponseEntity<HomeworkDTO> createHomework(@Valid @RequestBody HomeworkDTO homeworkDTO) {
        try {
            HomeworkDTO result = homeworkService.createHomework(homeworkDTO);
            return ResponseEntity.status(HttpStatus.CREATED).body(result);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(null);
        }
    }
    
    /**
     * Update homework assignment
     */
    @PutMapping("/{id}")
    public ResponseEntity<HomeworkDTO> updateHomework(@PathVariable Long id, @Valid @RequestBody HomeworkDTO homeworkDTO) {
        try {
            HomeworkDTO result = homeworkService.updateHomework(id, homeworkDTO);
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(null);
        }
    }
    
    /**
     * Get homework by ID
     */
    @GetMapping("/{id}")
    public ResponseEntity<HomeworkDTO> getHomeworkById(@PathVariable Long id) {
        try {
            HomeworkDTO result = homeworkService.getHomeworkById(id);
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            return ResponseEntity.notFound().build();
        }
    }
    
    /**
     * Get all homework by teacher
     */
    @GetMapping("/teacher/{teacherId}")
    public ResponseEntity<List<HomeworkDTO>> getHomeworkByTeacher(@PathVariable Long teacherId) {
        try {
            List<HomeworkDTO> result = homeworkService.getHomeworkByTeacher(teacherId);
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
    /**
     * Get homework by subject, class, and section
     */
    @GetMapping("/subject/{subjectId}/class/{classId}/section/{section}")
    public ResponseEntity<List<HomeworkDTO>> getHomeworkBySubjectClassSection(
            @PathVariable Long subjectId,
            @PathVariable Long classId,
            @PathVariable String section) {
        try {
            List<HomeworkDTO> result = homeworkService.getHomeworkBySubjectClassSection(subjectId, classId, section);
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
    /**
     * Get homework by class and section
     */
    @GetMapping("/class/{classId}/section/{section}")
    public ResponseEntity<List<HomeworkDTO>> getHomeworkByClassSection(
            @PathVariable Long classId,
            @PathVariable String section) {
        try {
            List<HomeworkDTO> result = homeworkService.getHomeworkByClassSection(classId, section);
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    /**
     * Get homework for parent (based on their children's classes)
     */
    @GetMapping("/parent/{parentId}")
    public ResponseEntity<List<HomeworkDTO>> getHomeworkForParent(@PathVariable Long parentId) {
        try {
            // This should be implemented to get homework for all classes where the parent has children
            // For now, return empty list to prevent errors
            List<HomeworkDTO> result = List.of();
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
    /**
     * Get homework by subject
     */
    @GetMapping("/subject/{subjectId}")
    public ResponseEntity<List<HomeworkDTO>> getHomeworkBySubject(@PathVariable Long subjectId) {
        try {
            List<HomeworkDTO> result = homeworkService.getHomeworkBySubject(subjectId);
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
    /**
     * Get active homework by teacher
     */
    @GetMapping("/teacher/{teacherId}/active")
    public ResponseEntity<List<HomeworkDTO>> getActiveHomeworkByTeacher(@PathVariable Long teacherId) {
        try {
            List<HomeworkDTO> result = homeworkService.getActiveHomeworkByTeacher(teacherId);
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
    /**
     * Get overdue homework
     */
    @GetMapping("/overdue")
    public ResponseEntity<List<HomeworkDTO>> getOverdueHomework() {
        try {
            List<HomeworkDTO> result = homeworkService.getOverdueHomework();
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
    /**
     * Get upcoming homework (due in next 7 days)
     */
    @GetMapping("/upcoming")
    public ResponseEntity<List<HomeworkDTO>> getUpcomingHomework() {
        try {
            List<HomeworkDTO> result = homeworkService.getUpcomingHomework();
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
    /**
     * Get homework by due date range
     */
    @GetMapping("/due-date-range")
    public ResponseEntity<List<HomeworkDTO>> getHomeworkByDueDateRange(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate) {
        try {
            List<HomeworkDTO> result = homeworkService.getHomeworkByDueDateRange(startDate, endDate);
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
    /**
     * Get homework by priority
     */
    @GetMapping("/priority/{priority}")
    public ResponseEntity<List<HomeworkDTO>> getHomeworkByPriority(@PathVariable String priority) {
        try {
            Homework.Priority priorityEnum = Homework.Priority.valueOf(priority.toUpperCase());
            List<HomeworkDTO> result = homeworkService.getHomeworkByPriority(priorityEnum);
            return ResponseEntity.ok(result);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().build();
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
    /**
     * Delete homework
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteHomework(@PathVariable Long id, @RequestParam Long teacherId) {
        try {
            homeworkService.deleteHomework(id, teacherId);
            return ResponseEntity.noContent().build();
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).build();
        }
    }
    
    /**
     * Archive homework
     */
    @PutMapping("/{id}/archive")
    public ResponseEntity<HomeworkDTO> archiveHomework(@PathVariable Long id, @RequestParam Long teacherId) {
        try {
            HomeworkDTO result = homeworkService.archiveHomework(id, teacherId);
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).build();
        }
    }
    
    /**
     * Complete homework
     */
    @PutMapping("/{id}/complete")
    public ResponseEntity<HomeworkDTO> completeHomework(@PathVariable Long id, @RequestParam Long teacherId) {
        try {
            HomeworkDTO result = homeworkService.completeHomework(id, teacherId);
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).build();
        }
    }
    
    /**
     * Get homework statistics for a teacher
     */
    @GetMapping("/teacher/{teacherId}/statistics")
    public ResponseEntity<HomeworkService.HomeworkStatistics> getHomeworkStatistics(@PathVariable Long teacherId) {
        try {
            HomeworkService.HomeworkStatistics result = homeworkService.getHomeworkStatistics(teacherId);
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
    /**
     * Get subjects that a teacher can assign homework for
     */
    @GetMapping("/teacher/{teacherId}/subjects")
    public ResponseEntity<List<Long>> getTeacherSubjects(@PathVariable Long teacherId) {
        try {
            List<Long> result = homeworkService.getTeacherSubjects(teacherId);
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
    /**
     * Get classes that a teacher can assign homework for
     */
    @GetMapping("/teacher/{teacherId}/classes")
    public ResponseEntity<List<Long>> getTeacherClasses(@PathVariable Long teacherId) {
        try {
            List<Long> result = homeworkService.getTeacherClasses(teacherId);
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
    /**
     * Get homework by academic year
     */
    @GetMapping("/academic-year/{academicYearId}")
    public ResponseEntity<List<HomeworkDTO>> getHomeworkByAcademicYear(@PathVariable Long academicYearId) {
        try {
            List<Homework> homeworkList = homeworkService.getHomeworkByAcademicYear(academicYearId);
            List<HomeworkDTO> result = homeworkList.stream()
                    .map(HomeworkDTO::new)
                    .collect(java.util.stream.Collectors.toList());
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
    /**
     * Get homework by teacher and academic year
     */
    @GetMapping("/teacher/{teacherId}/academic-year/{academicYearId}")
    public ResponseEntity<List<HomeworkDTO>> getHomeworkByTeacherAndAcademicYear(
            @PathVariable Long teacherId,
            @PathVariable Long academicYearId) {
        try {
            List<Homework> homeworkList = homeworkService.getHomeworkByTeacherAndAcademicYear(teacherId, academicYearId);
            List<HomeworkDTO> result = homeworkList.stream()
                    .map(HomeworkDTO::new)
                    .collect(java.util.stream.Collectors.toList());
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
    /**
     * Get homework by class and academic year
     */
    @GetMapping("/class/{classId}/academic-year/{academicYearId}")
    public ResponseEntity<List<HomeworkDTO>> getHomeworkByClassAndAcademicYear(
            @PathVariable Long classId,
            @PathVariable Long academicYearId) {
        try {
            List<Homework> homeworkList = homeworkService.getHomeworkByClassAndAcademicYear(classId, academicYearId);
            List<HomeworkDTO> result = homeworkList.stream()
                    .map(HomeworkDTO::new)
                    .collect(java.util.stream.Collectors.toList());
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
    /**
     * Get homework by subject, class, section and academic year
     */
    @GetMapping("/subject/{subjectId}/class/{classId}/section/{section}/academic-year/{academicYearId}")
    public ResponseEntity<List<HomeworkDTO>> getHomeworkBySubjectClassSectionAndAcademicYear(
            @PathVariable Long subjectId,
            @PathVariable Long classId,
            @PathVariable String section,
            @PathVariable Long academicYearId) {
        try {
            List<Homework> homeworkList = homeworkService.getHomeworkBySubjectClassSectionAndAcademicYear(subjectId, classId, section, academicYearId);
            List<HomeworkDTO> result = homeworkList.stream()
                    .map(HomeworkDTO::new)
                    .collect(java.util.stream.Collectors.toList());
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
} 