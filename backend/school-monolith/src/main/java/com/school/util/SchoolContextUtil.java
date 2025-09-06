package com.school.util;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;

@Component
public class SchoolContextUtil {
    
    @Autowired
    private JwtUtil jwtUtil;
    
    /**
     * Extract school_id from JWT token in the current request
     * @return school_id from JWT, or null if not found/invalid
     */
    public Long getCurrentSchoolId() {
        try {
            HttpServletRequest request = getCurrentRequest();
            if (request == null) {
                return null;
            }
            
            String authHeader = request.getHeader("Authorization");
            if (authHeader == null || !authHeader.startsWith("Bearer ")) {
                return null;
            }
            
            String token = authHeader.substring(7); // Remove "Bearer " prefix
            return jwtUtil.extractSchoolId(token);
            
        } catch (Exception e) {
            return null;
        }
    }
    
    /**
     * Extract user role from JWT token in the current request
     * @return role from JWT, or null if not found/invalid
     */
    public String getCurrentUserRole() {
        try {
            HttpServletRequest request = getCurrentRequest();
            if (request == null) {
                return null;
            }
            
            String authHeader = request.getHeader("Authorization");
            if (authHeader == null || !authHeader.startsWith("Bearer ")) {
                return null;
            }
            
            String token = authHeader.substring(7); // Remove "Bearer " prefix
            return jwtUtil.extractRole(token);
            
        } catch (Exception e) {
            return null;
        }
    }
    
    /**
     * Extract mobile number from JWT token in the current request
     * @return mobile number from JWT, or null if not found/invalid
     */
    public String getCurrentUserMobile() {
        try {
            HttpServletRequest request = getCurrentRequest();
            if (request == null) {
                return null;
            }
            
            String authHeader = request.getHeader("Authorization");
            if (authHeader == null || !authHeader.startsWith("Bearer ")) {
                return null;
            }
            
            String token = authHeader.substring(7); // Remove "Bearer " prefix
            return jwtUtil.extractMobileNumber(token);
            
        } catch (Exception e) {
            return null;
        }
    }
    
    /**
     * Check if current user is Super Admin (can access all schools)
     * @return true if Super Admin, false otherwise
     */
    public boolean isSuperAdmin() {
        String role = getCurrentUserRole();
        return "SUPER_ADMIN".equals(role);
    }
    
    /**
     * Check if current user can access the specified school
     * @param schoolId school ID to check access for
     * @return true if user can access the school, false otherwise
     */
    public boolean canAccessSchool(Long schoolId) {
        if (isSuperAdmin()) {
            return true; // Super Admin can access all schools
        }
        
        Long currentSchoolId = getCurrentSchoolId();
        return currentSchoolId != null && currentSchoolId.equals(schoolId);
    }
    
    /**
     * Get the current HTTP request
     * @return HttpServletRequest or null if not available
     */
    private HttpServletRequest getCurrentRequest() {
        try {
            ServletRequestAttributes attributes = 
                (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
            return attributes != null ? attributes.getRequest() : null;
        } catch (Exception e) {
            return null;
        }
    }
}
