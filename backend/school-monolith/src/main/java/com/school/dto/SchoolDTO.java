package com.school.dto;

import lombok.Data;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Email;
import java.time.LocalDateTime;

@Data
public class SchoolDTO {
    private Long id;

    @NotBlank(message = "School name is required")
    private String name;

    @NotBlank(message = "School code is required")
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
    private String status; // ACTIVE, INACTIVE, SUSPENDED
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}


