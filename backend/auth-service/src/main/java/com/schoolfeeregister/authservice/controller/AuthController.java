package com.schoolfeeregister.authservice.controller;

import com.schoolfeeregister.authservice.dto.LoginRequest;
import com.schoolfeeregister.authservice.dto.LoginResponse;
import com.schoolfeeregister.authservice.model.User;
import com.schoolfeeregister.authservice.model.UserRole;
import com.schoolfeeregister.authservice.model.UserType;
import com.schoolfeeregister.authservice.service.AuthService;
import com.schoolfeeregister.authservice.repository.UserRepository;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/v1/auth")
public class AuthController {
    
    @Autowired
    private AuthService authService;
    
    @Autowired
    private UserRepository userRepository;
    
    @PostMapping("/login")
    public ResponseEntity<?> login(@Valid @RequestBody LoginRequest loginRequest) {
        try {
            LoginResponse response = authService.login(loginRequest);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, String> error = new HashMap<>();
            error.put("message", "Invalid username or password");
            return ResponseEntity.badRequest().body(error);
        }
    }
    
    @PostMapping("/refresh")
    public ResponseEntity<?> refreshToken(@RequestBody Map<String, String> request) {
        try {
            String refreshToken = request.get("refreshToken");
            if (refreshToken == null) {
                Map<String, String> error = new HashMap<>();
                error.put("message", "Refresh token is required");
                return ResponseEntity.badRequest().body(error);
            }
            
            LoginResponse response = authService.refreshToken(refreshToken);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, String> error = new HashMap<>();
            error.put("message", "Invalid refresh token");
            return ResponseEntity.badRequest().body(error);
        }
    }
    
    @PostMapping("/logout")
    public ResponseEntity<?> logout(@RequestHeader("Authorization") String authHeader) {
        try {
            String token = authHeader.replace("Bearer ", "");
            authService.logout(token);
            
            Map<String, String> response = new HashMap<>();
            response.put("message", "Logged out successfully");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, String> error = new HashMap<>();
            error.put("message", "Logout failed");
            return ResponseEntity.badRequest().body(error);
        }
    }
    
    @GetMapping("/validate")
    public ResponseEntity<?> validateToken(@RequestHeader("Authorization") String authHeader) {
        try {
            String token = authHeader.replace("Bearer ", "");
            boolean isValid = authService.validateToken(token);
            
            Map<String, Object> response = new HashMap<>();
            response.put("valid", isValid);
            
            if (isValid) {
                User user = authService.getCurrentUser(token);
                response.put("user", user);
            }
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> response = new HashMap<>();
            response.put("valid", false);
            response.put("message", "Invalid token");
            return ResponseEntity.ok(response);
        }
    }
    
    @GetMapping("/profile")
    public ResponseEntity<?> getProfile(@RequestHeader("Authorization") String authHeader) {
        try {
            String token = authHeader.replace("Bearer ", "");
            User user = authService.getCurrentUser(token);
            
            Map<String, Object> profile = new HashMap<>();
            profile.put("id", user.getId());
            profile.put("username", user.getUsername());
            profile.put("email", user.getEmail());
            profile.put("fullName", user.getFullName());
            profile.put("role", user.getRole());
            profile.put("userType", user.getUserType());
            profile.put("studentId", user.getStudentId());
            profile.put("enabled", user.isEnabled());
            
            return ResponseEntity.ok(profile);
        } catch (Exception e) {
            Map<String, String> error = new HashMap<>();
            error.put("message", "Failed to get profile");
            return ResponseEntity.badRequest().body(error);
        }
    }
    
    @PostMapping("/users")
    public ResponseEntity<?> createUser(@RequestBody Map<String, Object> userData) {
        try {
            // Extract user data from request
            String username = (String) userData.get("username");
            String password = (String) userData.get("password");
            String email = (String) userData.get("email");
            String fullName = (String) userData.get("fullName");
            String role = (String) userData.get("role");
            String userType = (String) userData.get("userType");
            String phone = (String) userData.get("phone");
            Long studentId = userData.get("studentId") != null ? Long.valueOf(userData.get("studentId").toString()) : null;
            Boolean enabled = (Boolean) userData.get("enabled");
            
            // Check if user already exists
            if (userRepository.existsByUsername(username)) {
                Map<String, String> error = new HashMap<>();
                error.put("message", "Username already exists");
                return ResponseEntity.badRequest().body(error);
            }
            
            // Create new user
            User user = new User();
            user.setUsername(username);
            user.setPassword(password); // Password should already be encoded
            user.setEmail(email);
            user.setFullName(fullName);
            user.setPhone(phone);
            user.setRole(UserRole.valueOf(role));
            user.setUserType(UserType.valueOf(userType));
            user.setStudentId(studentId);
            user.setEnabled(enabled != null ? enabled : true);
            
            User savedUser = userRepository.save(user);
            
            Map<String, Object> response = new HashMap<>();
            response.put("message", "User created successfully");
            response.put("userId", savedUser.getId());
            response.put("username", savedUser.getUsername());
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, String> error = new HashMap<>();
            error.put("message", "Failed to create user: " + e.getMessage());
            return ResponseEntity.badRequest().body(error);
        }
    }
} 