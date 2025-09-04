package com.school.dto;

import lombok.Data;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Positive;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class PaymentDTO {
    private Long id;

    @NotNull(message = "Student fee ID is required")
    private Long studentFeeId;

    @NotNull(message = "Amount is required")
    @Positive(message = "Amount must be positive")
    private BigDecimal amount;

    private String paymentMethod; // cash, online, cheque
    private String transactionId;
    private String receiptNumber;
    private String status; // pending, completed, failed
    private String remarks;
    private LocalDateTime paymentDate;
    private Long schoolId; // Multi-school support
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
