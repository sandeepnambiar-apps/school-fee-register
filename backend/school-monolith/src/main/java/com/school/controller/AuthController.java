package com.school.controller;

import com.school.dto.LoginRequestDTO;
import com.school.dto.LoginResponseDTO;
import com.school.dto.UserRegistrationDTO;
import com.school.dto.UserDTO;
import com.school.service.AuthService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

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

    @PostMapping("/register")
    public ResponseEntity<UserDTO> register(@RequestBody UserRegistrationDTO registrationDTO) {
        UserDTO created = authService.register(registrationDTO);
        return ResponseEntity.ok(created);
    }

    @PostMapping("/logout")
    public ResponseEntity<Void> logout(@RequestHeader("Authorization") String token) {
        authService.logout(token);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/profile")
    public ResponseEntity<UserDTO> getProfile(@RequestHeader("Authorization") String token) {
        UserDTO profile = authService.getProfile(token);
        return ResponseEntity.ok(profile);
    }

    @PutMapping("/profile")
    public ResponseEntity<UserDTO> updateProfile(@RequestHeader("Authorization") String token,
                                              @RequestBody UserDTO userDTO) {
        UserDTO updated = authService.updateProfile(token, userDTO);
        return ResponseEntity.ok(updated);
    }

    @PostMapping("/change-password")
    public ResponseEntity<Void> changePassword(@RequestHeader("Authorization") String token,
                                             @RequestParam String oldPassword,
                                             @RequestParam String newPassword) {
        authService.changePassword(token, oldPassword, newPassword);
        return ResponseEntity.ok().build();
    }

    @PostMapping("/forgot-password")
    public ResponseEntity<Void> forgotPassword(@RequestParam String email) {
        authService.forgotPassword(email);
        return ResponseEntity.ok().build();
    }

    @PostMapping("/reset-password")
    public ResponseEntity<Void> resetPassword(@RequestParam String token,
                                            @RequestParam String newPassword) {
        authService.resetPassword(token, newPassword);
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
}


