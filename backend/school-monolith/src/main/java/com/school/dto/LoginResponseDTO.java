package com.school.dto;

import lombok.Data;
import java.util.Map;

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
    private Map<String, Object> user; // New field for unified user data
}
