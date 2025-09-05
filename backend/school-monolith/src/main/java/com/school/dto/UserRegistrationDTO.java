package com.school.dto;

import com.school.entity.User.UserRole;

public class UserRegistrationDTO {
    
    private String mobileNumber;
    private String password;
    private String name;
    private String email;
    private UserRole role;
    private Long schoolId;
    private String classAssigned; // For teachers
    private String subjectTaught; // For teachers
    private Long parentId; // For linking to Parent entity
    
    // Constructor
    public UserRegistrationDTO() {}
    
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
    
    public UserRole getRole() {
        return role;
    }
    
    public void setRole(UserRole role) {
        this.role = role;
    }
    
    public Long getSchoolId() {
        return schoolId;
    }
    
    public void setSchoolId(Long schoolId) {
        this.schoolId = schoolId;
    }
    
    public String getClassAssigned() {
        return classAssigned;
    }
    
    public void setClassAssigned(String classAssigned) {
        this.classAssigned = classAssigned;
    }
    
    public String getSubjectTaught() {
        return subjectTaught;
    }
    
    public void setSubjectTaught(String subjectTaught) {
        this.subjectTaught = subjectTaught;
    }
    
    public Long getParentId() {
        return parentId;
    }
    
    public void setParentId(Long parentId) {
        this.parentId = parentId;
    }
}
