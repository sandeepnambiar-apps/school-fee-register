package com.school.studentservice.controller;

import com.school.studentservice.dto.StudentDTO;
import com.school.studentservice.service.StudentService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/students")
@CrossOrigin(origins = "*")
public class StudentController {
    @Autowired
    private StudentService studentService;

    @GetMapping
    public ResponseEntity<List<StudentDTO>> getAllStudents() {
        List<StudentDTO> students = studentService.getAllStudents();
        return ResponseEntity.ok(students);
    }

    @GetMapping("/active")
    public ResponseEntity<List<StudentDTO>> getActiveStudents() {
        List<StudentDTO> students = studentService.getActiveStudents();
        return ResponseEntity.ok(students);
    }

    @GetMapping("/{id}")
    public ResponseEntity<StudentDTO> getStudentById(@PathVariable Long id) {
        StudentDTO student = studentService.getStudentById(id);
        return ResponseEntity.ok(student);
    }

    @GetMapping("/studentId/{studentId}")
    public ResponseEntity<StudentDTO> getStudentByStudentId(@PathVariable String studentId) {
        StudentDTO student = studentService.getStudentByStudentId(studentId);
        return ResponseEntity.ok(student);
    }

    @GetMapping("/class/{classId}")
    public ResponseEntity<List<StudentDTO>> getStudentsByClass(@PathVariable Long classId) {
        List<StudentDTO> students = studentService.getStudentsByClass(classId);
        return ResponseEntity.ok(students);
    }

    @GetMapping("/academic-year/{academicYearId}")
    public ResponseEntity<List<StudentDTO>> getStudentsByAcademicYear(@PathVariable Long academicYearId) {
        List<StudentDTO> students = studentService.getStudentsByAcademicYear(academicYearId);
        return ResponseEntity.ok(students);
    }

    @GetMapping("/class/{classId}/year/{academicYearId}")
    public ResponseEntity<List<StudentDTO>> getStudentsByClassAndYear(@PathVariable Long classId, 
                                                                     @PathVariable Long academicYearId) {
        List<StudentDTO> students = studentService.getStudentsByClassAndYear(classId, academicYearId);
        return ResponseEntity.ok(students);
    }

    @GetMapping("/search")
    public ResponseEntity<List<StudentDTO>> searchStudentsByName(@RequestParam String name) {
        List<StudentDTO> students = studentService.searchStudentsByName(name);
        return ResponseEntity.ok(students);
    }

    @GetMapping("/parent/email/{parentEmail}")
    public ResponseEntity<List<StudentDTO>> getStudentsByParentEmail(@PathVariable String parentEmail) {
        List<StudentDTO> students = studentService.getStudentsByParentEmail(parentEmail);
        return ResponseEntity.ok(students);
    }

    @GetMapping("/parent/phone/{parentPhone}")
    public ResponseEntity<List<StudentDTO>> getStudentsByParentPhone(@PathVariable String parentPhone) {
        List<StudentDTO> students = studentService.getStudentsByParentPhone(parentPhone);
        return ResponseEntity.ok(students);
    }

    @PostMapping
    public ResponseEntity<StudentDTO> createStudent(@Valid @RequestBody StudentDTO studentDTO) {
        StudentDTO created = studentService.createStudent(studentDTO);
        return ResponseEntity.status(HttpStatus.CREATED).body(created);
    }

    @PutMapping("/{id}")
    public ResponseEntity<StudentDTO> updateStudent(@PathVariable Long id, 
                                                   @Valid @RequestBody StudentDTO studentDTO) {
        StudentDTO updated = studentService.updateStudent(id, studentDTO);
        return ResponseEntity.ok(updated);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteStudent(@PathVariable Long id) {
        studentService.deleteStudent(id);
        return ResponseEntity.noContent().build();
    }

    @PatchMapping("/{id}/deactivate")
    public ResponseEntity<Void> deactivateStudent(@PathVariable Long id) {
        studentService.deactivateStudent(id);
        return ResponseEntity.ok().build();
    }

    @PatchMapping("/{id}/activate")
    public ResponseEntity<Void> activateStudent(@PathVariable Long id) {
        studentService.activateStudent(id);
        return ResponseEntity.ok().build();
    }

    // Health check endpoint
    @GetMapping("/health")
    public ResponseEntity<String> health() {
        return ResponseEntity.ok("Student Service is running");
    }
} 