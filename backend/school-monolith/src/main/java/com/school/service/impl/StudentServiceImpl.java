package com.school.service.impl;

import com.school.dto.StudentDTO;
import com.school.dto.StudentRegistrationDTO;
import com.school.entity.Student;
import com.school.entity.School;
import com.school.repository.StudentRepository;
import com.school.repository.SchoolRepository;
import com.school.service.StudentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class StudentServiceImpl implements StudentService {

    @Autowired
    private StudentRepository studentRepository;
    
    @Autowired
    private SchoolRepository schoolRepository;
    
    @Override
    public void initializeDefaultStudents() {
        // Check if students already exist
        if (studentRepository.count() == 0) {
            // Get the first school (Demo School)
            Optional<School> schoolOpt = schoolRepository.findById(1L);
            if (schoolOpt.isPresent()) {
                School school = schoolOpt.get();
                
                // Create some default students
                createDefaultStudent("John Doe", "ST001", "Class 10", "A", LocalDate.of(2008, 5, 15), "Male", school);
                createDefaultStudent("Jane Smith", "ST002", "Class 10", "A", LocalDate.of(2008, 8, 22), "Female", school);
                createDefaultStudent("Mike Johnson", "ST003", "Class 9", "B", LocalDate.of(2009, 3, 10), "Male", school);
                createDefaultStudent("Sarah Wilson", "ST004", "Class 9", "B", LocalDate.of(2009, 11, 5), "Female", school);
                createDefaultStudent("David Brown", "ST005", "Class 8", "C", LocalDate.of(2010, 7, 18), "Male", school);
            }
        }
    }

    private void createDefaultStudent(String name, String rollNumber, String className, String section,
                                   LocalDate dateOfBirth, String gender, School school) {
        Student student = new Student();
        student.setName(name);
        student.setRollNumber(rollNumber);
        student.setClassName(className);
        student.setSection(section);
        student.setDateOfBirth(dateOfBirth);
        student.setGender(gender);
        student.setAddress("123 School Street, City");
        // Note: Student entity doesn't have phone field, using fatherPhone instead
        student.setEmail(name.toLowerCase().replace(" ", ".") + "@school.com");
        student.setFatherName("Father of " + name);
        student.setFatherPhone("+1234567891");
        student.setMotherName("Mother of " + name);
        student.setMotherPhone("+1234567892");
        student.setIsActive(true);
        student.setSchool(school);
        
        // NEW: Set the additional required fields
        student.setKidAadhaar("123456789012"); // Default Aadhaar
        student.setPen("PEN" + rollNumber); // Default PEN
        student.setFatherAadhaar("987654321098"); // Default Father Aadhaar
        student.setMotherAadhaar("876543210987"); // Default Mother Aadhaar
        student.setCaste("General"); // Default Caste
        student.setCategory("General"); // Default Category
        
        // Generate parent login code
        String loginCode = generateLoginCode();
        student.setParentLoginCode(loginCode);
        student.setParentLoginCodeUsed(false);
        
        studentRepository.save(student);
    }

    @Override
    public List<StudentDTO> getAllStudents(Long schoolId) {
        if (schoolId == null) {
            // If no schoolId provided, return all active students
            return studentRepository.findByIsActiveTrue()
                    .stream()
                    .map(this::convertToDTO)
                    .collect(Collectors.toList());
        }
        return studentRepository.findBySchool_IdAndIsActiveTrue(schoolId)
                .stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Override
    public StudentDTO getStudentById(Long id, Long schoolId) {
        Optional<Student> studentOpt = studentRepository.findById(id);
        if (studentOpt.isEmpty() || !schoolId.equals(studentOpt.get().getSchool().getId())) {
            throw new RuntimeException("Student not found with ID: " + id);
        }
        return convertToDTO(studentOpt.get());
    }

    @Override
    public StudentDTO createStudent(StudentRegistrationDTO registrationDTO) {
        // Get the school
        Optional<School> schoolOpt = schoolRepository.findById(registrationDTO.getSchoolId());
        if (schoolOpt.isEmpty()) {
            throw new RuntimeException("School not found with ID: " + registrationDTO.getSchoolId());
        }
        
        // Check if email already exists
        if (studentRepository.existsByEmailAndSchool_Id(registrationDTO.getEmail(), registrationDTO.getSchoolId())) {
            throw new RuntimeException("Student with email already exists: " + registrationDTO.getEmail());
        }
        
        // Create new student
        Student student = new Student();
        student.setName(registrationDTO.getName());
        student.setRollNumber(registrationDTO.getRollNumber());
        student.setClassName(registrationDTO.getClassName());
        student.setSection(registrationDTO.getSection());
        student.setDateOfBirth(registrationDTO.getDateOfBirth());
        student.setGender(registrationDTO.getGender());
        student.setAddress(registrationDTO.getAddress());
        // Note: Student entity doesn't have phone field
        student.setEmail(registrationDTO.getEmail());
        student.setFatherName(registrationDTO.getFatherName());
        student.setFatherPhone(registrationDTO.getFatherPhone());
        student.setMotherName(registrationDTO.getMotherName());
        student.setMotherPhone(registrationDTO.getMotherPhone());
        student.setIsActive(true);
        student.setSchool(schoolOpt.get());
        
        // NEW: Set the additional required fields with default values
        student.setKidAadhaar(registrationDTO.getKidAadhaar() != null ? registrationDTO.getKidAadhaar() : "123456789012");
        student.setPen(registrationDTO.getPen() != null ? registrationDTO.getPen() : "PEN" + registrationDTO.getRollNumber());
        student.setFatherAadhaar(registrationDTO.getFatherAadhaar() != null ? registrationDTO.getFatherAadhaar() : "987654321098");
        student.setMotherAadhaar(registrationDTO.getMotherAadhaar() != null ? registrationDTO.getMotherAadhaar() : "876543210987");
        student.setCaste(registrationDTO.getCaste() != null ? registrationDTO.getCaste() : "General");
        student.setCategory(registrationDTO.getCategory() != null ? registrationDTO.getCategory() : "General");
        
        // Generate parent login code
        String loginCode = generateLoginCode();
        student.setParentLoginCode(loginCode);
        student.setParentLoginCodeUsed(false);
        
        Student savedStudent = studentRepository.save(student);
        return convertToDTO(savedStudent);
    }

    @Override
    public StudentDTO updateStudent(StudentDTO studentDTO) {
        Optional<Student> existingStudentOpt = studentRepository.findById(studentDTO.getId());
        if (existingStudentOpt.isEmpty()) {
            throw new RuntimeException("Student not found with ID: " + studentDTO.getId());
        }
        
        Student existingStudent = existingStudentOpt.get();
        
        // Update fields
        existingStudent.setName(studentDTO.getName());
        existingStudent.setRollNumber(studentDTO.getRollNumber());
        existingStudent.setClassName(studentDTO.getClassName());
        existingStudent.setSection(studentDTO.getSection());
        existingStudent.setDateOfBirth(studentDTO.getDateOfBirth());
        existingStudent.setGender(studentDTO.getGender());
        existingStudent.setAddress(studentDTO.getAddress());
        // Note: Student entity doesn't have phone field
        existingStudent.setEmail(studentDTO.getEmail());
        existingStudent.setFatherName(studentDTO.getFatherName());
        existingStudent.setFatherPhone(studentDTO.getFatherPhone());
        existingStudent.setMotherName(studentDTO.getMotherName());
        existingStudent.setMotherPhone(studentDTO.getMotherPhone());
        
        // NEW: Update the additional required fields if provided
        if (studentDTO.getKidAadhaar() != null) existingStudent.setKidAadhaar(studentDTO.getKidAadhaar());
        if (studentDTO.getPen() != null) existingStudent.setPen(studentDTO.getPen());
        if (studentDTO.getFatherAadhaar() != null) existingStudent.setFatherAadhaar(studentDTO.getFatherAadhaar());
        if (studentDTO.getMotherAadhaar() != null) existingStudent.setMotherAadhaar(studentDTO.getMotherAadhaar());
        if (studentDTO.getCaste() != null) existingStudent.setCaste(studentDTO.getCaste());
        if (studentDTO.getCategory() != null) existingStudent.setCategory(studentDTO.getCategory());
        
        Student updatedStudent = studentRepository.save(existingStudent);
        return convertToDTO(updatedStudent);
    }

    // Note: The interface only has deleteStudent(Long id), but we need schoolId for security
    // This method will be used internally
    private void deleteStudentWithSchoolId(Long id, Long schoolId) {
        Optional<Student> studentOpt = studentRepository.findById(id);
        if (studentOpt.isPresent() && schoolId.equals(studentOpt.get().getSchool().getId())) {
            Student student = studentOpt.get();
            student.setIsActive(false);
            studentRepository.save(student);
        }
    }

    @Override
    public List<StudentDTO> getStudentsByClass(String className, Long schoolId) {
        return studentRepository.findBySchool_IdAndClassName(schoolId, className)
                .stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    // Helper method for internal use
    private List<StudentDTO> getStudentsByClassAndSection(Long schoolId, String className, String section) {
        return studentRepository.findBySchool_IdAndClassNameAndSection(schoolId, className, section)
                .stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }
    
    private String generateLoginCode() {
        java.util.Random random = new java.util.Random();
        StringBuilder code = new StringBuilder();
        
        // Generate 6-digit alphanumeric code
        for (int i = 0; i < 6; i++) {
            if (random.nextBoolean()) {
                // Add a letter
                code.append((char) (random.nextInt(26) + 'A'));
            } else {
                // Add a digit
                code.append(random.nextInt(10));
            }
        }
        
        return code.toString();
    }

    private StudentDTO convertToDTO(Student student) {
        StudentDTO dto = new StudentDTO();
        dto.setId(student.getId());
        dto.setName(student.getName());
        dto.setRollNumber(student.getRollNumber());
        dto.setClassName(student.getClassName());
        dto.setSection(student.getSection());
        dto.setDateOfBirth(student.getDateOfBirth());
        dto.setGender(student.getGender());
        dto.setAddress(student.getAddress());
        dto.setPhone(""); // Student entity doesn't have phone field
        dto.setEmail(student.getEmail());
        dto.setFatherName(student.getFatherName());
        dto.setFatherPhone(student.getFatherPhone());
        dto.setMotherName(student.getMotherName());
        dto.setMotherPhone(student.getMotherPhone());
        dto.setStatus(student.getIsActive() ? "ACTIVE" : "INACTIVE");
        
        // NEW: Set the additional required fields
        dto.setKidAadhaar(student.getKidAadhaar());
        dto.setPen(student.getPen());
        dto.setFatherAadhaar(student.getFatherAadhaar());
        dto.setMotherAadhaar(student.getMotherAadhaar());
        dto.setCaste(student.getCaste());
        dto.setCategory(student.getCategory());
        
        // NEW: Set parent login code fields
        dto.setParentLoginCode(student.getParentLoginCode());
        dto.setParentLoginCodeUsed(student.getParentLoginCodeUsed());
        
        dto.setSchoolId(student.getSchool().getId());
        dto.setCreatedAt(student.getCreatedAt() != null ? 
            student.getCreatedAt().atStartOfDay() : LocalDateTime.now());
        return dto;
    }
    
    @Override
    public void deleteStudent(Long id) {
        // This method signature doesn't include schoolId, so we'll just delete by ID
        Optional<Student> studentOpt = studentRepository.findById(id);
        if (studentOpt.isPresent()) {
            Student student = studentOpt.get();
            student.setIsActive(false);
            studentRepository.save(student);
        }
    }
    
    @Override
    public List<StudentDTO> searchStudents(String query, Long schoolId) {
        if (schoolId == null) {
            return List.of();
        }
        // Simple search implementation - you can enhance this with more sophisticated search
        return studentRepository.findBySchool_IdAndIsActiveTrue(schoolId)
                .stream()
                .filter(student -> 
                    student.getName().toLowerCase().contains(query.toLowerCase()) ||
                    student.getRollNumber().toLowerCase().contains(query.toLowerCase()) ||
                    student.getClassName().toLowerCase().contains(query.toLowerCase())
                )
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }
    
    @Override
    public StudentDTO getStudentProfile(Long id, Long schoolId) {
        return getStudentById(id, schoolId);
    }
    
    @Override
    public StudentDTO updateStudentStatus(Long id, String status, Long schoolId) {
        Optional<Student> studentOpt = studentRepository.findById(id);
        if (studentOpt.isEmpty() || !schoolId.equals(studentOpt.get().getSchool().getId())) {
            throw new RuntimeException("Student not found with ID: " + id);
        }
        
        Student student = studentOpt.get();
        student.setIsActive("ACTIVE".equals(status));
        Student updatedStudent = studentRepository.save(student);
        return convertToDTO(updatedStudent);
    }
    
    @Override
    public List<Object> getStudentFees(Long id, Long schoolId) {
        // Mock implementation - replace with actual fee service integration
        return List.of();
    }
    
    @Override
    public List<Object> getStudentAttendance(Long id, Long schoolId) {
        // Mock implementation - replace with actual attendance service integration
        return List.of();
    }
    
    @Override
    public List<Object> getStudentMarks(Long id, Long schoolId) {
        // Mock implementation - replace with actual marks service integration
        return List.of();
    }
}
