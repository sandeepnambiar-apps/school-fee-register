package com.school.controller;

import com.school.dto.LoginRequestDTO;
import com.school.dto.LoginResponseDTO;
import com.school.dto.UnifiedLoginDTO;
import com.school.service.AuthService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class AuthController {

    private final AuthService authService;

    @PostMapping("/login")
    public ResponseEntity<LoginResponseDTO> login(@RequestBody LoginRequestDTO loginRequest) {
        LoginResponseDTO response = authService.login(loginRequest);
        return ResponseEntity.ok(response);
    }

    @PostMapping("/unified-login")
    public ResponseEntity<Map<String, Object>> unifiedLogin(@RequestBody UnifiedLoginDTO loginDTO) {
        Map<String, Object> response = authService.unifiedLogin(loginDTO);
        return ResponseEntity.ok(response);
    }

    @PostMapping("/logout")
    public ResponseEntity<Void> logout(@RequestHeader("Authorization") String token) {
        authService.logout(token);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/validate-token")
    public ResponseEntity<Boolean> validateToken(@RequestHeader("Authorization") String token) {
        boolean isValid = authService.validateToken(token);
        return ResponseEntity.ok(isValid);
    }

    @PostMapping("/refresh-token")
    public ResponseEntity<LoginResponseDTO> refreshToken(@RequestHeader("Authorization") String token) {
        LoginResponseDTO response = authService.refreshToken(token);
        return ResponseEntity.ok(response);
    }

    @PostMapping("/change-password")
    public ResponseEntity<Map<String, Object>> changePassword(@RequestBody Map<String, String> request) {
        Map<String, Object> response = authService.changePassword(
            request.get("mobileNumber"),
            request.get("newPassword")
        );
        return ResponseEntity.ok(response);
    }

    @PostMapping("/forgot-password")
    public ResponseEntity<Map<String, Object>> forgotPassword(@RequestBody Map<String, String> request) {
        Map<String, Object> response = authService.forgotPassword(request.get("mobileNumber"));
        return ResponseEntity.ok(response);
    }

    @PostMapping("/verify-reset-otp")
    public ResponseEntity<Map<String, Object>> verifyResetOTP(@RequestBody Map<String, String> request) {
        Map<String, Object> response = authService.verifyResetOTP(
            request.get("mobileNumber"),
            request.get("otp")
        );
        return ResponseEntity.ok(response);
    }
}
