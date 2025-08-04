package com.school.feeservice.controller;

import com.school.feeservice.dto.FeeStructureDTO;
import com.school.feeservice.dto.StudentFeeDTO;
import com.school.feeservice.model.StudentFee;
import com.school.feeservice.service.FeeService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.List;

@RestController
@RequestMapping("/api/fees")
@CrossOrigin(origins = "*")
public class FeeController {
    
    @Autowired
    private FeeService feeService;
    
    // Fee Structure endpoints
    @GetMapping("/structures")
    public ResponseEntity<List<FeeStructureDTO>> getAllFeeStructures() {
        List<FeeStructureDTO> feeStructures = feeService.getAllFeeStructures();
        return ResponseEntity.ok(feeStructures);
    }
    
    @GetMapping("/structures/active")
    public ResponseEntity<List<FeeStructureDTO>> getActiveFeeStructures() {
        List<FeeStructureDTO> feeStructures = feeService.getActiveFeeStructures();
        return ResponseEntity.ok(feeStructures);
    }
    
    @GetMapping("/structures/{id}")
    public ResponseEntity<FeeStructureDTO> getFeeStructureById(@PathVariable Long id) {
        FeeStructureDTO feeStructure = feeService.getFeeStructureById(id);
        return ResponseEntity.ok(feeStructure);
    }
    
    @GetMapping("/structures/class/{classId}")
    public ResponseEntity<List<FeeStructureDTO>> getFeeStructuresByClass(@PathVariable Long classId) {
        List<FeeStructureDTO> feeStructures = feeService.getFeeStructuresByClass(classId);
        return ResponseEntity.ok(feeStructures);
    }
    
    @GetMapping("/structures/class/{classId}/year/{academicYearId}")
    public ResponseEntity<List<FeeStructureDTO>> getFeeStructuresByClassAndYear(@PathVariable Long classId, 
                                                                               @PathVariable Long academicYearId) {
        List<FeeStructureDTO> feeStructures = feeService.getFeeStructuresByClassAndYear(classId, academicYearId);
        return ResponseEntity.ok(feeStructures);
    }
    
    @GetMapping("/structures/category/{feeCategoryId}")
    public ResponseEntity<List<FeeStructureDTO>> getFeeStructuresByCategory(@PathVariable Long feeCategoryId) {
        List<FeeStructureDTO> feeStructures = feeService.getFeeStructuresByCategory(feeCategoryId);
        return ResponseEntity.ok(feeStructures);
    }
    
