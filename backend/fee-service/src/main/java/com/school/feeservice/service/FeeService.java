package com.school.feeservice.service;

import com.school.feeservice.dto.FeeStructureDTO;
import com.school.feeservice.dto.StudentFeeDTO;
import com.school.feeservice.exception.FeeNotFoundException;
import com.school.feeservice.model.FeeStructure;
import com.school.feeservice.model.StudentFee;
import com.school.feeservice.repository.FeeStructureRepository;
import com.school.feeservice.repository.StudentFeeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class FeeService {
    
    @Autowired
    private FeeStructureRepository feeStructureRepository;
    
    @Autowired
    private StudentFeeRepository studentFeeRepository;
    
    // Fee Structure methods
    public List<FeeStructureDTO> getAllFeeStructures() {
        return feeStructureRepository.findAll().stream()
                .map(FeeStructureDTO::new)
                .collect(Collectors.toList());
    }
    
    public FeeStructureDTO getFeeStructureById(Long id) {
        FeeStructure feeStructure = feeStructureRepository.findById(id)
                .orElseThrow(() -> new FeeNotFoundException(id, "Fee Structure"));
        return new FeeStructureDTO(feeStructure);
    }
    
    public List<FeeStructureDTO> getFeeStructuresByClass(Long classId) {
        return feeStructureRepository.findByClassId(classId).stream()
                .map(FeeStructureDTO::new)
                .collect(Collectors.toList());
    }
    
    public List<FeeStructureDTO> getFeeStructuresByClassAndYear(Long classId, Long academicYearId) {
        return feeStructureRepository.findByClassIdAndAcademicYearId(classId, academicYearId).stream()
                .map(FeeStructureDTO::new)
                .collect(Collectors.toList());
    }
    
    public List<FeeStructureDTO> getActiveFeeStructures() {
        return feeStructureRepository.findByIsActive(true).stream()
                .map(FeeStructureDTO::new)
                .collect(Collectors.toList());
    }
    
    public List<FeeStructureDTO> getFeeStructuresByCategory(Long feeCategoryId) {
        return feeStructureRepository.findByFeeCategoryIdAndActive(feeCategoryId).stream()
                .map(FeeStructureDTO::new)
                .collect(Collectors.toList());
    }
    
    public FeeStructureDTO createFeeStructure(FeeStructureDTO feeStructureDTO) {
        FeeStructure feeStructure = feeStructureDTO.toEntity();
        FeeStructure saved = feeStructureRepository.save(feeStructure);
        return new FeeStructureDTO(saved);
    }
    
    public FeeStructureDTO updateFeeStructure(Long id, FeeStructureDTO feeStructureDTO) {
        FeeStructure existingFeeStructure = feeStructureRepository.findById(id)
                .orElseThrow(() -> new FeeNotFoundException(id, "Fee Structure"));
        
        existingFeeStructure.setClassId(feeStructureDTO.getClassId());
        existingFeeStructure.setFeeCategoryId(feeStructureDTO.getFeeCategoryId());
        existingFeeStructure.setAcademicYearId(feeStructureDTO.getAcademicYearId());
        existingFeeStructure.setAmount(feeStructureDTO.getAmount());
        existingFeeStructure.setFrequency(feeStructureDTO.getFrequency());
        existingFeeStructure.setDueDate(feeStructureDTO.getDueDate());
        existingFeeStructure.setIsActive(feeStructureDTO.getIsActive());
        
        FeeStructure updated = feeStructureRepository.save(existingFeeStructure);
        return new FeeStructureDTO(updated);
    }
    
    public void deleteFeeStructure(Long id) {
        if (!feeStructureRepository.existsById(id)) {
            throw new FeeNotFoundException(id, "Fee Structure");
        }
        feeStructureRepository.deleteById(id);
    }
    
    // Student Fee methods
    public List<StudentFeeDTO> getAllStudentFees() {
        return studentFeeRepository.findAll().stream()
                .map(StudentFeeDTO::new)
                .collect(Collectors.toList());
    }
    
    public StudentFeeDTO getStudentFeeById(Long id) {
        StudentFee studentFee = studentFeeRepository.findById(id)
                .orElseThrow(() -> new FeeNotFoundException(id, "Student Fee"));
        return new StudentFeeDTO(studentFee);
    }
    
    public List<StudentFeeDTO> getStudentFeesByStudent(Long studentId) {
        return studentFeeRepository.findByStudentId(studentId).stream()
                .map(StudentFeeDTO::new)
                .collect(Collectors.toList());
    }
    
    public List<StudentFeeDTO> getStudentFeesByStudentAndYear(Long studentId, Long academicYearId) {
        return studentFeeRepository.findByStudentIdAndAcademicYearId(studentId, academicYearId).stream()
                .map(StudentFeeDTO::new)
                .collect(Collectors.toList());
    }
    
    public List<StudentFeeDTO> getPendingFeesByStudent(Long studentId) {
        return studentFeeRepository.findPendingFeesByStudent(studentId).stream()
                .map(StudentFeeDTO::new)
                .collect(Collectors.toList());
    }
    
    public List<StudentFeeDTO> getOverdueFeesByStudent(Long studentId) {
        return studentFeeRepository.findOverdueFeesByStudent(studentId).stream()
                .map(StudentFeeDTO::new)
                .collect(Collectors.toList());
    }
    
    public List<StudentFeeDTO> getOverdueFees() {
        return studentFeeRepository.findOverdueFees(LocalDate.now()).stream()
                .map(StudentFeeDTO::new)
                .collect(Collectors.toList());
    }
    
    public List<StudentFeeDTO> getFeesByStatus(StudentFee.Status status) {
        return studentFeeRepository.findByStatus(status).stream()
                .map(StudentFeeDTO::new)
                .collect(Collectors.toList());
    }
    
    public StudentFeeDTO createStudentFee(StudentFeeDTO studentFeeDTO) {
        StudentFee studentFee = studentFeeDTO.toEntity();
        StudentFee saved = studentFeeRepository.save(studentFee);
        return new StudentFeeDTO(saved);
    }
    
    public StudentFeeDTO updateStudentFee(Long id, StudentFeeDTO studentFeeDTO) {
        StudentFee existingStudentFee = studentFeeRepository.findById(id)
                .orElseThrow(() -> new FeeNotFoundException(id, "Student Fee"));
        
        existingStudentFee.setStudentId(studentFeeDTO.getStudentId());
        existingStudentFee.setFeeStructureId(studentFeeDTO.getFeeStructureId());
        existingStudentFee.setAcademicYearId(studentFeeDTO.getAcademicYearId());
        existingStudentFee.setAmount(studentFeeDTO.getAmount());
        existingStudentFee.setDiscountAmount(studentFeeDTO.getDiscountAmount());
        existingStudentFee.setDueDate(studentFeeDTO.getDueDate());
        existingStudentFee.setStatus(studentFeeDTO.getStatus());
        
        StudentFee updated = studentFeeRepository.save(existingStudentFee);
        return new StudentFeeDTO(updated);
    }
    
    public void deleteStudentFee(Long id) {
        if (!studentFeeRepository.existsById(id)) {
            throw new FeeNotFoundException(id, "Student Fee");
        }
        studentFeeRepository.deleteById(id);
    }
    
    // Business logic methods
    public void assignFeesToStudent(Long studentId, Long classId, Long academicYearId) {
        List<FeeStructure> feeStructures = feeStructureRepository.findByClassIdAndAcademicYearId(classId, academicYearId);
        
        for (FeeStructure feeStructure : feeStructures) {
            if (feeStructure.getIsActive()) {
                StudentFee studentFee = new StudentFee(
                    studentId,
                    feeStructure.getId(),
                    academicYearId,
                    feeStructure.getAmount(),
                    feeStructure.getDueDate()
                );
                studentFeeRepository.save(studentFee);
            }
        }
    }
    
    public void updateOverdueStatus() {
        List<StudentFee> pendingFees = studentFeeRepository.findByStatus(StudentFee.Status.PENDING);
        LocalDate today = LocalDate.now();
        
        for (StudentFee studentFee : pendingFees) {
            if (studentFee.getDueDate().isBefore(today)) {
                studentFee.setStatus(StudentFee.Status.OVERDUE);
                studentFeeRepository.save(studentFee);
            }
        }
    }
    
    public StudentFeeDTO applyDiscount(Long studentFeeId, BigDecimal discountAmount) {
        StudentFee studentFee = studentFeeRepository.findById(studentFeeId)
                .orElseThrow(() -> new FeeNotFoundException(studentFeeId, "Student Fee"));
        
        if (discountAmount.compareTo(studentFee.getAmount()) > 0) {
            throw new IllegalArgumentException("Discount amount cannot be greater than fee amount");
        }
        
        studentFee.setDiscountAmount(discountAmount);
        StudentFee updated = studentFeeRepository.save(studentFee);
        return new StudentFeeDTO(updated);
    }
    
    public StudentFeeDTO markAsPaid(Long studentFeeId) {
        StudentFee studentFee = studentFeeRepository.findById(studentFeeId)
                .orElseThrow(() -> new FeeNotFoundException(studentFeeId, "Student Fee"));
        
        studentFee.setStatus(StudentFee.Status.PAID);
        StudentFee updated = studentFeeRepository.save(studentFee);
        return new StudentFeeDTO(updated);
    }
    
    public StudentFeeDTO markAsPartial(Long studentFeeId) {
        StudentFee studentFee = studentFeeRepository.findById(studentFeeId)
                .orElseThrow(() -> new FeeNotFoundException(studentFeeId, "Student Fee"));
        
        studentFee.setStatus(StudentFee.Status.PARTIAL);
        StudentFee updated = studentFeeRepository.save(studentFee);
        return new StudentFeeDTO(updated);
    }
} 