package com.school.controller;

import com.school.dto.StudentDTO;
import com.school.dto.StudentRegistrationDTO;
import com.school.service.StudentService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/students")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class StudentController {

    private final StudentService studentService;

    @GetMapping
    public ResponseEntity<List<StudentDTO>> getAllStudents(@RequestParam(required = false) Long schoolId) {
        List<StudentDTO> students = studentService.getAllStudents(schoolId);
        return ResponseEntity.ok(students);
    }

    @GetMapping("/{id}")
    public ResponseEntity<StudentDTO> getStudentById(@PathVariable Long id, @RequestParam(required = false) Long schoolId) {
        StudentDTO student = studentService.getStudentById(id, schoolId);
        return ResponseEntity.ok(student);
    }

    @PostMapping
    public ResponseEntity<StudentDTO> createStudent(@RequestBody StudentRegistrationDTO registrationDTO) {
        StudentDTO created = studentService.createStudent(registrationDTO);
        return ResponseEntity.ok(created);
    }

    @PutMapping("/{id}")
    public ResponseEntity<StudentDTO> updateStudent(@PathVariable Long id, @RequestBody StudentDTO studentDTO) {
        studentDTO.setId(id);
        StudentDTO updated = studentService.updateStudent(studentDTO);
        return ResponseEntity.ok(updated);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteStudent(@PathVariable Long id) {
        studentService.deleteStudent(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/class/{className}")
    public ResponseEntity<List<StudentDTO>> getStudentsByClass(@PathVariable String className, @RequestParam(required = false) Long schoolId) {
        List<StudentDTO> students = studentService.getStudentsByClass(className, schoolId);
        return ResponseEntity.ok(students);
    }

    @GetMapping("/search")
    public ResponseEntity<List<StudentDTO>> searchStudents(@RequestParam String query, @RequestParam(required = false) Long schoolId) {
        List<StudentDTO> students = studentService.searchStudents(query, schoolId);
        return ResponseEntity.ok(students);
    }

    @GetMapping("/{id}/profile")
    public ResponseEntity<StudentDTO> getStudentProfile(@PathVariable Long id, @RequestParam(required = false) Long schoolId) {
        StudentDTO profile = studentService.getStudentProfile(id, schoolId);
        return ResponseEntity.ok(profile);
    }

    @PutMapping("/{id}/status")
    public ResponseEntity<StudentDTO> updateStudentStatus(@PathVariable Long id, @RequestParam String status, @RequestParam(required = false) Long schoolId) {
        StudentDTO updated = studentService.updateStudentStatus(id, status, schoolId);
        return ResponseEntity.ok(updated);
    }

    @GetMapping("/{id}/fees")
    public ResponseEntity<List<Object>> getStudentFees(@PathVariable Long id, @RequestParam(required = false) Long schoolId) {
        List<Object> fees = studentService.getStudentFees(id, schoolId);
        return ResponseEntity.ok(fees);
    }

    @GetMapping("/{id}/attendance")
    public ResponseEntity<List<Object>> getStudentAttendance(@PathVariable Long id, @RequestParam(required = false) Long schoolId) {
        List<Object> attendance = studentService.getStudentAttendance(id, schoolId);
        return ResponseEntity.ok(attendance);
    }

    @GetMapping("/{id}/marks")
    public ResponseEntity<List<Object>> getStudentMarks(@PathVariable Long id, @RequestParam(required = false) Long schoolId) {
        List<Object> marks = studentService.getStudentMarks(id, schoolId);
        return ResponseEntity.ok(marks);
    }
}
