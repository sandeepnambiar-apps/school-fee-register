package com.school.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "students")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Student {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false)
    private String name;
    
    @Column(nullable = false)
    private String className;
    
    @Column(nullable = false)
    private String section;
    
    @Column(nullable = false)
    private String gender;
    
    @Column(nullable = false, unique = true)
    private String email;
    
    @Column(name = "roll_number")
    private String rollNumber;
    
    @Column(name = "date_of_birth")
    private LocalDate dateOfBirth;
    
    @Column(name = "father_name", nullable = false)
    private String fatherName;
    
    @Column(name = "father_phone", nullable = false)
    private String fatherPhone;
    
    @Column(name = "mother_name", nullable = false)
    private String motherName;
    
    @Column(name = "mother_phone", nullable = false)
    private String motherPhone;
    
    @Column(nullable = false)
    private String address;
    
    @Column(name = "admission_date")
    private LocalDate admissionDate;
    
    @Column(name = "is_active")
    private Boolean isActive = true;
    
    @Column(name = "created_at")
    private LocalDate createdAt;
    
    @Column(name = "updated_at")
    private LocalDate updatedAt;
    
    // NEW: Additional fields for Indian school requirements
    @Column(name = "kid_aadhaar", nullable = false)
    private String kidAadhaar;
    
    @Column(nullable = false)
    private String pen;
    
    @Column(name = "father_aadhaar", nullable = false)
    private String fatherAadhaar;
    
    @Column(name = "mother_aadhaar", nullable = false)
    private String motherAadhaar;
    
    @Column(nullable = false)
    private String caste;
    
    @Column(nullable = false)
    private String category;
    
    @Column(name = "parent_login_code", nullable = false, unique = true)
    private String parentLoginCode;
    
    @Column(name = "parent_login_code_used")
    private Boolean parentLoginCodeUsed = false;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "school_id", nullable = false)
    private School school;
    
    @PrePersist
    protected void onCreate() {
        createdAt = LocalDate.now();
        updatedAt = LocalDate.now();
        if (admissionDate == null) {
            admissionDate = LocalDate.now();
        }
    }
    
    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDate.now();
    }
}

