package com.school.studentservice.controller;

import com.school.studentservice.dto.FeeDTO;
import com.school.studentservice.service.FeeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/fees")
@CrossOrigin(origins = "*")
public class FeeController {
    
    @Autowired
    private FeeService feeService;
    
    // Get all fees
    @GetMapping
    public ResponseEntity<List<FeeDTO>> getAllFees() {
        try {
            List<FeeDTO> fees = feeService.getAllFees();
            return ResponseEntity.ok(fees);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    // Get fee by ID
    @GetMapping("/{id}")
    public ResponseEntity<FeeDTO> getFeeById(@PathVariable Long id) {
        try {
            FeeDTO fee = feeService.getFeeById(id);
            return ResponseEntity.ok(fee);
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    // Get fees by student ID
    @GetMapping("/student/{studentId}")
    public ResponseEntity<List<FeeDTO>> getFeesByStudentId(@PathVariable Long studentId) {
        try {
            List<FeeDTO> fees = feeService.getFeesByStudentId(studentId);
            return ResponseEntity.ok(fees);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    // Get fees by parent ID (for their children)
    @GetMapping("/parent/{parentId}")
    public ResponseEntity<List<FeeDTO>> getFeesByParentId(@PathVariable Long parentId) {
        try {
            List<FeeDTO> fees = feeService.getFeesByParentId(parentId);
            return ResponseEntity.ok(fees);
        } catch (UnsupportedOperationException e) {
            // Return empty list since parent-student relationship is not properly implemented
            return ResponseEntity.ok(List.of());
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    // Get fees by parent email (for their children)
    @GetMapping("/parent/email/{parentEmail}")
    public ResponseEntity<List<FeeDTO>> getFeesByParentEmail(@PathVariable String parentEmail) {
        try {
            List<FeeDTO> fees = feeService.getFeesByParentEmail(parentEmail);
            return ResponseEntity.ok(fees);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    // Get fees by class ID
    @GetMapping("/class/{classId}")
    public ResponseEntity<List<FeeDTO>> getFeesByClassId(@PathVariable Long classId) {
        try {
            List<FeeDTO> fees = feeService.getFeesByClassId(classId);
            return ResponseEntity.ok(fees);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    // Get fees by fee type
    @GetMapping("/type/{feeType}")
    public ResponseEntity<List<FeeDTO>> getFeesByFeeType(@PathVariable String feeType) {
        try {
            List<FeeDTO> fees = feeService.getFeesByFeeType(
                com.school.studentservice.model.Fee.FeeType.valueOf(feeType.toUpperCase())
            );
            return ResponseEntity.ok(fees);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    // Get fees by status
    @GetMapping("/status/{status}")
    public ResponseEntity<List<FeeDTO>> getFeesByStatus(@PathVariable String status) {
        try {
            List<FeeDTO> fees = feeService.getFeesByStatus(
                com.school.studentservice.model.Fee.FeeStatus.valueOf(status.toUpperCase())
            );
            return ResponseEntity.ok(fees);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    // Get overdue fees
    @GetMapping("/overdue")
    public ResponseEntity<List<FeeDTO>> getOverdueFees() {
        try {
            List<FeeDTO> fees = feeService.getOverdueFees();
            return ResponseEntity.ok(fees);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    // Get pending fees
    @GetMapping("/pending")
    public ResponseEntity<List<FeeDTO>> getPendingFees() {
        try {
            List<FeeDTO> fees = feeService.getPendingFees();
            return ResponseEntity.ok(fees);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    // Get partial paid fees
    @GetMapping("/partial")
    public ResponseEntity<List<FeeDTO>> getPartialPaidFees() {
        try {
            List<FeeDTO> fees = feeService.getPartialPaidFees();
            return ResponseEntity.ok(fees);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    // Create new fee
    @PostMapping
    public ResponseEntity<FeeDTO> createFee(@RequestBody FeeDTO feeDTO) {
        try {
            FeeDTO createdFee = feeService.createFee(feeDTO);
            return ResponseEntity.ok(createdFee);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    // Update fee
    @PutMapping("/{id}")
    public ResponseEntity<FeeDTO> updateFee(@PathVariable Long id, @RequestBody FeeDTO feeDTO) {
        try {
            FeeDTO updatedFee = feeService.updateFee(id, feeDTO);
            return ResponseEntity.ok(updatedFee);
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    // Delete fee
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteFee(@PathVariable Long id) {
        try {
            feeService.deleteFee(id);
            return ResponseEntity.ok().build();
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    // Get total fees amount by student
    @GetMapping("/student/{studentId}/total")
    public ResponseEntity<Double> getTotalFeesAmountByStudent(@PathVariable Long studentId) {
        try {
            Double totalAmount = feeService.getTotalFeesAmountByStudent(studentId);
            return ResponseEntity.ok(totalAmount != null ? totalAmount : 0.0);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    // Get total paid amount by student
    @GetMapping("/student/{studentId}/paid")
    public ResponseEntity<Double> getTotalPaidAmountByStudent(@PathVariable Long studentId) {
        try {
            Double paidAmount = feeService.getTotalPaidAmountByStudent(studentId);
            return ResponseEntity.ok(paidAmount != null ? paidAmount : 0.0);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
} 