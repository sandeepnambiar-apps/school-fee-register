package com.school.service.impl;

import com.school.dto.LoginRequestDTO;
import com.school.dto.LoginResponseDTO;
import com.school.dto.UnifiedLoginDTO;
import com.school.entity.User;
import com.school.entity.User.UserRole;
import com.school.service.AuthService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import javax.annotation.PostConstruct;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@Service
public class AuthServiceImpl implements AuthService {

    @Autowired
    private PasswordEncoder passwordEncoder;

    // Mock user database for development
    private final Map<String, User> mockUsers = new HashMap<>();

    @PostConstruct
    public void initializeMockUsers() {
        // Super Admin - can access all schools
        User superAdmin = new User();
        superAdmin.setId(1L);
        superAdmin.setMobileNumber("9999999999");
        superAdmin.setPassword(passwordEncoder.encode("password"));
        superAdmin.setName("App Developer");
        superAdmin.setEmail("developer@kidsy.com");
        superAdmin.setRole(UserRole.SUPER_ADMIN);
        superAdmin.setSchoolId(null); // Can access all schools
        superAdmin.setIsActive(true);
        superAdmin.setIsFirstTime(false);
        superAdmin.setCreatedAt(LocalDateTime.now());

        // School 1 Admin
        User school1Admin = new User();
        school1Admin.setId(2L);
        school1Admin.setMobileNumber("1111111111");
        school1Admin.setPassword(passwordEncoder.encode("password"));
        school1Admin.setName("School 1 Admin");
        school1Admin.setEmail("admin1@school.com");
        school1Admin.setRole(UserRole.SCHOOL_ADMIN);
        school1Admin.setSchoolId(1L);
        school1Admin.setIsActive(true);
        school1Admin.setIsFirstTime(false);
        school1Admin.setCreatedAt(LocalDateTime.now());

        // School 2 Admin
        User school2Admin = new User();
        school2Admin.setId(3L);
        school2Admin.setMobileNumber("2222222222");
        school2Admin.setPassword(passwordEncoder.encode("password"));
        school2Admin.setName("School 2 Admin");
        school2Admin.setEmail("admin2@school.com");
        school2Admin.setRole(UserRole.SCHOOL_ADMIN);
        school2Admin.setSchoolId(2L);
        school2Admin.setIsActive(true);
        school2Admin.setIsFirstTime(false);
        school2Admin.setCreatedAt(LocalDateTime.now());

        // School 1 Teacher
        User teacher1 = new User();
        teacher1.setId(4L);
        teacher1.setMobileNumber("3333333333");
        teacher1.setPassword(passwordEncoder.encode("password"));
        teacher1.setName("John Teacher");
        teacher1.setEmail("john.teacher@school.com");
        teacher1.setRole(UserRole.TEACHER);
        teacher1.setSchoolId(1L);
        teacher1.setClassAssigned("10A");
        teacher1.setSubjectTaught("Mathematics");
        teacher1.setIsActive(true);
        teacher1.setIsFirstTime(false);
        teacher1.setCreatedAt(LocalDateTime.now());

        // School 1 Parent
        User parent1 = new User();
        parent1.setId(5L);
        parent1.setMobileNumber("6666666666");
        parent1.setPassword(passwordEncoder.encode("password"));
        parent1.setName("David Parent");
        parent1.setEmail("david.parent@email.com");
        parent1.setRole(UserRole.PARENT);
        parent1.setSchoolId(1L);
        parent1.setIsActive(true);
        parent1.setIsFirstTime(false);
        parent1.setCreatedAt(LocalDateTime.now());

        // School 2 Teacher
        User teacher2 = new User();
        teacher2.setId(6L);
        teacher2.setMobileNumber("5555555555");
        teacher2.setPassword(passwordEncoder.encode("password"));
        teacher2.setName("Mike Teacher");
        teacher2.setEmail("mike.teacher@school.com");
        teacher2.setRole(UserRole.TEACHER);
        teacher2.setSchoolId(2L);
        teacher2.setClassAssigned("8A");
        teacher2.setSubjectTaught("English");
        teacher2.setIsActive(true);
        teacher2.setIsFirstTime(false);
        teacher2.setCreatedAt(LocalDateTime.now());

        // School 2 Parent
        User parent2 = new User();
        parent2.setId(7L);
        parent2.setMobileNumber("8888888888");
        parent2.setPassword(passwordEncoder.encode("password"));
        parent2.setName("Robert Parent");
        parent2.setEmail("robert.parent@email.com");
        parent2.setRole(UserRole.PARENT);
        parent2.setSchoolId(2L);
        parent2.setIsActive(true);
        parent2.setIsFirstTime(false);
        parent2.setCreatedAt(LocalDateTime.now());

        // Add to mock database
        mockUsers.put("9999999999", superAdmin);
        mockUsers.put("1111111111", school1Admin);
        mockUsers.put("2222222222", school2Admin);
        mockUsers.put("3333333333", teacher1);
        mockUsers.put("6666666666", parent1);
        mockUsers.put("5555555555", teacher2);
        mockUsers.put("8888888888", parent2);
    }

