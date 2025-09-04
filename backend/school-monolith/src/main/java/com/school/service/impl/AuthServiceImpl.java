package com.school.service.impl;

import com.school.dto.LoginRequestDTO;
import com.school.dto.LoginResponseDTO;
import com.school.dto.UserDTO;
import com.school.dto.UserRegistrationDTO;
import com.school.service.AuthService;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@Service
public class AuthServiceImpl implements AuthService {

    // Mock user database
    private final Map<String, UserDTO> mockUsers = new HashMap<>();
    private final Map<String, String> mockPasswords = new HashMap<>();

    public AuthServiceImpl() {
        // Initialize mock users
        initializeMockUsers();
    }

    private void initializeMockUsers() {
        // Super Admin for School 1 (BOON E.M School)
        UserDTO superAdmin1 = new UserDTO();
        superAdmin1.setId(1L);
        superAdmin1.setUsername("superadmin1");
        superAdmin1.setFullName("Super Admin - BOON E.M School");
        superAdmin1.setEmail("superadmin1@boon.school.com");
        superAdmin1.setRole("SUPER_ADMIN");
        superAdmin1.setStatus("ACTIVE");
        superAdmin1.setSchoolId(1L);
        superAdmin1.setCreatedAt(LocalDateTime.now());

        // Super Admin for School 2 (if exists)
        UserDTO superAdmin2 = new UserDTO();
        superAdmin2.setId(2L);
        superAdmin2.setUsername("superadmin2");
        superAdmin2.setFullName("Super Admin - School 2");
        superAdmin2.setEmail("superadmin2@school2.com");
        superAdmin2.setRole("SUPER_ADMIN");
        superAdmin2.setStatus("ACTIVE");
        superAdmin2.setSchoolId(2L);
        superAdmin2.setCreatedAt(LocalDateTime.now());

        // School Admin
        UserDTO schoolAdmin = new UserDTO();
        schoolAdmin.setId(3L);
        schoolAdmin.setUsername("schooladmin");
        schoolAdmin.setFullName("School Admin");
        schoolAdmin.setEmail("schooladmin@school.com");
        schoolAdmin.setRole("SCHOOL_ADMIN");
        schoolAdmin.setStatus("ACTIVE");
        schoolAdmin.setSchoolId(1L);
        schoolAdmin.setCreatedAt(LocalDateTime.now());

        // Teacher
        UserDTO teacher = new UserDTO();
        teacher.setId(4L);
        teacher.setUsername("teacher");
        teacher.setFullName("John Teacher");
        teacher.setEmail("teacher@school.com");
        teacher.setRole("TEACHER");
        teacher.setStatus("ACTIVE");
        teacher.setSchoolId(1L);
        teacher.setCreatedAt(LocalDateTime.now());

        // Parent
        UserDTO parent = new UserDTO();
        parent.setId(5L);
        parent.setUsername("parent");
        parent.setFullName("Parent User");
        parent.setEmail("parent@school.com");
        parent.setRole("PARENT");
        parent.setStatus("ACTIVE");
        parent.setSchoolId(1L);
        parent.setCreatedAt(LocalDateTime.now());

        // Add to mock database
        mockUsers.put("superadmin1", superAdmin1);
        mockUsers.put("superadmin2", superAdmin2);
        mockUsers.put("schooladmin", schoolAdmin);
        mockUsers.put("teacher", teacher);
        mockUsers.put("parent", parent);

        // Set passwords (in real app, these would be hashed)
        mockPasswords.put("superadmin1", "super123");
        mockPasswords.put("superadmin2", "super456");
        mockPasswords.put("schooladmin", "school123");
        mockPasswords.put("teacher", "teacher123");
        mockPasswords.put("parent", "parent123");
    }

    @Override
    public LoginResponseDTO login(LoginRequestDTO loginRequest) {
        LoginResponseDTO response = new LoginResponseDTO();

        String username = loginRequest.getUsername();
        String password = loginRequest.getPassword();
        Long schoolId = loginRequest.getSchoolId(); // Get schoolId from request

        // Check if user exists
        if (!mockUsers.containsKey(username)) {
            response.setSuccess(false);
            response.setMessage("Invalid username or password");
            return response;
        }

        // Check password
        if (!mockPasswords.get(username).equals(password)) {
            response.setSuccess(false);
            response.setMessage("Invalid username or password");
            return response;
        }

        // Get user details
        UserDTO user = mockUsers.get(username);

        // For Super Admin, verify school access
        if ("SUPER_ADMIN".equals(user.getRole())) {
            if (schoolId != null && !schoolId.equals(user.getSchoolId())) {
                response.setSuccess(false);
                response.setMessage("Super Admin does not have access to this school");
                return response;
            }
        } else {
            // For non-Super Admin users, verify school access
            if (schoolId != null && !schoolId.equals(user.getSchoolId())) {
                response.setSuccess(false);
                response.setMessage("User does not have access to this school");
                return response;
            }
        }

        // Generate mock JWT token (in real app, use proper JWT library)
        String token = "mock-jwt-token-" + username + "-" + System.currentTimeMillis();
        String refreshToken = "mock-refresh-token-" + username + "-" + System.currentTimeMillis();

        // Set response
        response.setSuccess(true);
        response.setToken(token);
        response.setRefreshToken(refreshToken);
        response.setRole(user.getRole());
        response.setUsername(user.getUsername());
        response.setFullName(user.getFullName());
        response.setUserId(user.getId());
        response.setSchoolId(user.getSchoolId());
        response.setMessage("Login successful");

        return response;
    }

