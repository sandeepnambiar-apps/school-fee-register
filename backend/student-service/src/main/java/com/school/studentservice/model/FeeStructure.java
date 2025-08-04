package com.school.studentservice.model;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "fee_structures")
public class FeeStructure {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "class_id", nullable = false)
    private Long classId;
    
    @Column(name = "fee_category_id", nullable = false)
    private Long feeCategoryId;
    
    @Column(name = "academic_year_id", nullable = false)
    private Long academicYearId;
    
    @Column(name = "amount", nullable = false, precision = 10, scale = 2)
    private BigDecimal amount;
    
    @Enumerated(EnumType.STRING)
    @Column(name = "frequency", nullable = false)
    private Frequency frequency;
    
    @Column(name = "due_date")
    private LocalDate dueDate;
    
    @Column(name = "is_active", nullable = false)
    private Boolean isActive;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    // Constructors
    public FeeStructure() {}
    
    public FeeStructure(Long classId, Long feeCategoryId, Long academicYearId, 
                       BigDecimal amount, Frequency frequency, LocalDate dueDate) {
        this.classId = classId;
        this.feeCategoryId = feeCategoryId;
        this.academicYearId = academicYearId;
        this.amount = amount;
        this.frequency = frequency;
        this.dueDate = dueDate;
        this.isActive = true;
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
    

    
    public enum Frequency {
        MONTHLY,
        QUARTERLY,
        SEMI_ANNUAL,
        ANNUAL,
        ONE_TIME
    }
} 