    @Override
    public LoginResponseDTO login(LoginRequestDTO loginRequest) {
        LoginResponseDTO response = new LoginResponseDTO();
        
        try {
            // Find user by mobile number
            User user = mockUsers.get(loginRequest.getMobileNumber());
            
            if (user != null && user.getIsActive()) {
                // Verify password
                if (passwordEncoder.matches(loginRequest.getPassword(), user.getPassword())) {
                    // Generate JWT token (mock)
                    String token = "jwt_token_" + user.getId() + "_" + System.currentTimeMillis();
                    
                    // Prepare user data for response
                    Map<String, Object> userData = new HashMap<>();
                    userData.put("id", user.getId());
                    userData.put("mobileNumber", user.getMobileNumber());
                    userData.put("name", user.getName());
                    userData.put("email", user.getEmail());
                    userData.put("role", user.getRole().toString());
                    userData.put("schoolId", user.getSchoolId());
                    userData.put("isFirstTime", user.getIsFirstTime());
                    userData.put("classAssigned", user.getClassAssigned());
                    userData.put("subjectTaught", user.getSubjectTaught());
                    
                    response.setSuccess(true);
                    response.setMessage("Login successful");
                    response.setToken(token);
                    response.setUser(userData);
                    
                    // Update first time flag if needed
                    if (user.getIsFirstTime()) {
                        user.setIsFirstTime(false);
                    }
                } else {
                    response.setSuccess(false);
                    response.setMessage("Invalid password");
                }
            } else {
                response.setSuccess(false);
                response.setMessage("User not found or inactive");
            }
        } catch (Exception e) {
            response.setSuccess(false);
            response.setMessage("Login failed: " + e.getMessage());
        }
        
        return response;
    }

    @Override
    public Map<String, Object> unifiedLogin(UnifiedLoginDTO loginDTO) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            // Find user by mobile number
            User user = mockUsers.get(loginDTO.getMobileNumber());
            
            if (user != null && user.getIsActive()) {
                // Verify password
                if (passwordEncoder.matches(loginDTO.getPassword(), user.getPassword())) {
                    // Generate JWT token (mock)
                    String token = "jwt_token_" + user.getId() + "_" + System.currentTimeMillis();
                    
                    // Prepare user data for response
                    Map<String, Object> userData = new HashMap<>();
                    userData.put("id", user.getId());
                    userData.put("mobileNumber", user.getMobileNumber());
                    userData.put("name", user.getName());
                    userData.put("email", user.getEmail());
                    userData.put("role", user.getRole().toString());
                    userData.put("schoolId", user.getSchoolId());
                    userData.put("isFirstTime", user.getIsFirstTime());
                    userData.put("classAssigned", user.getClassAssigned());
                    userData.put("subjectTaught", user.getSubjectTaught());
                    
                    response.put("success", true);
                    response.put("message", "Login successful");
                    response.put("token", token);
                    response.put("user", userData);
                    
                    // Update first time flag if needed
                    if (user.getIsFirstTime()) {
                        user.setIsFirstTime(false);
                    }
                } else {
                    response.put("success", false);
                    response.put("message", "Invalid password");
                }
            } else {
                response.put("success", false);
                response.put("message", "User not found or inactive");
            }
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Login failed: " + e.getMessage());
        }
        
        return response;
    }

    @Override
    public void logout(String token) {
        // In real implementation, invalidate token
        // For mock implementation, do nothing
    }

    @Override
    public boolean validateToken(String token) {
        try {
            // Mock token validation
            if (token != null && token.startsWith("jwt_token_")) {
                return true;
            }
            return false;
        } catch (Exception e) {
            return false;
        }
    }

    @Override
    public LoginResponseDTO refreshToken(String token) {
        LoginResponseDTO response = new LoginResponseDTO();
        
        try {
            if (validateToken(token)) {
                // Generate new token
                String newToken = "jwt_token_refresh_" + System.currentTimeMillis();
                String refreshToken = "refresh_token_" + System.currentTimeMillis();
                
                response.setSuccess(true);
                response.setToken(newToken);
                response.setRefreshToken(refreshToken);
                response.setMessage("Token refreshed successfully");
            } else {
                response.setSuccess(false);
                response.setMessage("Invalid token");
            }
        } catch (Exception e) {
            response.setSuccess(false);
            response.setMessage("Token refresh failed: " + e.getMessage());
        }
        
        return response;
    }
}
