package com.school.controller;

import com.school.dto.UnifiedLoginDTO;
import com.school.dto.UserRegistrationDTO;
import com.school.entity.User;
import com.school.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api")
@CrossOrigin(origins = "*")
public class UserController {
    
    @Autowired
    private UserService userService;
    
    // Note: Unified login endpoint is handled by AuthController at /api/auth/unified-login
    
    // Create Super Admin (system only)
    @PostMapping("/users/super-admin")
    public ResponseEntity<Map<String, Object>> createSuperAdmin(@RequestBody UserRegistrationDTO registrationDTO) {
        try {
            User user = userService.createSuperAdmin(registrationDTO);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "Super Admin created successfully");
            response.put("user", user);
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Failed to create Super Admin: " + e.getMessage());
            return ResponseEntity.badRequest().body(errorResponse);
        }
    }
    
    // Create School Admin (Super Admin only)
    @PostMapping("/users/school-admin")
    public ResponseEntity<Map<String, Object>> createSchoolAdmin(
            @RequestBody UserRegistrationDTO registrationDTO,
            @RequestParam Long createdByUserId) {
        try {
            User user = userService.createSchoolAdmin(registrationDTO, createdByUserId);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "School Admin created successfully");
            response.put("user", user);
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Failed to create School Admin: " + e.getMessage());
            return ResponseEntity.badRequest().body(errorResponse);
        }
    }
    
    // Create Teacher (Super Admin or School Admin)
    @PostMapping("/users/teacher")
    public ResponseEntity<Map<String, Object>> createTeacher(
            @RequestBody UserRegistrationDTO registrationDTO,
            @RequestParam Long createdByUserId) {
        try {
            User user = userService.createTeacher(registrationDTO, createdByUserId);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "Teacher created successfully");
            response.put("user", user);
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Failed to create Teacher: " + e.getMessage());
            return ResponseEntity.badRequest().body(errorResponse);
        }
    }
    
    // Create Parent (Super Admin, School Admin, or Teacher)
    @PostMapping("/users/parent")
    public ResponseEntity<Map<String, Object>> createParent(
            @RequestBody UserRegistrationDTO registrationDTO,
            @RequestParam Long createdByUserId) {
        try {
            User user = userService.createParent(registrationDTO, createdByUserId);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "Parent created successfully");
            response.put("user", user);
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Failed to create Parent: " + e.getMessage());
            return ResponseEntity.badRequest().body(errorResponse);
        }
    }
    
    // Get users by school
    @GetMapping("/users/school/{schoolId}")
    public ResponseEntity<Map<String, Object>> getUsersBySchool(@PathVariable Long schoolId) {
        try {
            List<User> users = userService.getUsersBySchool(schoolId);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("users", users);
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Failed to get users: " + e.getMessage());
            return ResponseEntity.badRequest().body(errorResponse);
        }
    }
    
    // Get users by role and school
    @GetMapping("/users/school/{schoolId}/role/{role}")
    public ResponseEntity<Map<String, Object>> getUsersByRoleAndSchool(
            @PathVariable Long schoolId,
            @PathVariable String role) {
        try {
            List<User> users = userService.getUsersByRoleAndSchool(role, schoolId);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("users", users);
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Failed to get users: " + e.getMessage());
            return ResponseEntity.badRequest().body(errorResponse);
        }
    }
    
    // Get teachers by class
    @GetMapping("/users/school/{schoolId}/teachers/class/{className}")
    public ResponseEntity<Map<String, Object>> getTeachersByClass(
            @PathVariable Long schoolId,
            @PathVariable String className) {
        try {
            List<User> teachers = userService.getTeachersByClass(schoolId, className);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("teachers", teachers);
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Failed to get teachers: " + e.getMessage());
            return ResponseEntity.badRequest().body(errorResponse);
        }
    }
    
    // Update user
    @PutMapping("/users/{userId}")
    public ResponseEntity<Map<String, Object>> updateUser(
            @PathVariable Long userId,
            @RequestBody UserRegistrationDTO registrationDTO) {
        try {
            User user = userService.updateUser(userId, registrationDTO);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "User updated successfully");
            response.put("user", user);
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Failed to update user: " + e.getMessage());
            return ResponseEntity.badRequest().body(errorResponse);
        }
    }
    
    // Deactivate user
    @PostMapping("/users/{userId}/deactivate")
    public ResponseEntity<Map<String, Object>> deactivateUser(
            @PathVariable Long userId,
            @RequestParam Long deactivatedByUserId) {
        try {
            boolean success = userService.deactivateUser(userId, deactivatedByUserId);
            
            Map<String, Object> response = new HashMap<>();
            if (success) {
                response.put("success", true);
                response.put("message", "User deactivated successfully");
            } else {
                response.put("success", false);
                response.put("message", "Failed to deactivate user");
            }
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Failed to deactivate user: " + e.getMessage());
            return ResponseEntity.badRequest().body(errorResponse);
        }
    }
    
    // Activate user
    @PostMapping("/users/{userId}/activate")
    public ResponseEntity<Map<String, Object>> activateUser(
            @PathVariable Long userId,
            @RequestParam Long activatedByUserId) {
        try {
            boolean success = userService.activateUser(userId, activatedByUserId);
            
            Map<String, Object> response = new HashMap<>();
            if (success) {
                response.put("success", true);
                response.put("message", "User activated successfully");
            } else {
                response.put("success", false);
                response.put("message", "Failed to activate user");
            }
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Failed to activate user: " + e.getMessage());
            return ResponseEntity.badRequest().body(errorResponse);
        }
    }
    
    // Change password
    @PostMapping("/users/{userId}/change-password")
    public ResponseEntity<Map<String, Object>> changePassword(
            @PathVariable Long userId,
            @RequestParam String currentPassword,
            @RequestParam String newPassword) {
        try {
            boolean success = userService.changePassword(userId, currentPassword, newPassword);
            
            Map<String, Object> response = new HashMap<>();
            if (success) {
                response.put("success", true);
                response.put("message", "Password changed successfully");
            } else {
                response.put("success", false);
                response.put("message", "Failed to change password");
            }
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Failed to change password: " + e.getMessage());
            return ResponseEntity.badRequest().body(errorResponse);
        }
    }
    
    // Reset password (admin use)
    @PostMapping("/users/{userId}/reset-password")
    public ResponseEntity<Map<String, Object>> resetPassword(
            @PathVariable Long userId,
            @RequestParam String newPassword,
            @RequestParam Long resetByUserId) {
        try {
            boolean success = userService.resetPassword(userId, newPassword, resetByUserId);
            
            Map<String, Object> response = new HashMap<>();
            if (success) {
                response.put("success", true);
                response.put("message", "Password reset successfully");
            } else {
                response.put("success", false);
                response.put("message", "Failed to reset password");
            }
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Failed to reset password: " + e.getMessage());
            return ResponseEntity.badRequest().body(errorResponse);
        }
    }
    
    // Check school access
    @GetMapping("/users/{userId}/can-access-school/{schoolId}")
    public ResponseEntity<Map<String, Object>> canAccessSchool(
            @PathVariable Long userId,
            @PathVariable Long schoolId) {
        try {
            boolean canAccess = userService.canAccessSchool(userId, schoolId);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("canAccess", canAccess);
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Failed to check access: " + e.getMessage());
            return ResponseEntity.badRequest().body(errorResponse);
        }
    }
    
    // Get accessible schools
    @GetMapping("/users/{userId}/accessible-schools")
    public ResponseEntity<Map<String, Object>> getAccessibleSchools(@PathVariable Long userId) {
        try {
            List<Long> schoolIds = userService.getAccessibleSchools(userId);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("schoolIds", schoolIds);
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("success", false);
            errorResponse.put("message", "Failed to get accessible schools: " + e.getMessage());
            return ResponseEntity.badRequest().body(errorResponse);
        }
    }
}
