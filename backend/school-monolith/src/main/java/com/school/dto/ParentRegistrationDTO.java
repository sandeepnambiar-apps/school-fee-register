package com.school.dto;

public class ParentRegistrationDTO {
    private String mobileNumber;
    private String password;
    private String name;
    private String email;
    private String loginCode;
    private Long schoolId;

    // Constructors
    public ParentRegistrationDTO() {}

    public ParentRegistrationDTO(String mobileNumber, String password, String name, String email, String loginCode, Long schoolId) {
        this.mobileNumber = mobileNumber;
        this.password = password;
        this.name = name;
        this.email = email;
        this.loginCode = loginCode;
        this.schoolId = schoolId;
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

    public String getLoginCode() {
        return loginCode;
    }

    public void setLoginCode(String loginCode) {
        this.loginCode = loginCode;
    }

    public Long getSchoolId() {
        return schoolId;
    }

    public void setSchoolId(Long schoolId) {
        this.schoolId = schoolId;
    }
}
