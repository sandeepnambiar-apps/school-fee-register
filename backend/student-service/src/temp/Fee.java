package com.school.studentservice.model;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.math.BigDecimal;

@Entity
@Table(name = "fees")
public class Fee {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "student_id", nullable = false)
    private Long studentId;
    
    @Column(name = "class_id", nullable = false)
    private Long classId;
    
    @Enumerated(EnumType.STRING)
    @Column(name = "fee_type", nullable = false)
    private FeeType feeType;
    
    @Column(name = "amount", nullable = false, precision = 10, scale = 2)
    private BigDecimal amount;
    
    @Column(name = "due_date", nullable = false)
    private LocalDate dueDate;
    
    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    private FeeStatus status;
    
    @Column(name = "paid_amount", precision = 10, scale = 2)
    private BigDecimal paidAmount;
    
    @Column(name = "remarks", length = 500)
    private String remarks;
    
    @Column(name = "created_at")
    private LocalDate createdAt;
    
    @Column(name = "updated_at")
    private LocalDate updatedAt;
    
    // Constructors
    public Fee() {}
    
    public Fee(Long studentId, Long classId, FeeType feeType, BigDecimal amount, 
               LocalDate dueDate, String remarks) {
        this.studentId = studentId;
        this.classId = classId;
        this.feeType = feeType;
        this.amount = amount;
        this.dueDate = dueDate;
        this.remarks = remarks;
        this.status = FeeStatus.PENDING;
        this.paidAmount = BigDecimal.ZERO;
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
    
    public Long getClassId() {
        return classId;
    }
    
    public void setClassId(Long classId) {
        this.classId = classId;
    }
    
    public FeeType getFeeType() {
        return feeType;
    }
    
    public void setFeeType(FeeType feeType) {
        this.feeType = feeType;
    }
    
    public BigDecimal getAmount() {
        return amount;
    }
    
    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }
    
    public LocalDate getDueDate() {
        return dueDate;
    }
    
    public void setDueDate(LocalDate dueDate) {
        this.dueDate = dueDate;
    }
    
    public FeeStatus getStatus() {
        return status;
    }
    
    public void setStatus(FeeStatus status) {
        this.status = status;
    }
    
    public BigDecimal getPaidAmount() {
        return paidAmount;
    }
    
    public void setPaidAmount(BigDecimal paidAmount) {
        this.paidAmount = paidAmount;
        updateStatus();
    }
    
    public String getRemarks() {
        return remarks;
    }
    
    public void setRemarks(String remarks) {
        this.remarks = remarks;
    }
    
    public LocalDate getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(LocalDate createdAt) {
        this.createdAt = createdAt;
    }
    
    public LocalDate getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(LocalDate updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    // Helper method to update status based on paid amount
    private void updateStatus() {
        if (paidAmount == null) {
            this.status = FeeStatus.PENDING;
        } else if (paidAmount.compareTo(BigDecimal.ZERO) == 0) {
            this.status = FeeStatus.PENDING;
        } else if (paidAmount.compareTo(amount) >= 0) {
            this.status = FeeStatus.PAID;
        } else {
            this.status = FeeStatus.PARTIAL;
        }
    }
    
    @PrePersist
    protected void onCreate() {
        createdAt = LocalDate.now();
        updatedAt = LocalDate.now();
    }
    
    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDate.now();
    }
    
    // Fee Type Enum
    public enum FeeType {
        TUITION_FEE,
        TRANSPORT_FEE,
        LIBRARY_FEE,
        LABORATORY_FEE,
        SPORTS_FEE,
        EXAMINATION_FEE,
        MISCELLANEOUS_FEE
    }
    
    // Fee Status Enum
    public enum FeeStatus {
        PENDING,
        PARTIAL,
        PAID,
        OVERDUE
    }
} 