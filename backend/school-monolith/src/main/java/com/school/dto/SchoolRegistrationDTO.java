package com.school.dto;

import lombok.Data;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Email;
import javax.validation.constraints.Size;

@Data
public class SchoolRegistrationDTO {
    @NotBlank(message = "School name is required")
    private String name;

    @NotBlank(message = "School code is required")
    @Size(min = 3, max = 10, message = "School code must be between 3 and 10 characters")
    private String schoolCode;

    @NotBlank(message = "Address is required")
    private String address;

    @NotBlank(message = "City is required")
    private String city;

    @NotBlank(message = "State is required")
    private String state;

    @NotBlank(message = "Country is required")
    private String country;

    @NotBlank(message = "Postal code is required")
    private String postalCode;

    @NotBlank(message = "Phone number is required")
    private String phone;

    @Email(message = "Invalid email format")
    @NotBlank(message = "Email is required")
    private String email;

    private String website;
    private String principalName;
    private String principalPhone;
    private String principalEmail;

    // Admin user details for the school
    @NotBlank(message = "Admin username is required")
    private String adminUsername;

    @NotBlank(message = "Admin full name is required")
    private String adminFullName;

    @Email(message = "Invalid admin email format")
    @NotBlank(message = "Admin email is required")
    private String adminEmail;

    @NotBlank(message = "Admin phone is required")
    private String adminPhone;

    @NotBlank(message = "Admin password is required")
    @Size(min = 6, message = "Password must be at least 6 characters")
    private String adminPassword;
}


