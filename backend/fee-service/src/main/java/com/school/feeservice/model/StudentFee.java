package com.school.feeservice.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "student_fees")
public class StudentFee {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "student_id")
    private Long studentId;
    
    @Column(name = "fee_structure_id")
    private Long feeStructureId;
    
    @Column(name = "academic_year_id")
    private Long academicYearId;
    
    @NotNull
    @Positive
    private BigDecimal amount;
    
    @Column(name = "discount_amount")
    private BigDecimal discountAmount = BigDecimal.ZERO;
    
    @Column(name = "net_amount")
    private BigDecimal netAmount;
    
    @Column(name = "due_date")
    private LocalDate dueDate;
    
    @Enumerated(EnumType.STRING)
    private Status status = Status.PENDING;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    public enum Status {
        PENDING, PAID, PARTIAL, OVERDUE
    }
    
    // Constructors
    public StudentFee() {}
    
    public StudentFee(Long studentId, Long feeStructureId, Long academicYearId, BigDecimal amount, LocalDate dueDate) {
        this.studentId = studentId;
        this.feeStructureId = feeStructureId;
        this.academicYearId = academicYearId;
        this.amount = amount;
        this.dueDate = dueDate;
        this.netAmount = amount.subtract(discountAmount);
        this.createdAt = LocalDateTime.now();
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public Long getStudentId() {
        return studentId;
    }
    
    public void setStudentId(Long studentId) {
        this.studentId = studentId;
    }
    
    public Long getFeeStructureId() {
        return feeStructureId;
    }
    
    public void setFeeStructureId(Long feeStructureId) {
        this.feeStructureId = feeStructureId;
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
        updateNetAmount();
    }
    
    public BigDecimal getDiscountAmount() {
        return discountAmount;
    }
    
    public void setDiscountAmount(BigDecimal discountAmount) {
        this.discountAmount = discountAmount;
        updateNetAmount();
    }
    
    public BigDecimal getNetAmount() {
        return netAmount;
    }
    
    public void setNetAmount(BigDecimal netAmount) {
        this.netAmount = netAmount;
    }
    
    public LocalDate getDueDate() {
        return dueDate;
    }
    
    public void setDueDate(LocalDate dueDate) {
        this.dueDate = dueDate;
    }
    
    public Status getStatus() {
        return status;
    }
    
    public void setStatus(Status status) {
        this.status = status;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    private void updateNetAmount() {
        if (amount != null && discountAmount != null) {
            this.netAmount = amount.subtract(discountAmount);
        }
    }
    
    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updateNetAmount();
    }
} 