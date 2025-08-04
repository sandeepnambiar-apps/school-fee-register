package com.school.feeservice.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "fee_structures")
public class FeeStructure {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "class_id")
    private Long classId;
    
    @Column(name = "fee_category_id")
    private Long feeCategoryId;
    
    @Column(name = "academic_year_id")
    private Long academicYearId;
    
    @NotNull
    @Positive
    private BigDecimal amount;
    
    @Enumerated(EnumType.STRING)
    private Frequency frequency;
    
    @Column(name = "due_date")
    private LocalDate dueDate;
    
    @Column(name = "is_active")
    private Boolean isActive = true;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    public enum Frequency {
        MONTHLY, QUARTERLY, SEMESTER, ANNUAL
    }
    
    // Constructors
    public FeeStructure() {}
    
    public FeeStructure(Long classId, Long feeCategoryId, Long academicYearId, BigDecimal amount, Frequency frequency) {
        this.classId = classId;
        this.feeCategoryId = feeCategoryId;
        this.academicYearId = academicYearId;
        this.amount = amount;
        this.frequency = frequency;
        this.createdAt = LocalDateTime.now();
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
    
    public Frequency getFrequency() {
        return frequency;
    }
    
    public void setFrequency(Frequency frequency) {
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
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }
} 