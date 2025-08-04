package com.school.studentservice.service;

import com.school.studentservice.dto.FeeDTO;
import com.school.studentservice.model.Fee;
import com.school.studentservice.repository.FeeRepository;
import com.school.studentservice.repository.StudentRepository;
import com.school.studentservice.repository.ClassRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class FeeService {
    
    @Autowired
    private FeeRepository feeRepository;
    
    @Autowired
    private StudentRepository studentRepository;
    
    @Autowired
    private ClassRepository classRepository;
    
    // Get all fees
    public List<FeeDTO> getAllFees() {
        return feeRepository.findAll().stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }
    
    // Get fee by ID
    public FeeDTO getFeeById(Long id) {
        Fee fee = feeRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Fee not found with id: " + id));
        return convertToDTO(fee);
    }
    
    // Get fees by student ID
    public List<FeeDTO> getFeesByStudentId(Long studentId) {
        return feeRepository.findByStudentId(studentId).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }
    
    // Get fees by parent email (for their children)
    public List<FeeDTO> getFeesByParentEmail(String parentEmail) {
        return feeRepository.findByParentEmail(parentEmail).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }
    
    // Get fees by parent ID (for their children) - placeholder method
    public List<FeeDTO> getFeesByParentId(Long parentId) {
        // This is a placeholder since Student entity doesn't have parentId
        // You may need to implement this based on your parent-student relationship
        throw new UnsupportedOperationException("Parent ID relationship not implemented. Use getFeesByParentEmail instead.");
    }
    
    // Get fees by class ID
    public List<FeeDTO> getFeesByClassId(Long classId) {
        return feeRepository.findByClassId(classId).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }
    
    // Get fees by fee type
    public List<FeeDTO> getFeesByFeeType(Fee.FeeType feeType) {
        return feeRepository.findByFeeType(feeType).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }
    
    // Get fees by status
    public List<FeeDTO> getFeesByStatus(Fee.FeeStatus status) {
        return feeRepository.findByStatus(status).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }
    
    // Get overdue fees
    public List<FeeDTO> getOverdueFees() {
        return feeRepository.findOverdueFees().stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }
    
    // Get pending fees
    public List<FeeDTO> getPendingFees() {
        return feeRepository.findPendingFees().stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }
    
    // Get partial paid fees
    public List<FeeDTO> getPartialPaidFees() {
        return feeRepository.findPartialPaidFees().stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }
    
    // Create new fee
    public FeeDTO createFee(FeeDTO feeDTO) {
        Fee fee = convertToEntity(feeDTO);
        Fee savedFee = feeRepository.save(fee);
        return convertToDTO(savedFee);
    }
    
    // Update fee
    public FeeDTO updateFee(Long id, FeeDTO feeDTO) {
        Fee existingFee = feeRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Fee not found with id: " + id));
        
        // Update fields
        existingFee.setStudentId(feeDTO.getStudentId());
        existingFee.setClassId(feeDTO.getClassId());
        existingFee.setFeeType(feeDTO.getFeeType());
        existingFee.setAmount(feeDTO.getAmount());
        existingFee.setDueDate(feeDTO.getDueDate());
        existingFee.setRemarks(feeDTO.getRemarks());
        
        Fee updatedFee = feeRepository.save(existingFee);
        return convertToDTO(updatedFee);
    }
    
    // Delete fee
    public void deleteFee(Long id) {
        if (!feeRepository.existsById(id)) {
            throw new RuntimeException("Fee not found with id: " + id);
        }
        feeRepository.deleteById(id);
    }
    
    // Get total fees amount by student
    public Double getTotalFeesAmountByStudent(Long studentId) {
        return feeRepository.getTotalFeesAmountByStudent(studentId);
    }
    
    // Get total paid amount by student
    public Double getTotalPaidAmountByStudent(Long studentId) {
        return feeRepository.getTotalPaidAmountByStudent(studentId);
    }
    
    // Convert Entity to DTO
    private FeeDTO convertToDTO(Fee fee) {
        FeeDTO dto = new FeeDTO();
        dto.setId(fee.getId());
        dto.setStudentId(fee.getStudentId());
        dto.setClassId(fee.getClassId());
        dto.setFeeType(fee.getFeeType());
        dto.setAmount(fee.getAmount());
        dto.setDueDate(fee.getDueDate());
        dto.setStatus(fee.getStatus());
        dto.setPaidAmount(fee.getPaidAmount());
        dto.setRemarks(fee.getRemarks());
        dto.setCreatedAt(fee.getCreatedAt());
        dto.setUpdatedAt(fee.getUpdatedAt());
        
        // Add additional details
        studentRepository.findById(fee.getStudentId()).ifPresent(student -> {
            dto.setStudentName(student.getFirstName() + " " + student.getLastName());
        });
        
        classRepository.findById(fee.getClassId()).ifPresent(cls -> {
            dto.setClassName(cls.getName());
        });
        
        return dto;
    }
    
    // Convert DTO to Entity
    private Fee convertToEntity(FeeDTO dto) {
        Fee fee = new Fee();
        fee.setId(dto.getId());
        fee.setStudentId(dto.getStudentId());
        fee.setClassId(dto.getClassId());
        fee.setFeeType(dto.getFeeType());
        fee.setAmount(dto.getAmount());
        fee.setDueDate(dto.getDueDate());
        fee.setRemarks(dto.getRemarks());
        
        return fee;
    }
} 