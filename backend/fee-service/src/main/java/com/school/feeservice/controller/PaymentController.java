package com.school.feeservice.controller;

import com.school.feeservice.dto.PaymentRequest;
import com.school.feeservice.dto.PaymentResponse;
import com.school.feeservice.model.Payment;
import com.school.feeservice.service.PaymentService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import jakarta.validation.Valid;
import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/api/payments")
@RequiredArgsConstructor
@Slf4j
@CrossOrigin(origins = "*")
public class PaymentController {
    
    private final PaymentService paymentService;
    
    @PostMapping
    public ResponseEntity<PaymentResponse> processPayment(@Valid @RequestBody PaymentRequest paymentRequest) {
        log.info("Received payment request for student: {}", paymentRequest.getStudentId());
        PaymentResponse response = paymentService.processPayment(paymentRequest);
        
        if (response.isSuccess()) {
            return ResponseEntity.status(HttpStatus.CREATED).body(response);
        } else {
            return ResponseEntity.badRequest().body(response);
        }
    }
    
    @GetMapping("/{paymentId}")
    public ResponseEntity<PaymentResponse> getPaymentById(@PathVariable Long paymentId) {
        log.info("Fetching payment with ID: {}", paymentId);
        PaymentResponse response = paymentService.getPaymentById(paymentId);
        
        if (response.isSuccess()) {
            return ResponseEntity.ok(response);
        } else {
            return ResponseEntity.notFound().build();
        }
    }
    
    @GetMapping("/transaction/{transactionId}")
    public ResponseEntity<PaymentResponse> getPaymentByTransactionId(@PathVariable String transactionId) {
        log.info("Fetching payment with transaction ID: {}", transactionId);
        PaymentResponse response = paymentService.getPaymentByTransactionId(transactionId);
        
        if (response.isSuccess()) {
            return ResponseEntity.ok(response);
        } else {
            return ResponseEntity.notFound().build();
        }
    }
    
    @GetMapping("/receipt/{receiptNumber}")
    public ResponseEntity<PaymentResponse> getPaymentByReceiptNumber(@PathVariable String receiptNumber) {
        log.info("Fetching payment with receipt number: {}", receiptNumber);
        PaymentResponse response = paymentService.getPaymentByReceiptNumber(receiptNumber);
        
        if (response.isSuccess()) {
            return ResponseEntity.ok(response);
        } else {
            return ResponseEntity.notFound().build();
        }
    }
    
    @GetMapping("/student/{studentId}")
    public ResponseEntity<List<PaymentResponse>> getPaymentsByStudentId(@PathVariable Long studentId) {
        log.info("Fetching payments for student: {}", studentId);
        List<PaymentResponse> payments = paymentService.getPaymentsByStudentId(studentId);
        return ResponseEntity.ok(payments);
    }
    
    @GetMapping("/status/{status}")
    public ResponseEntity<List<PaymentResponse>> getPaymentsByStatus(@PathVariable Payment.PaymentStatus status) {
        log.info("Fetching payments with status: {}", status);
        List<PaymentResponse> payments = paymentService.getPaymentsByStatus(status);
        return ResponseEntity.ok(payments);
    }
    
    @GetMapping("/date-range")
    public ResponseEntity<List<PaymentResponse>> getPaymentsByDateRange(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime startDate,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime endDate) {
        log.info("Fetching payments between {} and {}", startDate, endDate);
        List<PaymentResponse> payments = paymentService.getPaymentsByDateRange(startDate, endDate);
        return ResponseEntity.ok(payments);
    }
    
    @GetMapping("/overdue")
    public ResponseEntity<List<PaymentResponse>> getOverduePayments() {
        log.info("Fetching overdue payments");
        List<PaymentResponse> payments = paymentService.getOverduePayments();
        return ResponseEntity.ok(payments);
    }
    
    @PutMapping("/{paymentId}/status")
    public ResponseEntity<PaymentResponse> updatePaymentStatus(
            @PathVariable Long paymentId,
            @RequestParam Payment.PaymentStatus status) {
        log.info("Updating payment {} status to: {}", paymentId, status);
        PaymentResponse response = paymentService.updatePaymentStatus(paymentId, status);
        
        if (response.isSuccess()) {
            return ResponseEntity.ok(response);
        } else {
            return ResponseEntity.notFound().build();
        }
    }
    
    @PostMapping("/{paymentId}/refund")
    public ResponseEntity<PaymentResponse> refundPayment(
            @PathVariable Long paymentId,
            @RequestParam String reason) {
        log.info("Processing refund for payment: {} with reason: {}", paymentId, reason);
        PaymentResponse response = paymentService.refundPayment(paymentId, reason);
        
        if (response.isSuccess()) {
            return ResponseEntity.ok(response);
        } else {
            return ResponseEntity.notFound().build();
        }
    }
    
    @DeleteMapping("/{paymentId}")
    public ResponseEntity<Void> deletePayment(@PathVariable Long paymentId) {
        log.info("Deleting payment: {}", paymentId);
        paymentService.deletePayment(paymentId);
        return ResponseEntity.noContent().build();
    }
    
    @GetMapping("/stats/count")
    public ResponseEntity<Long> getTotalPaymentsCount() {
        log.info("Fetching total payments count");
        Long count = paymentService.getTotalPaymentsCount();
        return ResponseEntity.ok(count);
    }
    
    @GetMapping("/stats/amount")
    public ResponseEntity<Double> getTotalPaymentsAmount() {
        log.info("Fetching total payments amount");
        Double amount = paymentService.getTotalPaymentsAmount();
        return ResponseEntity.ok(amount);
    }
    
    @GetMapping("/stats/student/{studentId}/count")
    public ResponseEntity<Long> getCompletedPaymentsCountByStudent(@PathVariable Long studentId) {
        log.info("Fetching completed payments count for student: {}", studentId);
        Long count = paymentService.getCompletedPaymentsCountByStudent(studentId);
        return ResponseEntity.ok(count);
    }
    
    @GetMapping("/stats/student/{studentId}/amount")
    public ResponseEntity<Double> getTotalPaidAmountByStudent(@PathVariable Long studentId) {
        log.info("Fetching total paid amount for student: {}", studentId);
        Double amount = paymentService.getTotalPaidAmountByStudent(studentId);
        return ResponseEntity.ok(amount);
    }
    
    @GetMapping("/health")
    public ResponseEntity<String> health() {
        return ResponseEntity.ok("Payment Service is running!");
    }
} 