package com.school.dto;

import lombok.Data;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import java.time.LocalDate;

@Data
public class StudentRegistrationDTO {

    @NotBlank(message = "Student name is required")
    private String name;

    private String rollNumber;

    @NotBlank(message = "Class is required")
    private String className;

    @NotBlank(message = "Section is required")
    private String section;

    private LocalDate dateOfBirth;

    private String gender;
    private String address;
    private String phone;
    private String email;
    private String fatherName;
    private String fatherPhone;
    private String parentEmail;
    private String motherName;
    private String motherPhone;
    
    // NEW: Additional fields for Indian school requirements
    private String kidAadhaar;
    private String pen;
    private String fatherAadhaar;
    private String motherAadhaar;
    private String caste;
    private String category;
    
    @NotNull(message = "School ID is required")
    private Long schoolId;
    
    private String parentLoginCode;
}
