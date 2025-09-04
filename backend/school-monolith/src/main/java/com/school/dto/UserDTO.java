package com.school.dto;

import lombok.Data;

import javax.validation.constraints.Email;
import javax.validation.constraints.NotBlank;
import java.time.LocalDateTime;

@Data
public class UserDTO {
    private Long id;

    @NotBlank(message = "Username is required")
    private String username;

    @NotBlank(message = "Full name is required")
    private String fullName;

    @Email(message = "Invalid email format")
    private String email;

    private String phone;
    private String role;
    private String status;
    private Long schoolId; // Multi-school support (null for SUPER_ADMIN)
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
