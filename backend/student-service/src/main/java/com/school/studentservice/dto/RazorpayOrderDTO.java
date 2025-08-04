package com.school.studentservice.dto;

import java.math.BigDecimal;

public class RazorpayOrderDTO {
    
    private String orderId;
    private BigDecimal amount;
    private String currency;
    private String receipt;
    private String notes;
    private String studentName;
    private String feeType;
    private String studentId;
    private String feeId;
    private String parentId;
    
    // Constructors
    public RazorpayOrderDTO() {}
    
    public RazorpayOrderDTO(BigDecimal amount, String currency, String receipt, String notes) {
        this.amount = amount;
        this.currency = currency;
        this.receipt = receipt;
        this.notes = notes;
    }
    
    // Getters and Setters
    public String getOrderId() {
        return orderId;
    }
    
    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }
    
    public BigDecimal getAmount() {
        return amount;
    }
    
    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }
    
    public String getCurrency() {
        return currency;
    }
    
    public void setCurrency(String currency) {
        this.currency = currency;
    }
    
    public String getReceipt() {
        return receipt;
    }
    
    public void setReceipt(String receipt) {
        this.receipt = receipt;
    }
    
    public String getNotes() {
        return notes;
    }
    
    public void setNotes(String notes) {
        this.notes = notes;
    }
    
    public String getStudentName() {
        return studentName;
    }
    
    public void setStudentName(String studentName) {
        this.studentName = studentName;
    }
    
    public String getFeeType() {
        return feeType;
    }
    
    public void setFeeType(String feeType) {
        this.feeType = feeType;
    }
    
    public String getStudentId() {
        return studentId;
    }
    
    public void setStudentId(String studentId) {
        this.studentId = studentId;
    }
    
    public String getFeeId() {
        return feeId;
    }
    
    public void setFeeId(String feeId) {
        this.feeId = feeId;
    }
    
    public String getParentId() {
        return parentId;
    }
    
    public void setParentId(String parentId) {
        this.parentId = parentId;
    }
} 