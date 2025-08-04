package com.schoolfeeregister.authservice.dto;

import jakarta.validation.constraints.NotBlank;

public class LoginRequest {
    
    private String username;
    
    private String mobile;
    
    @NotBlank(message = "Password is required")
    private String password;
    
    public LoginRequest() {}
    
    public LoginRequest(String username, String password) {
        this.username = username;
        this.password = password;
    }
    
    public LoginRequest(String username, String mobile, String password) {
        this.username = username;
        this.mobile = mobile;
        this.password = password;
    }
    
    public String getUsername() {
        return username;
    }
    
    public void setUsername(String username) {
        this.username = username;
    }
    
    public String getMobile() {
        return mobile;
    }
    
    public void setMobile(String mobile) {
        this.mobile = mobile;
    }
    
    public String getPassword() {
        return password;
    }
    
    public void setPassword(String password) {
        this.password = password;
    }
} 