package com.school.studentservice.dto;

import com.school.studentservice.model.Fee.FeeType;
import com.school.studentservice.model.Fee.FeeStatus;
import java.time.LocalDate;
import java.math.BigDecimal;

public class FeeDTO {
    
    private Long id;
    private Long studentId;
    private Long classId;
    private FeeType feeType;
    private BigDecimal amount;
    private LocalDate dueDate;
    private FeeStatus status;
    private BigDecimal paidAmount;
    private String remarks;
    private LocalDate createdAt;
    private LocalDate updatedAt;
    
    // Additional fields for display
    private String studentName;
    private String className;
    private String parentName;
    
    // Constructors
    public FeeDTO() {}
    
    public FeeDTO(Long studentId, Long classId, FeeType feeType, BigDecimal amount, 
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
    
    public String getStudentName() {
        return studentName;
    }
    
    public void setStudentName(String studentName) {
        this.studentName = studentName;
    }
    
    public String getClassName() {
        return className;
    }
    
    public void setClassName(String className) {
        this.className = className;
    }
    
    public String getParentName() {
        return parentName;
    }
    
    public void setParentName(String parentName) {
        this.parentName = parentName;
    }
} 