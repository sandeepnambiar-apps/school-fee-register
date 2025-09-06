package com.school.service;

import com.school.dto.LoginRequestDTO;
import com.school.dto.LoginResponseDTO;
import com.school.dto.UnifiedLoginDTO;

import java.util.Map;

public interface AuthService {

    LoginResponseDTO login(LoginRequestDTO loginRequest);

    // Unified login method for all user types
    Map<String, Object> unifiedLogin(UnifiedLoginDTO loginDTO);

    void logout(String token);

    boolean validateToken(String token);

    LoginResponseDTO refreshToken(String token);

    // Password management methods
    Map<String, Object> changePassword(String mobileNumber, String newPassword);

    Map<String, Object> forgotPassword(String mobileNumber);

    Map<String, Object> verifyResetOTP(String mobileNumber, String otp);
}
