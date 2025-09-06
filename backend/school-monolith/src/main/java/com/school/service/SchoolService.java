package com.school.service;

import com.school.dto.SchoolDTO;
import com.school.dto.SchoolRegistrationDTO;

import java.util.List;

public interface SchoolService {
    
    /**
     * Register a new school with admin user
     */
    SchoolDTO registerSchool(SchoolRegistrationDTO registrationDTO);
    
    /**
     * Get school by ID
     */
    SchoolDTO getSchoolById(Long id);
    
    /**
     * Get school by school code
     */
    SchoolDTO getSchoolByCode(String schoolCode);
    
    /**
     * Get all schools (for SUPER_ADMIN only)
     */
    List<SchoolDTO> getAllSchools();
    
    /**
     * Update school information
     */
    SchoolDTO updateSchool(Long id, SchoolDTO schoolDTO);
    
    /**
     * Update school status
     */
    SchoolDTO updateSchoolStatus(Long id, String status);
    
    /**
     * Delete school (soft delete)
     */
    void deleteSchool(Long id);
    
    /**
     * Check if school exists
     */
    boolean schoolExists(String schoolCode);
    
    /**
     * Get schools by status
     */
    List<SchoolDTO> getSchoolsByStatus(String status);
    
    /**
     * Initialize default schools (for development/testing)
     */
    void initializeDefaultSchools();
    
    /**
     * Validate school code
     */
    boolean validateSchoolCode(String schoolCode);
}
