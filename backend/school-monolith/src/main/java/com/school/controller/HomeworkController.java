package com.school.controller;

import com.school.dto.HomeworkDTO;
import com.school.dto.HomeworkSubmissionDTO;
import com.school.dto.HomeworkGradeDTO;
import com.school.service.HomeworkService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/homework")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class HomeworkController {

    private final HomeworkService homeworkService;

    // Homework Assignment endpoints
    @GetMapping("/assignments")
    public ResponseEntity<List<HomeworkDTO>> getAllAssignments(@RequestParam(required = false) Long schoolId) {
        List<HomeworkDTO> assignments = homeworkService.getAllAssignments(schoolId);
        return ResponseEntity.ok(assignments);
    }

    @GetMapping("/assignments/{id}")
    public ResponseEntity<HomeworkDTO> getAssignmentById(@PathVariable Long id, @RequestParam(required = false) Long schoolId) {
        HomeworkDTO assignment = homeworkService.getAssignmentById(id, schoolId);
        return ResponseEntity.ok(assignment);
    }

    @PostMapping("/assignments")
    public ResponseEntity<HomeworkDTO> createAssignment(@RequestBody HomeworkDTO homeworkDTO) {
        HomeworkDTO created = homeworkService.createAssignment(homeworkDTO);
        return ResponseEntity.ok(created);
    }

    @PutMapping("/assignments/{id}")
    public ResponseEntity<HomeworkDTO> updateAssignment(@PathVariable Long id, @RequestBody HomeworkDTO homeworkDTO) {
        homeworkDTO.setId(id);
        HomeworkDTO updated = homeworkService.updateAssignment(homeworkDTO);
        return ResponseEntity.ok(updated);
    }

    @DeleteMapping("/assignments/{id}")
    public ResponseEntity<Void> deleteAssignment(@PathVariable Long id) {
        homeworkService.deleteAssignment(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/assignments/class/{className}")
    public ResponseEntity<List<HomeworkDTO>> getAssignmentsByClass(@PathVariable String className, @RequestParam(required = false) Long schoolId) {
        List<HomeworkDTO> assignments = homeworkService.getAssignmentsByClass(className, schoolId);
        return ResponseEntity.ok(assignments);
    }

    @GetMapping("/assignments/subject/{subject}")
    public ResponseEntity<List<HomeworkDTO>> getAssignmentsBySubject(@PathVariable String subject, @RequestParam(required = false) Long schoolId) {
        List<HomeworkDTO> assignments = homeworkService.getAssignmentsBySubject(subject, schoolId);
        return ResponseEntity.ok(assignments);
    }

    // Homework Submission endpoints
    @GetMapping("/submissions")
    public ResponseEntity<List<HomeworkSubmissionDTO>> getAllSubmissions(@RequestParam(required = false) Long schoolId) {
        List<HomeworkSubmissionDTO> submissions = homeworkService.getAllSubmissions(schoolId);
        return ResponseEntity.ok(submissions);
    }

    @GetMapping("/submissions/{id}")
    public ResponseEntity<HomeworkSubmissionDTO> getSubmissionById(@PathVariable Long id, @RequestParam(required = false) Long schoolId) {
        HomeworkSubmissionDTO submission = homeworkService.getSubmissionById(id, schoolId);
        return ResponseEntity.ok(submission);
    }

    @PostMapping("/submissions")
    public ResponseEntity<HomeworkSubmissionDTO> submitHomework(@RequestBody HomeworkSubmissionDTO submissionDTO) {
        HomeworkSubmissionDTO created = homeworkService.submitHomework(submissionDTO);
        return ResponseEntity.ok(created);
    }

    @PutMapping("/submissions/{id}")
    public ResponseEntity<HomeworkSubmissionDTO> updateSubmission(@PathVariable Long id, @RequestBody HomeworkSubmissionDTO submissionDTO) {
        submissionDTO.setId(id);
        HomeworkSubmissionDTO updated = homeworkService.updateSubmission(submissionDTO);
        return ResponseEntity.ok(updated);
    }

    @DeleteMapping("/submissions/{id}")
    public ResponseEntity<Void> deleteSubmission(@PathVariable Long id) {
        homeworkService.deleteSubmission(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/submissions/student/{studentId}")
    public ResponseEntity<List<HomeworkSubmissionDTO>> getSubmissionsByStudent(@PathVariable Long studentId, @RequestParam(required = false) Long schoolId) {
        List<HomeworkSubmissionDTO> submissions = homeworkService.getSubmissionsByStudent(studentId, schoolId);
        return ResponseEntity.ok(submissions);
    }

    @GetMapping("/submissions/assignment/{assignmentId}")
    public ResponseEntity<List<HomeworkSubmissionDTO>> getSubmissionsByAssignment(@PathVariable Long assignmentId, @RequestParam(required = false) Long schoolId) {
        List<HomeworkSubmissionDTO> submissions = homeworkService.getSubmissionsByAssignment(assignmentId, schoolId);
        return ResponseEntity.ok(submissions);
    }

    // Homework Grading endpoints
    @GetMapping("/grades")
    public ResponseEntity<List<HomeworkGradeDTO>> getAllGrades(@RequestParam(required = false) Long schoolId) {
        List<HomeworkGradeDTO> grades = homeworkService.getAllGrades(schoolId);
        return ResponseEntity.ok(grades);
    }

    @GetMapping("/grades/{id}")
    public ResponseEntity<HomeworkGradeDTO> getGradeById(@PathVariable Long id, @RequestParam(required = false) Long schoolId) {
        HomeworkGradeDTO grade = homeworkService.getGradeById(id, schoolId);
        return ResponseEntity.ok(grade);
    }

    @PostMapping("/grades")
    public ResponseEntity<HomeworkGradeDTO> createGrade(@RequestBody HomeworkGradeDTO gradeDTO) {
        HomeworkGradeDTO created = homeworkService.createGrade(gradeDTO);
        return ResponseEntity.ok(created);
    }

    @PutMapping("/grades/{id}")
    public ResponseEntity<HomeworkGradeDTO> updateGrade(@PathVariable Long id, @RequestBody HomeworkGradeDTO gradeDTO) {
        gradeDTO.setId(id);
        HomeworkGradeDTO updated = homeworkService.updateGrade(gradeDTO);
        return ResponseEntity.ok(updated);
    }

    @DeleteMapping("/grades/{id}")
    public ResponseEntity<Void> deleteGrade(@PathVariable Long id) {
        homeworkService.deleteGrade(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/grades/student/{studentId}")
    public ResponseEntity<List<HomeworkGradeDTO>> getGradesByStudent(@PathVariable Long studentId, @RequestParam(required = false) Long schoolId) {
        List<HomeworkGradeDTO> grades = homeworkService.getGradesByStudent(studentId, schoolId);
        return ResponseEntity.ok(grades);
    }

    @GetMapping("/grades/assignment/{assignmentId}")
    public ResponseEntity<List<HomeworkGradeDTO>> getGradesByAssignment(@PathVariable Long assignmentId, @RequestParam(required = false) Long schoolId) {
        List<HomeworkGradeDTO> grades = homeworkService.getGradesByAssignment(assignmentId, schoolId);
        return ResponseEntity.ok(grades);
    }
}
