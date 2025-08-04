package com.school.studentservice.service;

import com.school.studentservice.dto.StudentDTO;
import com.school.studentservice.exception.DuplicateStudentException;
import com.school.studentservice.exception.StudentNotFoundException;
import com.school.studentservice.model.Student;
import com.school.studentservice.repository.StudentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class StudentService {
    @Autowired
    private StudentRepository studentRepository;
    
    @Autowired
    private UserService userService;

    public List<StudentDTO> getAllStudents() {
        return studentRepository.findAll().stream()
                .map(StudentDTO::new)
                .collect(Collectors.toList());
    }

    public StudentDTO getStudentById(Long id) {
        Student student = studentRepository.findById(id)
                .orElseThrow(() -> new StudentNotFoundException(id));
        return new StudentDTO(student);
    }

    public StudentDTO getStudentByStudentId(String studentId) {
        Student student = studentRepository.findByStudentId(studentId)
                .orElseThrow(() -> new StudentNotFoundException(studentId, "student ID"));
        return new StudentDTO(student);
    }

    public List<StudentDTO> getStudentsByClass(Long classId) {
        return studentRepository.findByClassId(classId).stream()
                .map(StudentDTO::new)
                .collect(Collectors.toList());
    }

    public List<StudentDTO> getStudentsByAcademicYear(Long academicYearId) {
        return studentRepository.findByAcademicYearId(academicYearId).stream()
                .map(StudentDTO::new)
                .collect(Collectors.toList());
    }

    public List<StudentDTO> getActiveStudents() {
        return studentRepository.findByIsActive(true).stream()
                .map(StudentDTO::new)
                .collect(Collectors.toList());
    }

    public List<StudentDTO> searchStudentsByName(String name) {
        return studentRepository.findByNameContaining(name).stream()
                .map(StudentDTO::new)
                .collect(Collectors.toList());
    }

    public List<StudentDTO> getStudentsByClassAndYear(Long classId, Long academicYearId) {
        return studentRepository.findByClassIdAndAcademicYearId(classId, academicYearId).stream()
                .map(StudentDTO::new)
                .collect(Collectors.toList());
    }

    public List<StudentDTO> getStudentsByParentEmail(String parentEmail) {
        return studentRepository.findByParentEmail(parentEmail).stream()
                .map(StudentDTO::new)
                .collect(Collectors.toList());
    }

    public List<StudentDTO> getStudentsByParentPhone(String parentPhone) {
        return studentRepository.findByParentPhone(parentPhone).stream()
                .map(StudentDTO::new)
                .collect(Collectors.toList());
    }

    public StudentDTO createStudent(StudentDTO studentDTO) {
        // Check for duplicate student ID
        if (studentRepository.existsByStudentId(studentDTO.getStudentId())) {
            throw new DuplicateStudentException(studentDTO.getStudentId());
        }
        
        // Check for duplicate email if provided
        if (studentDTO.getEmail() != null && !studentDTO.getEmail().trim().isEmpty() && 
            studentRepository.existsByEmail(studentDTO.getEmail())) {
            throw new DuplicateStudentException("email", studentDTO.getEmail());
        }
        
        // Validate email format if provided
        if (studentDTO.getEmail() != null && !studentDTO.getEmail().trim().isEmpty()) {
            String emailRegex = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$";
            if (!studentDTO.getEmail().matches(emailRegex)) {
                throw new IllegalArgumentException("Invalid email format: " + studentDTO.getEmail());
            }
        }
        
        // Validate parent email format if provided
        if (studentDTO.getParentEmail() != null && !studentDTO.getParentEmail().trim().isEmpty()) {
            String emailRegex = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$";
            if (!studentDTO.getParentEmail().matches(emailRegex)) {
                throw new IllegalArgumentException("Invalid parent email format: " + studentDTO.getParentEmail());
            }
        }
        
        Student student = studentDTO.toEntity();
        Student savedStudent = studentRepository.save(student);
        
        // Create user account for parent login
        if (studentDTO.getPrimaryContactPhone() != null && !studentDTO.getPrimaryContactPhone().trim().isEmpty()) {
            String parentName = studentDTO.getParentName() != null ? studentDTO.getParentName() : 
                               "Parent of " + studentDTO.getFirstName() + " " + studentDTO.getLastName();
            
            boolean userCreated = userService.createParentUser(
                studentDTO.getPrimaryContactPhone().trim(),
                parentName,
                savedStudent.getId()
            );
            
            if (!userCreated) {
                System.err.println("Warning: Failed to create user account for parent: " + studentDTO.getPrimaryContactPhone());
            }
        }
        
        return new StudentDTO(savedStudent);
    }

    public StudentDTO updateStudent(Long id, StudentDTO studentDTO) {
        Student existingStudent = studentRepository.findById(id)
                .orElseThrow(() -> new StudentNotFoundException(id));
        
        // Check for duplicate student ID if changed
        if (!existingStudent.getStudentId().equals(studentDTO.getStudentId()) && 
            studentRepository.existsByStudentId(studentDTO.getStudentId())) {
            throw new DuplicateStudentException(studentDTO.getStudentId());
        }
        
        // Check for duplicate email if changed
        if (studentDTO.getEmail() != null && 
            !studentDTO.getEmail().equals(existingStudent.getEmail()) && 
            studentRepository.existsByEmail(studentDTO.getEmail())) {
            throw new DuplicateStudentException("email", studentDTO.getEmail());
        }
        
        // Update fields
        existingStudent.setStudentId(studentDTO.getStudentId());
        existingStudent.setFirstName(studentDTO.getFirstName());
        existingStudent.setLastName(studentDTO.getLastName());
        existingStudent.setDateOfBirth(studentDTO.getDateOfBirth());
        existingStudent.setGender(studentDTO.getGender());
        existingStudent.setAddress(studentDTO.getAddress());
        existingStudent.setPhone(studentDTO.getPhone());
        existingStudent.setEmail(studentDTO.getEmail());
        existingStudent.setParentName(studentDTO.getParentName());
        existingStudent.setParentPhone(studentDTO.getParentPhone());
        existingStudent.setParentEmail(studentDTO.getParentEmail());
        existingStudent.setClassId(studentDTO.getClassId());
        existingStudent.setAcademicYearId(studentDTO.getAcademicYearId());
        existingStudent.setAdmissionDate(studentDTO.getAdmissionDate());
        existingStudent.setIsActive(studentDTO.getIsActive());
        
        Student updatedStudent = studentRepository.save(existingStudent);
        return new StudentDTO(updatedStudent);
    }

    public void deleteStudent(Long id) {
        if (!studentRepository.existsById(id)) {
            throw new StudentNotFoundException(id);
        }
        studentRepository.deleteById(id);
    }

    public void deactivateStudent(Long id) {
        Student student = studentRepository.findById(id)
                .orElseThrow(() -> new StudentNotFoundException(id));
        student.setIsActive(false);
        studentRepository.save(student);
    }

    public void activateStudent(Long id) {
        Student student = studentRepository.findById(id)
                .orElseThrow(() -> new StudentNotFoundException(id));
        student.setIsActive(true);
        studentRepository.save(student);
    }
} 