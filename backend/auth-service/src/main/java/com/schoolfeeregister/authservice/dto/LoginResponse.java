package com.schoolfeeregister.authservice.dto;

import java.time.LocalDateTime;

public class LoginResponse {
    
    private String token;
    private String refreshToken;
    private String tokenType = "Bearer";
    private Long userId;
    private String username;
    private String fullName;
    private String role;
    private String userType;
    private Long studentId;
    private LocalDateTime expiresAt;
    
    public LoginResponse() {}
    
    public LoginResponse(String token, String refreshToken, Long userId, String username, 
                        String fullName, String role, String userType, Long studentId, LocalDateTime expiresAt) {
        this.token = token;
        this.refreshToken = refreshToken;
        this.userId = userId;
        this.username = username;
        this.fullName = fullName;
        this.role = role;
        this.userType = userType;
        this.studentId = studentId;
        this.expiresAt = expiresAt;
    }
    
    // Getters and Setters
    public String getToken() {
        return token;
    }
    
    public void setToken(String token) {
        this.token = token;
    }
    
    public String getRefreshToken() {
        return refreshToken;
    }
    
    public void setRefreshToken(String refreshToken) {
        this.refreshToken = refreshToken;
    }
    
    public String getTokenType() {
        return tokenType;
    }
    
    public void setTokenType(String tokenType) {
        this.tokenType = tokenType;
    }
    
    public Long getUserId() {
        return userId;
    }
    
    public void setUserId(Long userId) {
        this.userId = userId;
    }
    
    public String getUsername() {
        return username;
    }
    
    public void setUsername(String username) {
        this.username = username;
    }
    
    public String getFullName() {
        return fullName;
    }
    
    public void setFullName(String fullName) {
        this.fullName = fullName;
    }
    
    public String getRole() {
        return role;
    }
    
    public void setRole(String role) {
        this.role = role;
    }
    
    public String getUserType() {
        return userType;
    }
    
    public void setUserType(String userType) {
        this.userType = userType;
    }
    
    public Long getStudentId() {
        return studentId;
    }
    
    public void setStudentId(Long studentId) {
        this.studentId = studentId;
    }
    
    public LocalDateTime getExpiresAt() {
        return expiresAt;
    }
    
    public void setExpiresAt(LocalDateTime expiresAt) {
        this.expiresAt = expiresAt;
    }
} 