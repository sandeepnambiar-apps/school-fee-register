package com.school.studentservice.service;

import com.school.studentservice.dto.StudentMarksDTO;
import com.school.studentservice.model.StudentMarks;
import com.school.studentservice.repository.StudentMarksRepository;
import com.school.studentservice.repository.StudentRepository;
import com.school.studentservice.repository.SubjectRepository;
import com.school.studentservice.repository.ClassRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class StudentMarksService {
    
    @Autowired
    private StudentMarksRepository studentMarksRepository;
    
    @Autowired
    private StudentRepository studentRepository;
    
    @Autowired
    private SubjectRepository subjectRepository;
    
    @Autowired
    private ClassRepository classRepository;
    
    // Get all marks
    public List<StudentMarksDTO> getAllMarks() {
        return studentMarksRepository.findAll().stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }
    
    // Get marks by ID
    public StudentMarksDTO getMarksById(Long id) {
        StudentMarks marks = studentMarksRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Marks not found with id: " + id));
        return convertToDTO(marks);
    }
    
    // Get marks by student ID
    public List<StudentMarksDTO> getMarksByStudentId(Long studentId) {
        return studentMarksRepository.findByStudentId(studentId).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }
    
    // Get marks by teacher ID
    public List<StudentMarksDTO> getMarksByTeacherId(Long teacherId) {
        return studentMarksRepository.findByTeacherId(teacherId).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }
    
    // Get marks by parent email (for their children)
    public List<StudentMarksDTO> getMarksByParentEmail(String parentEmail) {
        return studentMarksRepository.findByParentEmail(parentEmail).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }
    
    // Get marks by parent ID (for their children) - placeholder method
    public List<StudentMarksDTO> getMarksByParentId(Long parentId) {
        // This is a placeholder since Student entity doesn't have parentId
        // You may need to implement this based on your parent-student relationship
        throw new UnsupportedOperationException("Parent ID relationship not implemented. Use getMarksByParentEmail instead.");
    }
    
    // Get marks by class ID
    public List<StudentMarksDTO> getMarksByClassId(Long classId) {
        return studentMarksRepository.findByClassId(classId).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }
    
    // Get marks by subject ID
    public List<StudentMarksDTO> getMarksBySubjectId(Long subjectId) {
        return studentMarksRepository.findBySubjectId(subjectId).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }
    
    // Get recent marks (last 30 days)
    public List<StudentMarksDTO> getRecentMarks() {
        // Calculate date 30 days ago
        java.time.LocalDate thirtyDaysAgo = java.time.LocalDate.now().minusDays(30);
        return studentMarksRepository.findRecentMarks(thirtyDaysAgo.toString()).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }
    
    // Create new marks
    public StudentMarksDTO createMarks(StudentMarksDTO marksDTO) {
        StudentMarks marks = convertToEntity(marksDTO);
        StudentMarks savedMarks = studentMarksRepository.save(marks);
        return convertToDTO(savedMarks);
    }
    
    // Update marks
    public StudentMarksDTO updateMarks(Long id, StudentMarksDTO marksDTO) {
        StudentMarks existingMarks = studentMarksRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Marks not found with id: " + id));
        
        // Update fields
        existingMarks.setStudentId(marksDTO.getStudentId());
        existingMarks.setSubjectId(marksDTO.getSubjectId());
        existingMarks.setClassId(marksDTO.getClassId());
        existingMarks.setTeacherId(marksDTO.getTeacherId());
        existingMarks.setExamType(marksDTO.getExamType());
        existingMarks.setExamDate(marksDTO.getExamDate());
        existingMarks.setMarksObtained(marksDTO.getMarksObtained());
        existingMarks.setTotalMarks(marksDTO.getTotalMarks());
        existingMarks.setRemarks(marksDTO.getRemarks());
        
        StudentMarks updatedMarks = studentMarksRepository.save(existingMarks);
        return convertToDTO(updatedMarks);
    }
    
    // Delete marks
    public void deleteMarks(Long id) {
        if (!studentMarksRepository.existsById(id)) {
            throw new RuntimeException("Marks not found with id: " + id);
        }
        studentMarksRepository.deleteById(id);
    }
    
    // Delete marks by teacher (for authorization)
    public void deleteMarksByTeacher(Long id, Long teacherId) {
        StudentMarks marks = studentMarksRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Marks not found with id: " + id));
        
        if (!marks.getTeacherId().equals(teacherId)) {
            throw new RuntimeException("Unauthorized to delete these marks");
        }
        
        studentMarksRepository.deleteById(id);
    }
    
    // Convert Entity to DTO
    private StudentMarksDTO convertToDTO(StudentMarks marks) {
        StudentMarksDTO dto = new StudentMarksDTO();
        dto.setId(marks.getId());
        dto.setStudentId(marks.getStudentId());
        dto.setSubjectId(marks.getSubjectId());
        dto.setClassId(marks.getClassId());
        dto.setTeacherId(marks.getTeacherId());
        dto.setExamType(marks.getExamType());
        dto.setExamDate(marks.getExamDate());
        dto.setMarksObtained(marks.getMarksObtained());
        dto.setTotalMarks(marks.getTotalMarks());
        dto.setPercentage(marks.getPercentage());
        dto.setGrade(marks.getGrade());
        dto.setRemarks(marks.getRemarks());
        dto.setCreatedAt(marks.getCreatedAt());
        dto.setUpdatedAt(marks.getUpdatedAt());
        
        // Add additional details
        studentRepository.findById(marks.getStudentId()).ifPresent(student -> {
            dto.setStudentName(student.getFirstName() + " " + student.getLastName());
        });
        
        subjectRepository.findById(marks.getSubjectId()).ifPresent(subject -> {
            dto.setSubjectName(subject.getName());
        });
        
        classRepository.findById(marks.getClassId()).ifPresent(cls -> {
            dto.setClassName(cls.getName());
        });
        
        return dto;
    }
    
    // Convert DTO to Entity
    private StudentMarks convertToEntity(StudentMarksDTO dto) {
        StudentMarks marks = new StudentMarks();
        marks.setId(dto.getId());
        marks.setStudentId(dto.getStudentId());
        marks.setSubjectId(dto.getSubjectId());
        marks.setClassId(dto.getClassId());
        marks.setTeacherId(dto.getTeacherId());
        marks.setExamType(dto.getExamType());
        marks.setExamDate(dto.getExamDate());
        marks.setMarksObtained(dto.getMarksObtained());
        marks.setTotalMarks(dto.getTotalMarks());
        marks.setRemarks(dto.getRemarks());
        
        return marks;
    }
} 