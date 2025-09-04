package com.school.controller;

import com.school.dto.FeeStructureDTO;
import com.school.dto.StudentFeeDTO;
import com.school.dto.PaymentDTO;
import com.school.service.FeeService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/fees")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class FeeController {

    private final FeeService feeService;

    // Fee Structure endpoints
    @GetMapping("/structures")
    public ResponseEntity<List<FeeStructureDTO>> getAllFeeStructures(@RequestParam(required = false) Long schoolId) {
        List<FeeStructureDTO> feeStructures = feeService.getAllFeeStructures(schoolId);
        return ResponseEntity.ok(feeStructures);
    }

    @GetMapping("/structures/{id}")
    public ResponseEntity<FeeStructureDTO> getFeeStructureById(@PathVariable Long id, @RequestParam(required = false) Long schoolId) {
        FeeStructureDTO feeStructure = feeService.getFeeStructureById(id, schoolId);
        return ResponseEntity.ok(feeStructure);
    }

    @PostMapping("/structures")
    public ResponseEntity<FeeStructureDTO> createFeeStructure(@RequestBody FeeStructureDTO feeStructureDTO) {
        FeeStructureDTO created = feeService.createFeeStructure(feeStructureDTO);
        return ResponseEntity.ok(created);
    }

    @PutMapping("/structures/{id}")
    public ResponseEntity<FeeStructureDTO> updateFeeStructure(@PathVariable Long id, @RequestBody FeeStructureDTO feeStructureDTO) {
        feeStructureDTO.setId(id);
        FeeStructureDTO updated = feeService.updateFeeStructure(feeStructureDTO);
        return ResponseEntity.ok(updated);
    }

    @DeleteMapping("/structures/{id}")
    public ResponseEntity<Void> deleteFeeStructure(@PathVariable Long id) {
        feeService.deleteFeeStructure(id);
        return ResponseEntity.noContent().build();
    }

    // Student Fee endpoints
    @GetMapping("/student-fees")
    public ResponseEntity<List<StudentFeeDTO>> getAllStudentFees(@RequestParam(required = false) Long schoolId) {
        List<StudentFeeDTO> studentFees = feeService.getAllStudentFees(schoolId);
        return ResponseEntity.ok(studentFees);
    }

    @GetMapping("/student-fees/{id}")
    public ResponseEntity<StudentFeeDTO> getStudentFeeById(@PathVariable Long id, @RequestParam(required = false) Long schoolId) {
        StudentFeeDTO studentFee = feeService.getStudentFeeById(id, schoolId);
        return ResponseEntity.ok(studentFee);
    }

    @PostMapping("/student-fees")
    public ResponseEntity<StudentFeeDTO> createStudentFee(@RequestBody StudentFeeDTO studentFeeDTO) {
        StudentFeeDTO created = feeService.createStudentFee(studentFeeDTO);
        return ResponseEntity.ok(created);
    }

    @PutMapping("/student-fees/{id}")
    public ResponseEntity<StudentFeeDTO> updateStudentFee(@PathVariable Long id, @RequestBody StudentFeeDTO studentFeeDTO) {
        studentFeeDTO.setId(id);
        StudentFeeDTO updated = feeService.updateStudentFee(studentFeeDTO);
        return ResponseEntity.ok(updated);
    }

    @DeleteMapping("/student-fees/{id}")
    public ResponseEntity<Void> deleteStudentFee(@PathVariable Long id) {
        feeService.deleteStudentFee(id);
        return ResponseEntity.noContent().build();
    }

    // Payment endpoints
    @GetMapping("/payments")
    public ResponseEntity<List<PaymentDTO>> getAllPayments(@RequestParam(required = false) Long schoolId) {
        List<PaymentDTO> payments = feeService.getAllPayments(schoolId);
        return ResponseEntity.ok(payments);
    }

    @GetMapping("/{id}")
    public ResponseEntity<PaymentDTO> getPaymentById(@PathVariable Long id, @RequestParam(required = false) Long schoolId) {
        PaymentDTO payment = feeService.getPaymentById(id, schoolId);
        return ResponseEntity.ok(payment);
    }

    @PostMapping("/payments")
    public ResponseEntity<PaymentDTO> createPayment(@RequestBody PaymentDTO paymentDTO) {
        PaymentDTO created = feeService.createPayment(paymentDTO);
        return ResponseEntity.ok(created);
    }

    @PutMapping("/payments/{id}")
    public ResponseEntity<PaymentDTO> updatePayment(@PathVariable Long id, @RequestBody PaymentDTO paymentDTO) {
        paymentDTO.setId(id);
        PaymentDTO updated = feeService.updatePayment(paymentDTO);
        return ResponseEntity.ok(updated);
    }

    @DeleteMapping("/payments/{id}")
    public ResponseEntity<Void> deletePayment(@PathVariable Long id) {
        feeService.deletePayment(id);
        return ResponseEntity.noContent().build();
    }

    // Additional fee-related endpoints
    @GetMapping("/student-fees/student/{studentId}")
    public ResponseEntity<List<StudentFeeDTO>> getFeesByStudentId(@PathVariable Long studentId, @RequestParam(required = false) Long schoolId) {
        List<StudentFeeDTO> fees = feeService.getFeesByStudentId(studentId, schoolId);
        return ResponseEntity.ok(fees);
    }

    @GetMapping("/payments/student/{studentId}")
    public ResponseEntity<List<PaymentDTO>> getPaymentsByStudentId(@PathVariable Long studentId, @RequestParam(required = false) Long schoolId) {
        List<PaymentDTO> payments = feeService.getPaymentsByStudentId(studentId, schoolId);
        return ResponseEntity.ok(payments);
    }

    @PostMapping("/process-payment")
    public ResponseEntity<PaymentDTO> processPayment(@RequestBody PaymentDTO paymentDTO) {
        PaymentDTO processed = feeService.processPayment(paymentDTO);
        return ResponseEntity.ok(processed);
    }
}
