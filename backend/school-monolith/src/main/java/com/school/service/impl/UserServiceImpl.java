package com.school.service.impl;

import com.school.dto.UnifiedLoginDTO;
import com.school.dto.UserRegistrationDTO;
import com.school.entity.User;
import com.school.entity.User.UserRole;
import com.school.repository.UserRepository;
import com.school.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
public class UserServiceImpl implements UserService {
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private PasswordEncoder passwordEncoder;
    
    @Override
    public Map<String, Object> unifiedLogin(UnifiedLoginDTO loginDTO) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            // Find user by mobile number
            Optional<User> userOpt = userRepository.findByMobileNumberAndIsActiveTrue(loginDTO.getMobileNumber());
            
            if (userOpt.isPresent()) {
                User user = userOpt.get();
                
                // Verify password
                if (passwordEncoder.matches(loginDTO.getPassword(), user.getPassword())) {
                    // Generate JWT token (in real implementation)
                    String token = generateJWTToken(user);
                    
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
                        userRepository.save(user);
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
    public User createUser(UserRegistrationDTO registrationDTO) {
        // Validate mobile number uniqueness
        if (userRepository.existsByMobileNumber(registrationDTO.getMobileNumber())) {
            throw new RuntimeException("Mobile number already exists");
        }
        
        User user = new User();
        user.setMobileNumber(registrationDTO.getMobileNumber());
        user.setPassword(passwordEncoder.encode(registrationDTO.getPassword()));
        user.setName(registrationDTO.getName());
        user.setEmail(registrationDTO.getEmail());
        user.setRole(registrationDTO.getRole());
        user.setSchoolId(registrationDTO.getSchoolId());
        user.setClassAssigned(registrationDTO.getClassAssigned());
        user.setSubjectTaught(registrationDTO.getSubjectTaught());
        user.setParentId(registrationDTO.getParentId());
        user.setIsActive(true);
        user.setIsFirstTime(true);
        
        return userRepository.save(user);
    }
    
    @Override
    public User createSuperAdmin(UserRegistrationDTO registrationDTO) {
        // Only system can create Super Admin
        registrationDTO.setRole(UserRole.SUPER_ADMIN);
        registrationDTO.setSchoolId(null); // Super Admin has no specific school
        
        return createUser(registrationDTO);
    }
    
    @Override
    public User createSchoolAdmin(UserRegistrationDTO registrationDTO, Long createdByUserId) {
        // Validate creator permissions
        User creator = getUserById(createdByUserId);
        if (creator == null || creator.getRole() != UserRole.SUPER_ADMIN) {
            throw new RuntimeException("Only Super Admin can create School Admin");
        }
        
        registrationDTO.setRole(UserRole.SCHOOL_ADMIN);
        
        return createUser(registrationDTO);
    }
    
    @Override
    public User createTeacher(UserRegistrationDTO registrationDTO, Long createdByUserId) {
        // Validate creator permissions
        User creator = getUserById(createdByUserId);
        if (creator == null || 
            (creator.getRole() != UserRole.SUPER_ADMIN && creator.getRole() != UserRole.SCHOOL_ADMIN)) {
            throw new RuntimeException("Only Super Admin or School Admin can create Teacher");
        }
        
        // Validate school access
        if (creator.getRole() == UserRole.SCHOOL_ADMIN && 
            !creator.getSchoolId().equals(registrationDTO.getSchoolId())) {
            throw new RuntimeException("School Admin can only create teachers for their own school");
        }
        
        registrationDTO.setRole(UserRole.TEACHER);
        
        return createUser(registrationDTO);
    }
    
    @Override
    public User createParent(UserRegistrationDTO registrationDTO, Long createdByUserId) {
        // Validate creator permissions
        User creator = getUserById(createdByUserId);
        if (creator == null || 
            (creator.getRole() != UserRole.SUPER_ADMIN && 
             creator.getRole() != UserRole.SCHOOL_ADMIN && 
             creator.getRole() != UserRole.TEACHER)) {
            throw new RuntimeException("Only Super Admin, School Admin, or Teacher can create Parent");
        }
        
        // Validate school access
        if (creator.getRole() == UserRole.SCHOOL_ADMIN && 
            !creator.getSchoolId().equals(registrationDTO.getSchoolId())) {
            throw new RuntimeException("School Admin can only create parents for their own school");
        }
        
        if (creator.getRole() == UserRole.TEACHER && 
            !creator.getSchoolId().equals(registrationDTO.getSchoolId())) {
            throw new RuntimeException("Teacher can only create parents for their own school");
        }
        
        registrationDTO.setRole(UserRole.PARENT);
        
        return createUser(registrationDTO);
    }
    
    @Override
    public User getUserById(Long userId) {
        return userRepository.findById(userId).orElse(null);
    }
    
    @Override
    public User getUserByMobileNumber(String mobileNumber) {
        return userRepository.findByMobileNumber(mobileNumber).orElse(null);
    }
    
    @Override
    public List<User> getUsersBySchool(Long schoolId) {
        return userRepository.findUsersForSchool(schoolId);
    }
    
    @Override
    public List<User> getUsersByRoleAndSchool(String role, Long schoolId) {
        UserRole userRole = UserRole.valueOf(role.toUpperCase());
        return userRepository.findByRoleAndSchoolIdAndIsActiveTrue(userRole, schoolId);
    }
    
    @Override
    public List<User> getTeachersByClass(Long schoolId, String className) {
        return userRepository.findTeachersBySchoolAndClass(schoolId, className);
    }
    
    @Override
    public List<User> getParentsBySchool(Long schoolId) {
        return userRepository.findByRoleAndSchoolIdAndIsActiveTrue(UserRole.PARENT, schoolId);
    }
    
    @Override
    public User updateUser(Long userId, UserRegistrationDTO registrationDTO) {
        User user = getUserById(userId);
        if (user == null) {
            throw new RuntimeException("User not found");
        }
        
        // Update fields
        user.setName(registrationDTO.getName());
        user.setEmail(registrationDTO.getEmail());
        user.setClassAssigned(registrationDTO.getClassAssigned());
        user.setSubjectTaught(registrationDTO.getSubjectTaught());
        
        return userRepository.save(user);
    }
    
    @Override
    public boolean deactivateUser(Long userId, Long deactivatedByUserId) {
        User user = getUserById(userId);
        User deactivator = getUserById(deactivatedByUserId);
        
        if (user == null || deactivator == null) {
            return false;
        }
        
        // Validate permissions
        if (!hasPermission(deactivatedByUserId, "DEACTIVATE_USER", user.getSchoolId())) {
            return false;
        }
        
        user.setIsActive(false);
        userRepository.save(user);
        return true;
    }
    
    @Override
    public boolean activateUser(Long userId, Long activatedByUserId) {
        User user = getUserById(userId);
        User activator = getUserById(activatedByUserId);
        
        if (user == null || activator == null) {
            return false;
        }
        
        // Validate permissions
        if (!hasPermission(activatedByUserId, "ACTIVATE_USER", user.getSchoolId())) {
            return false;
        }
        
        user.setIsActive(true);
        userRepository.save(user);
        return true;
    }
    
    @Override
    public boolean changePassword(Long userId, String currentPassword, String newPassword) {
        User user = getUserById(userId);
        if (user == null) {
            return false;
        }
        
        // Verify current password
        if (!passwordEncoder.matches(currentPassword, user.getPassword())) {
            return false;
        }
        
        // Update password
        user.setPassword(passwordEncoder.encode(newPassword));
        userRepository.save(user);
        return true;
    }
    
    @Override
    public boolean resetPassword(Long userId, String newPassword, Long resetByUserId) {
        User user = getUserById(userId);
        User resetter = getUserById(resetByUserId);
        
        if (user == null || resetter == null) {
            return false;
        }
        
        // Validate permissions
        if (!hasPermission(resetByUserId, "RESET_PASSWORD", user.getSchoolId())) {
            return false;
        }
        
        // Update password
        user.setPassword(passwordEncoder.encode(newPassword));
        user.setIsFirstTime(true); // Force password change on next login
        userRepository.save(user);
        return true;
    }
    
    @Override
    public boolean canAccessSchool(Long userId, Long schoolId) {
        User user = getUserById(userId);
        if (user == null) {
            return false;
        }
        
        // Super Admin can access all schools
        if (user.getRole() == UserRole.SUPER_ADMIN) {
            return true;
        }
        
        // Other users can only access their assigned school
        return user.getSchoolId() != null && user.getSchoolId().equals(schoolId);
    }
    
    @Override
    public List<Long> getAccessibleSchools(Long userId) {
        User user = getUserById(userId);
        if (user == null) {
            return List.of();
        }
        
        // Super Admin can access all schools
        if (user.getRole() == UserRole.SUPER_ADMIN) {
            // In real implementation, fetch all school IDs from database
            return List.of(1L, 2L, 3L, 4L, 5L); // Mock data
        }
        
        // Other users can only access their assigned school
        return user.getSchoolId() != null ? List.of(user.getSchoolId()) : List.of();
    }
    
    @Override
    public boolean hasPermission(Long userId, String permission, Long schoolId) {
        User user = getUserById(userId);
        if (user == null) {
            return false;
        }
        
        // Super Admin has all permissions
        if (user.getRole() == UserRole.SUPER_ADMIN) {
            return true;
        }
        
        // School Admin has permissions for their school
        if (user.getRole() == UserRole.SCHOOL_ADMIN && 
            user.getSchoolId() != null && user.getSchoolId().equals(schoolId)) {
            return true;
        }
        
        // Teacher has limited permissions for their school
        if (user.getRole() == UserRole.TEACHER && 
            user.getSchoolId() != null && user.getSchoolId().equals(schoolId)) {
            // Define teacher permissions
            return List.of("CREATE_PARENT", "VIEW_STUDENTS", "UPDATE_MARKS", "CREATE_HOMEWORK")
                    .contains(permission);
        }
        
        // Parent has very limited permissions
        if (user.getRole() == UserRole.PARENT && 
            user.getSchoolId() != null && user.getSchoolId().equals(schoolId)) {
            // Define parent permissions
            return List.of("VIEW_OWN_CHILDREN", "VIEW_FEES", "VIEW_MARKS")
                    .contains(permission);
        }
        
        return false;
    }
    
    // Generate JWT token (mock implementation)
    private String generateJWTToken(User user) {
        // In real implementation, use JWT library
        return "jwt_token_" + user.getId() + "_" + System.currentTimeMillis();
    }
}
