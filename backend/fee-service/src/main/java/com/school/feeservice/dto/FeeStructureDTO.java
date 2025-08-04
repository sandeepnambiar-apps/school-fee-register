package com.school.feeservice.dto;

import com.school.feeservice.model.FeeStructure;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import java.math.BigDecimal;
import java.time.LocalDate;

public class FeeStructureDTO {
    
    private Long id;
    
    @NotNull(message = "Class ID is required")
    private Long classId;
    
    @NotNull(message = "Fee category ID is required")
    private Long feeCategoryId;
    
    @NotNull(message = "Academic year ID is required")
    private Long academicYearId;
    
    @NotNull(message = "Amount is required")
    @Positive(message = "Amount must be positive")
    private BigDecimal amount;
    
    private FeeStructure.Frequency frequency;
    
    private LocalDate dueDate;
    
    private Boolean isActive = true;
    
    // Constructors
    public FeeStructureDTO() {}
    
    public FeeStructureDTO(FeeStructure feeStructure) {
        this.id = feeStructure.getId();
        this.classId = feeStructure.getClassId();
        this.feeCategoryId = feeStructure.getFeeCategoryId();
        this.academicYearId = feeStructure.getAcademicYearId();
        this.amount = feeStructure.getAmount();
        this.frequency = feeStructure.getFrequency();
        this.dueDate = feeStructure.getDueDate();
        this.isActive = feeStructure.getIsActive();
    }
    
    // Convert to Entity
    public FeeStructure toEntity() {
        FeeStructure feeStructure = new FeeStructure();
        feeStructure.setId(this.id);
        feeStructure.setClassId(this.classId);
        feeStructure.setFeeCategoryId(this.feeCategoryId);
        feeStructure.setAcademicYearId(this.academicYearId);
        feeStructure.setAmount(this.amount);
        feeStructure.setFrequency(this.frequency);
        feeStructure.setDueDate(this.dueDate);
        feeStructure.setIsActive(this.isActive);
        return feeStructure;
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public Long getClassId() {
        return classId;
    }
    
    public void setClassId(Long classId) {
        this.classId = classId;
    }
    
    public Long getFeeCategoryId() {
        return feeCategoryId;
    }
    
    public void setFeeCategoryId(Long feeCategoryId) {
        this.feeCategoryId = feeCategoryId;
    }
    
    public Long getAcademicYearId() {
        return academicYearId;
    }
    
    public void setAcademicYearId(Long academicYearId) {
        this.academicYearId = academicYearId;
    }
    
    public BigDecimal getAmount() {
        return amount;
    }
    
    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }
    
    public FeeStructure.Frequency getFrequency() {
        return frequency;
    }
    
    public void setFrequency(FeeStructure.Frequency frequency) {
        this.frequency = frequency;
    }
    
    public LocalDate getDueDate() {
        return dueDate;
    }
    
    public void setDueDate(LocalDate dueDate) {
        this.dueDate = dueDate;
    }
    
    public Boolean getIsActive() {
        return isActive;
    }
    
    public void setIsActive(Boolean isActive) {
        this.isActive = isActive;
    }
} 