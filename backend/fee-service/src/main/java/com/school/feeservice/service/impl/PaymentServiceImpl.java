package com.school.feeservice.service.impl;

import com.school.feeservice.dto.PaymentRequest;
import com.school.feeservice.dto.PaymentResponse;
import com.school.feeservice.model.Payment;
import com.school.feeservice.repository.PaymentRepository;
import com.school.feeservice.service.PaymentService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
@Transactional
public class PaymentServiceImpl implements PaymentService {
    
    private final PaymentRepository paymentRepository;
    
    @Override
    public PaymentResponse processPayment(PaymentRequest paymentRequest) {
        try {
            log.info("Processing payment for student: {}", paymentRequest.getStudentId());
            
            // Generate unique transaction ID and receipt number
            String transactionId = generateTransactionId();
            String receiptNumber = generateReceiptNumber();
            
            // Calculate late fee if payment is overdue
            BigDecimal lateFeeAmount = calculateLateFee(paymentRequest);
            
            // Create payment entity
            Payment payment = new Payment();
            payment.setStudentId(paymentRequest.getStudentId());
            payment.setFeeStructureId(paymentRequest.getFeeStructureId());
            payment.setAmount(paymentRequest.getAmount());
            payment.setPaymentMethod(Payment.PaymentMethod.valueOf(paymentRequest.getPaymentMethod().name()));
            payment.setStatus(Payment.PaymentStatus.COMPLETED); // Assuming immediate completion for now
            payment.setTransactionId(transactionId);
            payment.setReceiptNumber(receiptNumber);
            payment.setDueDate(paymentRequest.getDueDate());
            payment.setDiscountAmount(paymentRequest.getDiscountAmount() != null ? 
                paymentRequest.getDiscountAmount() : BigDecimal.ZERO);
            payment.setLateFeeAmount(lateFeeAmount);
            payment.setNotes(paymentRequest.getNotes());
            
            // Save payment
            Payment savedPayment = paymentRepository.save(payment);
            
            log.info("Payment processed successfully. Transaction ID: {}", transactionId);
            
            return buildPaymentResponse(savedPayment, "Payment processed successfully", true);
            
        } catch (Exception e) {
            log.error("Error processing payment: {}", e.getMessage(), e);
            return PaymentResponse.builder()
                .success(false)
                .message("Failed to process payment: " + e.getMessage())
                .build();
        }
    }
    
    @Override
    @Transactional(readOnly = true)
    public PaymentResponse getPaymentById(Long paymentId) {
        Optional<Payment> payment = paymentRepository.findById(paymentId);
        return payment.map(p -> buildPaymentResponse(p, "Payment found", true))
                     .orElse(PaymentResponse.builder()
                         .success(false)
                         .message("Payment not found")
                         .build());
    }
    
    @Override
    @Transactional(readOnly = true)
    public PaymentResponse getPaymentByTransactionId(String transactionId) {
        Optional<Payment> payment = paymentRepository.findByTransactionId(transactionId);
        return payment.map(p -> buildPaymentResponse(p, "Payment found", true))
                     .orElse(PaymentResponse.builder()
                         .success(false)
                         .message("Payment not found")
                         .build());
    }
    
    @Override
    @Transactional(readOnly = true)
    public PaymentResponse getPaymentByReceiptNumber(String receiptNumber) {
        Optional<Payment> payment = paymentRepository.findByReceiptNumber(receiptNumber);
        return payment.map(p -> buildPaymentResponse(p, "Payment found", true))
                     .orElse(PaymentResponse.builder()
                         .success(false)
                         .message("Payment not found")
                         .build());
    }
    
    @Override
    @Transactional(readOnly = true)
    public List<PaymentResponse> getPaymentsByStudentId(Long studentId) {
        List<Payment> payments = paymentRepository.findByStudentId(studentId);
        return payments.stream()
                .map(payment -> buildPaymentResponse(payment, "Payment found", true))
                .collect(Collectors.toList());
    }
    
    @Override
    @Transactional(readOnly = true)
    public List<PaymentResponse> getPaymentsByStatus(Payment.PaymentStatus status) {
        List<Payment> payments = paymentRepository.findByStatus(status);
        return payments.stream()
                .map(payment -> buildPaymentResponse(payment, "Payment found", true))
                .collect(Collectors.toList());
    }
    
