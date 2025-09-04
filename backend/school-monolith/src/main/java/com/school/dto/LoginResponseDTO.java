package com.school.dto;

import lombok.Data;

@Data
public class LoginResponseDTO {
    private String token;
    private String refreshToken;
    private String role;
    private String username;
    private String fullName;
    private Long userId;
    private Long schoolId;
    private String message;
    private boolean success;
}
