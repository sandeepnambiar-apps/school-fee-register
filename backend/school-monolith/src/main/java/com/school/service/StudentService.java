package com.school.service;

import com.school.dto.StudentDTO;
import com.school.dto.StudentRegistrationDTO;

import java.util.List;

public interface StudentService {

    List<StudentDTO> getAllStudents(Long schoolId);

    StudentDTO getStudentById(Long id, Long schoolId);

    StudentDTO createStudent(StudentRegistrationDTO registrationDTO);

    StudentDTO updateStudent(StudentDTO studentDTO);

    void deleteStudent(Long id);

    List<StudentDTO> getStudentsByClass(String className, Long schoolId);

    List<StudentDTO> searchStudents(String query, Long schoolId);

    StudentDTO getStudentProfile(Long id, Long schoolId);

    StudentDTO updateStudentStatus(Long id, String status, Long schoolId);

    List<Object> getStudentFees(Long id, Long schoolId);

    List<Object> getStudentAttendance(Long id, Long schoolId);

    List<Object> getStudentMarks(Long id, Long schoolId);
    
    /**
     * Initialize default students (for development/testing)
     */
    void initializeDefaultStudents();
}