    @Override
    @Transactional(readOnly = true)
    public List<PaymentResponse> getPaymentsByDateRange(LocalDateTime startDate, LocalDateTime endDate) {
        List<Payment> payments = paymentRepository.findByDateRange(startDate, endDate);
        return payments.stream()
                .map(payment -> buildPaymentResponse(payment, "Payment found", true))
                .collect(Collectors.toList());
    }
    
    @Override
    @Transactional(readOnly = true)
    public List<PaymentResponse> getOverduePayments() {
        List<Payment> payments = paymentRepository.findOverduePayments(LocalDateTime.now());
        return payments.stream()
                .map(payment -> buildPaymentResponse(payment, "Overdue payment found", true))
                .collect(Collectors.toList());
    }
    
    @Override
    public PaymentResponse updatePaymentStatus(Long paymentId, Payment.PaymentStatus status) {
        Optional<Payment> paymentOpt = paymentRepository.findById(paymentId);
        if (paymentOpt.isPresent()) {
            Payment payment = paymentOpt.get();
            payment.setStatus(status);
            Payment updatedPayment = paymentRepository.save(payment);
            return buildPaymentResponse(updatedPayment, "Payment status updated successfully", true);
        }
        return PaymentResponse.builder()
            .success(false)
            .message("Payment not found")
            .build();
    }
    
    @Override
    public PaymentResponse refundPayment(Long paymentId, String reason) {
        Optional<Payment> paymentOpt = paymentRepository.findById(paymentId);
        if (paymentOpt.isPresent()) {
            Payment payment = paymentOpt.get();
            payment.setStatus(Payment.PaymentStatus.REFUNDED);
            payment.setNotes(payment.getNotes() + " | Refunded: " + reason);
            Payment updatedPayment = paymentRepository.save(payment);
            return buildPaymentResponse(updatedPayment, "Payment refunded successfully", true);
        }
        return PaymentResponse.builder()
            .success(false)
            .message("Payment not found")
            .build();
    }
    
    @Override
    public void deletePayment(Long paymentId) {
        paymentRepository.deleteById(paymentId);
    }
    
    @Override
    @Transactional(readOnly = true)
    public Long getTotalPaymentsCount() {
        return paymentRepository.count();
    }
    
    @Override
    @Transactional(readOnly = true)
    public Double getTotalPaymentsAmount() {
        return paymentRepository.findAll().stream()
                .filter(p -> p.getStatus() == Payment.PaymentStatus.COMPLETED)
                .mapToDouble(p -> p.getAmount().doubleValue())
                .sum();
    }
    
    @Override
    @Transactional(readOnly = true)
    public Long getCompletedPaymentsCountByStudent(Long studentId) {
        return paymentRepository.countCompletedPaymentsByStudent(studentId);
    }
    
    @Override
    @Transactional(readOnly = true)
    public Double getTotalPaidAmountByStudent(Long studentId) {
        return paymentRepository.getTotalPaidAmountByStudent(studentId);
    }
    
    private String generateTransactionId() {
        return "TXN" + System.currentTimeMillis() + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
    }
    
    private String generateReceiptNumber() {
        return "RCP" + LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
    }
    
    private BigDecimal calculateLateFee(PaymentRequest paymentRequest) {
        if (paymentRequest.getDueDate() != null && LocalDateTime.now().isAfter(paymentRequest.getDueDate())) {
            // Calculate 5% late fee for overdue payments
            return paymentRequest.getAmount().multiply(new BigDecimal("0.05"));
        }
        return BigDecimal.ZERO;
    }
    
    private PaymentResponse buildPaymentResponse(Payment payment, String message, boolean success) {
        return PaymentResponse.builder()
                .paymentId(payment.getId())
                .transactionId(payment.getTransactionId())
                .receiptNumber(payment.getReceiptNumber())
                .studentId(payment.getStudentId())
                .feeStructureId(payment.getFeeStructureId())
                .amount(payment.getAmount())
                .paymentMethod(PaymentResponse.PaymentMethod.valueOf(payment.getPaymentMethod().name()))
                .status(PaymentResponse.PaymentStatus.valueOf(payment.getStatus().name()))
                .paymentDate(payment.getPaymentDate())
                .dueDate(payment.getDueDate())
                .discountAmount(payment.getDiscountAmount())
                .lateFeeAmount(payment.getLateFeeAmount())
                .notes(payment.getNotes())
                .message(message)
                .success(success)
                .build();
    }
} 