    @PostMapping("/structures")
    public ResponseEntity<FeeStructureDTO> createFeeStructure(@Valid @RequestBody FeeStructureDTO feeStructureDTO) {
        try {
            FeeStructureDTO created = feeService.createFeeStructure(feeStructureDTO);
            return ResponseEntity.status(HttpStatus.CREATED).body(created);
        } catch (Exception e) {
            // Log the error for debugging
            System.err.println("Error creating fee structure: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }
    
    @PutMapping("/structures/{id}")
    public ResponseEntity<FeeStructureDTO> updateFeeStructure(@PathVariable Long id, 
                                                             @Valid @RequestBody FeeStructureDTO feeStructureDTO) {
        FeeStructureDTO updated = feeService.updateFeeStructure(id, feeStructureDTO);
        return ResponseEntity.ok(updated);
    }
    
    @DeleteMapping("/structures/{id}")
    public ResponseEntity<Void> deleteFeeStructure(@PathVariable Long id) {
        feeService.deleteFeeStructure(id);
        return ResponseEntity.noContent().build();
    }
    
    // Student Fee endpoints
    @GetMapping("/student-fees")
    public ResponseEntity<List<StudentFeeDTO>> getAllStudentFees() {
        List<StudentFeeDTO> studentFees = feeService.getAllStudentFees();
        return ResponseEntity.ok(studentFees);
    }
    
    @GetMapping("/student-fees/{id}")
    public ResponseEntity<StudentFeeDTO> getStudentFeeById(@PathVariable Long id) {
        StudentFeeDTO studentFee = feeService.getStudentFeeById(id);
        return ResponseEntity.ok(studentFee);
    }
    
    @GetMapping("/student-fees/student/{studentId}")
    public ResponseEntity<List<StudentFeeDTO>> getStudentFeesByStudent(@PathVariable Long studentId) {
        List<StudentFeeDTO> studentFees = feeService.getStudentFeesByStudent(studentId);
        return ResponseEntity.ok(studentFees);
    }
    
    @GetMapping("/student-fees/student/{studentId}/year/{academicYearId}")
    public ResponseEntity<List<StudentFeeDTO>> getStudentFeesByStudentAndYear(@PathVariable Long studentId, 
                                                                              @PathVariable Long academicYearId) {
        List<StudentFeeDTO> studentFees = feeService.getStudentFeesByStudentAndYear(studentId, academicYearId);
        return ResponseEntity.ok(studentFees);
    }
    
    @GetMapping("/student-fees/student/{studentId}/pending")
    public ResponseEntity<List<StudentFeeDTO>> getPendingFeesByStudent(@PathVariable Long studentId) {
        List<StudentFeeDTO> studentFees = feeService.getPendingFeesByStudent(studentId);
        return ResponseEntity.ok(studentFees);
    }
    
    @GetMapping("/student-fees/student/{studentId}/overdue")
    public ResponseEntity<List<StudentFeeDTO>> getOverdueFeesByStudent(@PathVariable Long studentId) {
        List<StudentFeeDTO> studentFees = feeService.getOverdueFeesByStudent(studentId);
        return ResponseEntity.ok(studentFees);
    }
    
    @GetMapping("/student-fees/overdue")
    public ResponseEntity<List<StudentFeeDTO>> getOverdueFees() {
        List<StudentFeeDTO> studentFees = feeService.getOverdueFees();
        return ResponseEntity.ok(studentFees);
    }
    
    @GetMapping("/student-fees/status/{status}")
    public ResponseEntity<List<StudentFeeDTO>> getFeesByStatus(@PathVariable StudentFee.Status status) {
        List<StudentFeeDTO> studentFees = feeService.getFeesByStatus(status);
        return ResponseEntity.ok(studentFees);
    }
    
    @PostMapping("/student-fees")
    public ResponseEntity<StudentFeeDTO> createStudentFee(@Valid @RequestBody StudentFeeDTO studentFeeDTO) {
        StudentFeeDTO created = feeService.createStudentFee(studentFeeDTO);
        return ResponseEntity.status(HttpStatus.CREATED).body(created);
    }
    
    @PutMapping("/student-fees/{id}")
    public ResponseEntity<StudentFeeDTO> updateStudentFee(@PathVariable Long id, 
                                                         @Valid @RequestBody StudentFeeDTO studentFeeDTO) {
        StudentFeeDTO updated = feeService.updateStudentFee(id, studentFeeDTO);
        return ResponseEntity.ok(updated);
    }
    
    @DeleteMapping("/student-fees/{id}")
    public ResponseEntity<Void> deleteStudentFee(@PathVariable Long id) {
        feeService.deleteStudentFee(id);
        return ResponseEntity.noContent().build();
    }
    
    // Business logic endpoints
    @PostMapping("/assign/{studentId}/class/{classId}/year/{academicYearId}")
    public ResponseEntity<Void> assignFeesToStudent(@PathVariable Long studentId, 
                                                  @PathVariable Long classId, 
                                                  @PathVariable Long academicYearId) {
        feeService.assignFeesToStudent(studentId, classId, academicYearId);
        return ResponseEntity.ok().build();
    }
    
    @PostMapping("/update-overdue")
    public ResponseEntity<Void> updateOverdueStatus() {
        feeService.updateOverdueStatus();
        return ResponseEntity.ok().build();
    }
    
    @PatchMapping("/student-fees/{id}/apply-discount")
    public ResponseEntity<StudentFeeDTO> applyDiscount(@PathVariable Long id, 
                                                      @RequestParam BigDecimal discountAmount) {
        StudentFeeDTO updated = feeService.applyDiscount(id, discountAmount);
        return ResponseEntity.ok(updated);
    }
    
    @PatchMapping("/student-fees/{id}/mark-paid")
    public ResponseEntity<StudentFeeDTO> markAsPaid(@PathVariable Long id) {
        StudentFeeDTO updated = feeService.markAsPaid(id);
        return ResponseEntity.ok(updated);
    }
    
    @PatchMapping("/student-fees/{id}/mark-partial")
    public ResponseEntity<StudentFeeDTO> markAsPartial(@PathVariable Long id) {
        StudentFeeDTO updated = feeService.markAsPartial(id);
        return ResponseEntity.ok(updated);
    }
    
    // Health check endpoint
    @GetMapping("/health")
    public ResponseEntity<String> health() {
        return ResponseEntity.ok("Fee Service is running");
    }
} 