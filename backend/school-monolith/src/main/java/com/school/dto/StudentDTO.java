package com.school.dto;

import lombok.Data;

import javax.validation.constraints.NotBlank;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class StudentDTO {
    private Long id;

    @NotBlank(message = "Student name is required")
    private String name;

    private String rollNumber;

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
    private String status;
    
    // NEW: Additional fields for Indian school requirements
    private String kidAadhaar;
    private String pen;
    private String fatherAadhaar;
    private String motherAadhaar;
    private String caste;
    private String category;
    
    // NEW: Parent login code fields
    private String parentLoginCode;
    private Boolean parentLoginCodeUsed;
    
    private Long schoolId; // Multi-school support
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
