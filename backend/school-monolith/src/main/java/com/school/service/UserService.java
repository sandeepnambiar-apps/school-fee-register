package com.school.service;

import com.school.dto.UnifiedLoginDTO;
import com.school.dto.UserRegistrationDTO;
import com.school.entity.User;

import java.util.List;
import java.util.Map;

public interface UserService {
    
    // Unified login for all user types
    Map<String, Object> unifiedLogin(UnifiedLoginDTO loginDTO);
    
    // Create new user
    User createUser(UserRegistrationDTO registrationDTO);
    
    // Create Super Admin (can only be done by system)
    User createSuperAdmin(UserRegistrationDTO registrationDTO);
    
    // Create School Admin (can only be done by Super Admin)
    User createSchoolAdmin(UserRegistrationDTO registrationDTO, Long createdByUserId);
    
    // Create Teacher (can be done by School Admin or Super Admin)
    User createTeacher(UserRegistrationDTO registrationDTO, Long createdByUserId);
    
    // Create Parent (can be done by School Admin, Teacher, or Super Admin)
    User createParent(UserRegistrationDTO registrationDTO, Long createdByUserId);
    
    // Get user by ID
    User getUserById(Long userId);
    
    // Get user by mobile number
    User getUserByMobileNumber(String mobileNumber);
    
    // Get all users for a school
    List<User> getUsersBySchool(Long schoolId);
    
    // Get users by role for a school
    List<User> getUsersByRoleAndSchool(String role, Long schoolId);
    
    // Get teachers for a specific class
    List<User> getTeachersByClass(Long schoolId, String className);
    
    // Get parents for a school
    List<User> getParentsBySchool(Long schoolId);
    
    // Update user
    User updateUser(Long userId, UserRegistrationDTO registrationDTO);
    
    // Deactivate user
    boolean deactivateUser(Long userId, Long deactivatedByUserId);
    
    // Activate user
    boolean activateUser(Long userId, Long activatedByUserId);
    
    // Change password
    boolean changePassword(Long userId, String currentPassword, String newPassword);
    
    // Reset password (for admin use)
    boolean resetPassword(Long userId, String newPassword, Long resetByUserId);
    
    // Check if user can access a specific school
    boolean canAccessSchool(Long userId, Long schoolId);
    
    // Get accessible schools for a user
    List<Long> getAccessibleSchools(Long userId);
    
    // Validate user permissions
    boolean hasPermission(Long userId, String permission, Long schoolId);
}
