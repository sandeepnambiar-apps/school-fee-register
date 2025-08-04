package com.school.feeservice.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Min;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class PaymentRequest {
    
    @NotNull(message = "Student ID is required")
    @Min(value = 1, message = "Student ID must be greater than 0")
    private Long studentId;
    
    @NotNull(message = "Fee structure ID is required")
    @Min(value = 1, message = "Fee structure ID must be greater than 0")
    private Long feeStructureId;
    
    @NotNull(message = "Amount is required")
    @DecimalMin(value = "0.01", message = "Amount must be greater than 0")
    private BigDecimal amount;
    
    @NotNull(message = "Payment method is required")
    private PaymentMethod paymentMethod;
    
    private LocalDateTime dueDate;
    
    private BigDecimal discountAmount;
    
    private String notes;
    
    public enum PaymentMethod {
        CASH, CARD, ONLINE, BANK_TRANSFER, CHEQUE
    }
} 