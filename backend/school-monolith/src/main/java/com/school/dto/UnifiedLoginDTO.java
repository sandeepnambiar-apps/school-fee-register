package com.school.dto;

public class UnifiedLoginDTO {
    
    private String mobileNumber;
    private String password;
    
    // Constructor
    public UnifiedLoginDTO() {}
    
    public UnifiedLoginDTO(String mobileNumber, String password) {
        this.mobileNumber = mobileNumber;
        this.password = password;
    }
    
    // Getters and Setters
    public String getMobileNumber() {
        return mobileNumber;
    }
    
    public void setMobileNumber(String mobileNumber) {
        this.mobileNumber = mobileNumber;
    }
    
    public String getPassword() {
        return password;
    }
    
    public void setPassword(String password) {
        this.password = password;
    }
}
