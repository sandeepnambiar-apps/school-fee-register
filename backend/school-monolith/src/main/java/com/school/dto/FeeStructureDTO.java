package com.school.dto;

import lombok.Data;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Positive;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class FeeStructureDTO {
    private Long id;

    @NotBlank(message = "Fee name is required")
    private String feeName;

    @NotBlank(message = "Class is required")
    private String className;

    @NotNull(message = "Amount is required")
    @Positive(message = "Amount must be positive")
    private BigDecimal amount;

    private String description;
    private String frequency; // monthly, quarterly, yearly
    private String academicYear;
    private String status;
    private Long schoolId; // Multi-school support
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
