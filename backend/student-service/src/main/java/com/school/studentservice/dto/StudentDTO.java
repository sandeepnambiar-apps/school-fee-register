package com.school.studentservice.dto;

import com.school.studentservice.model.Student;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.time.LocalDate;

public class StudentDTO {
    
    private Long id;
    
    @NotBlank(message = "Student ID is required")
    private String studentId;
    
    @NotBlank(message = "First name is required")
    private String firstName;
    
    @NotBlank(message = "Last name is required")
    private String lastName;
    
    private LocalDate dateOfBirth;
    
    private Student.Gender gender;
    
    private String address;
    
    private String phone;
    
    private String email;
    
    private String parentName;
    
    private String parentPhone;
    
    private String parentEmail;
    
    private String primaryContact; // 'father', 'mother', or 'guardian'
    private String primaryContactPhone; // The phone number to use for login
    
    @NotNull(message = "Class ID is required")
    private Long classId;
    
    @NotNull(message = "Academic year ID is required")
    private Long academicYearId;
    
    private LocalDate admissionDate;
    
    private Boolean isActive = true;
    
    // Computed fields for frontend display
    private String fullName;
    private String className;
    
    // Constructors
    public StudentDTO() {}
    
    public StudentDTO(Student student) {
        this.id = student.getId();
        this.studentId = student.getStudentId();
        this.firstName = student.getFirstName();
        this.lastName = student.getLastName();
        this.dateOfBirth = student.getDateOfBirth();
        this.gender = student.getGender();
        this.address = student.getAddress();
        this.phone = student.getPhone();
        this.email = student.getEmail();
        this.parentName = student.getParentName();
        this.parentPhone = student.getParentPhone();
        this.parentEmail = student.getParentEmail();
        this.primaryContact = "father"; // Default to father
        this.primaryContactPhone = student.getParentPhone(); // Default to parent phone
        this.classId = student.getClassId();
        this.academicYearId = student.getAcademicYearId();
        this.admissionDate = student.getAdmissionDate();
        this.isActive = student.getIsActive();
        
        // Compute derived fields
        this.fullName = computeFullName();
        this.className = computeClassName();
    }
    
    // Helper methods to compute derived fields
    private String computeFullName() {
        if (firstName != null && lastName != null) {
            return firstName + " " + lastName;
        } else if (firstName != null) {
            return firstName;
        } else if (lastName != null) {
            return lastName;
        }
        return "";
    }
    
    private String computeClassName() {
        if (classId != null) {
            return "Class " + classId;
        }
        return "";
    }
    
    // Convert to Entity
    public Student toEntity() {
        Student student = new Student();
        student.setId(this.id);
        student.setStudentId(this.studentId);
        student.setFirstName(this.firstName);
        student.setLastName(this.lastName);
        student.setDateOfBirth(this.dateOfBirth);
        student.setGender(this.gender);
        student.setAddress(this.address);
        student.setPhone(this.phone);
        student.setEmail(this.email);
        student.setParentName(this.parentName);
        student.setParentPhone(this.parentPhone);
        student.setParentEmail(this.parentEmail);
        student.setClassId(this.classId);
        student.setAcademicYearId(this.academicYearId);
        student.setAdmissionDate(this.admissionDate);
        student.setIsActive(this.isActive);
        return student;
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public String getStudentId() {
        return studentId;
    }
    
    public void setStudentId(String studentId) {
        this.studentId = studentId;
    }
    
    public String getFirstName() {
        return firstName;
    }
    
    public void setFirstName(String firstName) {
        this.firstName = firstName;
        this.fullName = computeFullName();
    }
    
    public String getLastName() {
        return lastName;
    }
    
    public void setLastName(String lastName) {
        this.lastName = lastName;
        this.fullName = computeFullName();
    }
    
    // Computed field getters
    public String getFullName() {
        return fullName != null ? fullName : computeFullName();
    }
    
    public String getClassName() {
        return className != null ? className : computeClassName();
    }
    
    // Also provide 'name' field for frontend compatibility
    public String getName() {
        return getFullName();
    }
    
    // Also provide 'class' field for frontend compatibility
    public String getClassDisplay() {
        return getClassName();
    }
    
    public LocalDate getDateOfBirth() {
        return dateOfBirth;
    }
    
    public void setDateOfBirth(LocalDate dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }
    
    public Student.Gender getGender() {
        return gender;
    }
    
    public void setGender(Student.Gender gender) {
        this.gender = gender;
    }
    
    // Overloaded setter to handle string values from frontend
    public void setGender(String gender) {
        if (gender != null) {
            try {
                this.gender = Student.Gender.valueOf(gender.toUpperCase());
            } catch (IllegalArgumentException e) {
                // Default to OTHER if invalid value
                this.gender = Student.Gender.OTHER;
            }
        }
    }
    
    public String getAddress() {
        return address;
    }
    
    public void setAddress(String address) {
        this.address = address;
    }
    
    public String getPhone() {
        return phone;
    }
    
    public void setPhone(String phone) {
        this.phone = phone;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getParentName() {
        return parentName;
    }
    
    public void setParentName(String parentName) {
        this.parentName = parentName;
    }
    
    public String getParentPhone() {
        return parentPhone;
    }
    
    public void setParentPhone(String parentPhone) {
        this.parentPhone = parentPhone;
    }
    
    public String getParentEmail() {
        return parentEmail;
    }
    
    public void setParentEmail(String parentEmail) {
        this.parentEmail = parentEmail;
    }
    
    public String getPrimaryContact() {
        return primaryContact;
    }
    
    public void setPrimaryContact(String primaryContact) {
        this.primaryContact = primaryContact;
    }
    
    public String getPrimaryContactPhone() {
        return primaryContactPhone;
    }
    
    public void setPrimaryContactPhone(String primaryContactPhone) {
        this.primaryContactPhone = primaryContactPhone;
    }
    
    public Long getClassId() {
        return classId;
    }
    
    public void setClassId(Long classId) {
        this.classId = classId;
        this.className = computeClassName();
    }
    
    public Long getAcademicYearId() {
        return academicYearId;
    }
    
    public void setAcademicYearId(Long academicYearId) {
        this.academicYearId = academicYearId;
    }
    
    public LocalDate getAdmissionDate() {
        return admissionDate;
    }
    
    public void setAdmissionDate(LocalDate admissionDate) {
        this.admissionDate = admissionDate;
    }
    
    public Boolean getIsActive() {
        return isActive;
    }
    
    public void setIsActive(Boolean isActive) {
        this.isActive = isActive;
    }
} 