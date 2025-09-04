package com.school.dto;

import java.time.LocalDateTime;

public class ParentDTO {
    private Long id;
    private String mobileNumber;
    private String name;
    private String email;
    private Boolean isActive;
    private LocalDateTime createdAt;
    private Long schoolId;
    private String schoolName;

    // Constructors
    public ParentDTO() {}

    public ParentDTO(Long id, String mobileNumber, String name, String email, Boolean isActive, LocalDateTime createdAt, Long schoolId, String schoolName) {
        this.id = id;
        this.mobileNumber = mobileNumber;
        this.name = name;
        this.email = email;
        this.isActive = isActive;
        this.createdAt = createdAt;
        this.schoolId = schoolId;
        this.schoolName = schoolName;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getMobileNumber() {
        return mobileNumber;
    }

    public void setMobileNumber(String mobileNumber) {
        this.mobileNumber = mobileNumber;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
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

    public Long getSchoolId() {
        return schoolId;
    }

    public void setSchoolId(Long schoolId) {
        this.schoolId = schoolId;
    }

    public String getSchoolName() {
        return schoolName;
    }

    public void setSchoolName(String schoolName) {
        this.schoolName = schoolName;
    }
}