    @Override
    public UserDTO register(UserRegistrationDTO registrationDTO) {
        // Check if username already exists
        if (mockUsers.containsKey(registrationDTO.getUsername())) {
            throw new RuntimeException("Username already exists");
        }

        // Create new user
        UserDTO newUser = new UserDTO();
        newUser.setId((long) (mockUsers.size() + 1));
        newUser.setUsername(registrationDTO.getUsername());
        newUser.setFullName(registrationDTO.getFullName());
        newUser.setEmail(registrationDTO.getEmail());
        newUser.setRole(registrationDTO.getRole());
        newUser.setStatus("ACTIVE");
        newUser.setSchoolId(registrationDTO.getSchoolId());
        newUser.setCreatedAt(LocalDateTime.now());

        // Add to mock database
        mockUsers.put(registrationDTO.getUsername(), newUser);
        mockPasswords.put(registrationDTO.getUsername(), registrationDTO.getPassword());

        return newUser;
    }

    @Override
    public void logout(String token) {
        // In real app, invalidate token
        // For mock implementation, do nothing
    }

    @Override
    public UserDTO getProfile(String token) {
        // Extract username from mock token
        String username = extractUsernameFromToken(token);
        return mockUsers.get(username);
    }

    @Override
    public UserDTO updateProfile(String token, UserDTO userDTO) {
        String username = extractUsernameFromToken(token);
        UserDTO existingUser = mockUsers.get(username);

        if (existingUser == null) {
            throw new RuntimeException("User not found");
        }

        // Update fields
        existingUser.setFullName(userDTO.getFullName());
        existingUser.setEmail(userDTO.getEmail());
        existingUser.setPhone(userDTO.getPhone());
        existingUser.setUpdatedAt(LocalDateTime.now());

        return existingUser;
    }

    @Override
    public void changePassword(String token, String oldPassword, String newPassword) {
        String username = extractUsernameFromToken(token);

        if (!mockPasswords.get(username).equals(oldPassword)) {
            throw new RuntimeException("Invalid old password");
        }

        mockPasswords.put(username, newPassword);
    }

    @Override
    public void forgotPassword(String email) {
        // In real app, send reset email
        // For mock implementation, do nothing
    }

    @Override
    public void resetPassword(String token, String newPassword) {
        // In real app, validate reset token
        // For mock implementation, do nothing
    }

    @Override
    public boolean validateToken(String token) {
        try {
            String username = extractUsernameFromToken(token);
            return mockUsers.containsKey(username);
        } catch (Exception e) {
            return false;
        }
    }

    @Override
    public LoginResponseDTO refreshToken(String token) {
        String username = extractUsernameFromToken(token);
        UserDTO user = mockUsers.get(username);

        if (user == null) {
            throw new RuntimeException("Invalid token");
        }

        // Generate new tokens
        String newToken = "mock-jwt-token-" + username + "-" + System.currentTimeMillis();
        String newRefreshToken = "mock-refresh-token-" + username + "-" + System.currentTimeMillis();

        LoginResponseDTO response = new LoginResponseDTO();
        response.setSuccess(true);
        response.setToken(newToken);
        response.setRefreshToken(newRefreshToken);
        response.setRole(user.getRole());
        response.setUsername(user.getUsername());
        response.setFullName(user.getFullName());
        response.setUserId(user.getId());
        response.setSchoolId(user.getSchoolId());

        return response;
    }

    private String extractUsernameFromToken(String token) {
        // Mock token format: "mock-jwt-token-username-timestamp"
        if (token.startsWith("mock-jwt-token-")) {
            String[] parts = token.split("-");
            if (parts.length >= 4) {
                return parts[3];
            }
        }
        throw new RuntimeException("Invalid token format");
    }
}
