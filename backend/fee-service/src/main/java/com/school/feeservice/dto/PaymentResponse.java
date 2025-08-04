package com.school.feeservice.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PaymentResponse {
    
    private Long paymentId;
    private String transactionId;
    private String receiptNumber;
    private Long studentId;
    private Long feeStructureId;
    private BigDecimal amount;
    private PaymentMethod paymentMethod;
    private PaymentStatus status;
    private LocalDateTime paymentDate;
    private LocalDateTime dueDate;
    private BigDecimal discountAmount;
    private BigDecimal lateFeeAmount;
    private String notes;
    private String message;
    private boolean success;
    
    public enum PaymentMethod {
        CASH, CARD, ONLINE, BANK_TRANSFER, CHEQUE
    }
    
    public enum PaymentStatus {
        PENDING, COMPLETED, FAILED, CANCELLED, REFUNDED
    }
} 