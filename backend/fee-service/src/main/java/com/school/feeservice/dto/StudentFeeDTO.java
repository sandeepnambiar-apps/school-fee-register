package com.school.feeservice.dto;

import com.school.feeservice.model.StudentFee;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import java.math.BigDecimal;
import java.time.LocalDate;

public class StudentFeeDTO {
    
    private Long id;
    
    @NotNull(message = "Student ID is required")
    private Long studentId;
    
    @NotNull(message = "Fee structure ID is required")
    private Long feeStructureId;
    
    @NotNull(message = "Academic year ID is required")
    private Long academicYearId;
    
    @NotNull(message = "Amount is required")
    @Positive(message = "Amount must be positive")
    private BigDecimal amount;
    
    private BigDecimal discountAmount = BigDecimal.ZERO;
    
    private BigDecimal netAmount;
    
    private LocalDate dueDate;
    
    private StudentFee.Status status = StudentFee.Status.PENDING;
    
    // Constructors
    public StudentFeeDTO() {}
    
    public StudentFeeDTO(StudentFee studentFee) {
        this.id = studentFee.getId();
        this.studentId = studentFee.getStudentId();
        this.feeStructureId = studentFee.getFeeStructureId();
        this.academicYearId = studentFee.getAcademicYearId();
        this.amount = studentFee.getAmount();
        this.discountAmount = studentFee.getDiscountAmount();
        this.netAmount = studentFee.getNetAmount();
        this.dueDate = studentFee.getDueDate();
        this.status = studentFee.getStatus();
    }
    
    // Convert to Entity
    public StudentFee toEntity() {
        StudentFee studentFee = new StudentFee();
        studentFee.setId(this.id);
        studentFee.setStudentId(this.studentId);
        studentFee.setFeeStructureId(this.feeStructureId);
        studentFee.setAcademicYearId(this.academicYearId);
        studentFee.setAmount(this.amount);
        studentFee.setDiscountAmount(this.discountAmount);
        studentFee.setDueDate(this.dueDate);
        studentFee.setStatus(this.status);
        return studentFee;
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
    }
    
    public BigDecimal getDiscountAmount() {
        return discountAmount;
    }
    
    public void setDiscountAmount(BigDecimal discountAmount) {
        this.discountAmount = discountAmount;
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
    
    public StudentFee.Status getStatus() {
        return status;
    }
    
    public void setStatus(StudentFee.Status status) {
        this.status = status;
    }
} 