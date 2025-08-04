package com.school.feeservice.service;

import com.school.feeservice.dto.PaymentRequest;
import com.school.feeservice.dto.PaymentResponse;
import com.school.feeservice.model.Payment;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public interface PaymentService {
    
    PaymentResponse processPayment(PaymentRequest paymentRequest);
    
    PaymentResponse getPaymentById(Long paymentId);
    
    PaymentResponse getPaymentByTransactionId(String transactionId);
    
    PaymentResponse getPaymentByReceiptNumber(String receiptNumber);
    
    List<PaymentResponse> getPaymentsByStudentId(Long studentId);
    
    List<PaymentResponse> getPaymentsByStatus(Payment.PaymentStatus status);
    
    List<PaymentResponse> getPaymentsByDateRange(LocalDateTime startDate, LocalDateTime endDate);
    
    List<PaymentResponse> getOverduePayments();
    
    PaymentResponse updatePaymentStatus(Long paymentId, Payment.PaymentStatus status);
    
    PaymentResponse refundPayment(Long paymentId, String reason);
    
    void deletePayment(Long paymentId);
    
    Long getTotalPaymentsCount();
    
    Double getTotalPaymentsAmount();
    
    Long getCompletedPaymentsCountByStudent(Long studentId);
    
    Double getTotalPaidAmountByStudent(Long studentId);
} 