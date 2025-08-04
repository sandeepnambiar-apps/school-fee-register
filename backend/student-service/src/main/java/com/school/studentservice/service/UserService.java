package com.school.studentservice.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import java.util.HashMap;
import java.util.Map;

@Service
public class UserService {
    
    @Autowired
    private RestTemplate restTemplate;
    
    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
    
    // Default password for all new users
    private static final String DEFAULT_PASSWORD = "password";
    
    /**
     * Create a user account for a parent when a student is registered
     * @param phoneNumber The phone number to use as username
     * @param fullName The full name of the parent
     * @param studentId The ID of the student
     * @return true if user was created successfully, false otherwise
     */
    public boolean createParentUser(String phoneNumber, String fullName, Long studentId) {
        try {
            // Prepare the user data
            Map<String, Object> userData = new HashMap<>();
            userData.put("username", phoneNumber); // Use phone as username for easy login
            userData.put("password", passwordEncoder.encode(DEFAULT_PASSWORD));
            userData.put("email", phoneNumber + "@school.com"); // Generate a dummy email
            userData.put("fullName", fullName);
            userData.put("role", "PARENT");
            userData.put("userType", "PARENT");
            userData.put("phone", phoneNumber); // Add phone field for mobile login
            userData.put("studentId", studentId);
            userData.put("enabled", true);
            
            // Set headers
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            
            // Create HTTP entity
            HttpEntity<Map<String, Object>> request = new HttpEntity<>(userData, headers);
            
            // Make the API call to auth service through gateway
            String authServiceUrl = "http://localhost:8080/api/auth/users";
            
            restTemplate.postForEntity(authServiceUrl, request, Map.class);
            
            return true;
        } catch (Exception e) {
            System.err.println("Failed to create user account: " + e.getMessage());
            return false;
        }
    }
} 