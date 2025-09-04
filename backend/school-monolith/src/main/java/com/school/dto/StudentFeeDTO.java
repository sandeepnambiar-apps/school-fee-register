package com.school.dto;

import lombok.Data;

import javax.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class StudentFeeDTO {
    private Long id;

    @NotNull(message = "Student ID is required")
    private Long studentId;

    @NotNull(message = "Fee structure ID is required")
    private Long feeStructureId;

    private String studentName;
    private String feeName;
    private String className;
    private BigDecimal amount;
    private BigDecimal paidAmount;
    private BigDecimal pendingAmount;
    private LocalDate dueDate;
    private String status; // pending, paid, overdue
    private Long schoolId; // Multi-school support
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
