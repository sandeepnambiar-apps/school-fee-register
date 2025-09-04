package com.school.service.impl;

import com.school.dto.SchoolDTO;
import com.school.dto.SchoolRegistrationDTO;
import com.school.dto.UserDTO;
import com.school.entity.School;
import com.school.repository.SchoolRepository;
import com.school.service.SchoolService;
import com.school.service.AuthService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class SchoolServiceImpl implements SchoolService {

    @Autowired
    private SchoolRepository schoolRepository;
    
    @Autowired
    private AuthService authService;

    @Override
    public void initializeDefaultSchools() {
        // Check if schools already exist
        if (schoolRepository.count() == 0) {
            // Demo School
            School demoSchool = new School();
            demoSchool.setName("Demo School");
            demoSchool.setAddress("123 Education Street");
            demoSchool.setPhone("+1-555-0123");
            demoSchool.setEmail("info@demoschool.com");
            demoSchool.setPrincipalName("Dr. John Principal");
            demoSchool.setEstablishedYear(2020);
            demoSchool.setSchoolType("PRIMARY_SECONDARY");
            demoSchool.setMaxCapacity(500);
            demoSchool.setCurrentEnrollment(0);
            demoSchool.setIsActive(true);
            
            schoolRepository.save(demoSchool);
            
            // Sample School
            School sampleSchool = new School();
            sampleSchool.setName("Sample Academy");
            sampleSchool.setAddress("456 Learning Avenue");
            sampleSchool.setPhone("+1-555-0456");
            sampleSchool.setEmail("info@sampleacademy.com");
            sampleSchool.setPrincipalName("Dr. Jane Director");
            sampleSchool.setEstablishedYear(2018);
            sampleSchool.setSchoolType("SECONDARY");
            sampleSchool.setMaxCapacity(300);
            sampleSchool.setCurrentEnrollment(0);
            sampleSchool.setIsActive(true);
            
            schoolRepository.save(sampleSchool);
        }
    }

    @Override
    public SchoolDTO registerSchool(SchoolRegistrationDTO registrationDTO) {
        // Check if school name already exists
        if (schoolRepository.existsByName(registrationDTO.getName())) {
            throw new RuntimeException("School name already exists: " + registrationDTO.getName());
        }

        // Create new school entity
        School newSchool = new School();
        newSchool.setName(registrationDTO.getName());
        newSchool.setAddress(registrationDTO.getAddress());
        newSchool.setPhone(registrationDTO.getPhone());
        newSchool.setEmail(registrationDTO.getEmail());
        newSchool.setPrincipalName(registrationDTO.getPrincipalName());
        newSchool.setEstablishedYear(2024);
        newSchool.setSchoolType("PRIMARY_SECONDARY");
        newSchool.setMaxCapacity(500);
        newSchool.setCurrentEnrollment(0);
        newSchool.setIsActive(true);
        
        // Save to database
        School savedSchool = schoolRepository.save(newSchool);
        
        // Convert to DTO and return
        return convertToDTO(savedSchool);
    }

    @Override
    public SchoolDTO getSchoolById(Long id) {
        Optional<School> school = schoolRepository.findById(id);
        return school.map(this::convertToDTO).orElse(null);
    }

    @Override
    public SchoolDTO getSchoolByCode(String schoolCode) {
        // For now, we'll search by name since we removed schoolCode
        Optional<School> school = schoolRepository.findByName(schoolCode);
        return school.map(this::convertToDTO).orElse(null);
    }

    @Override
    public List<SchoolDTO> getAllSchools() {
        return schoolRepository.findByIsActiveTrue()
                .stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    @Override
    public SchoolDTO updateSchool(Long id, SchoolDTO schoolDTO) {
        Optional<School> existingSchool = schoolRepository.findById(id);
        if (existingSchool.isEmpty()) {
            throw new RuntimeException("School not found with ID: " + id);
        }

        School school = existingSchool.get();
        school.setName(schoolDTO.getName());
        school.setAddress(schoolDTO.getAddress());
        school.setPhone(schoolDTO.getPhone());
        school.setEmail(schoolDTO.getEmail());
        school.setPrincipalName(schoolDTO.getPrincipalName());
        
        School updatedSchool = schoolRepository.save(school);
        return convertToDTO(updatedSchool);
    }

    @Override
    public SchoolDTO updateSchoolStatus(Long id, String status) {
        Optional<School> schoolOpt = schoolRepository.findById(id);
        if (schoolOpt.isEmpty()) {
            throw new RuntimeException("School not found with ID: " + id);
        }

        School school = schoolOpt.get();
        school.setIsActive("ACTIVE".equals(status));
        
        School updatedSchool = schoolRepository.save(school);
        return convertToDTO(updatedSchool);
    }

    @Override
    public void deleteSchool(Long id) {
        Optional<School> schoolOpt = schoolRepository.findById(id);
        if (schoolOpt.isPresent()) {
            School school = schoolOpt.get();
            school.setIsActive(false);
            schoolRepository.save(school);
        }
    }

    @Override
    public boolean schoolExists(String schoolCode) {
        return schoolRepository.existsByName(schoolCode);
    }
    
    private SchoolDTO convertToDTO(School school) {
        SchoolDTO dto = new SchoolDTO();
        dto.setId(school.getId());
        dto.setName(school.getName());
        dto.setSchoolCode(school.getName()); // Using name as code for now
        dto.setAddress(school.getAddress());
        dto.setPhone(school.getPhone());
        dto.setEmail(school.getEmail());
        dto.setPrincipalName(school.getPrincipalName());
        dto.setStatus(school.getIsActive() ? "ACTIVE" : "INACTIVE");
        dto.setCreatedAt(school.getCreatedAt() != null ? 
            school.getCreatedAt() : LocalDateTime.now());
        dto.setUpdatedAt(school.getUpdatedAt() != null ? 
            school.getUpdatedAt() : LocalDateTime.now());
        return dto;
    }

    @Override
    public List<SchoolDTO> getSchoolsByStatus(String status) {
        if ("ACTIVE".equals(status)) {
            return schoolRepository.findByIsActiveTrue()
                    .stream()
                    .map(this::convertToDTO)
                    .collect(Collectors.toList());
        } else {
            return schoolRepository.findAll()
                    .stream()
                    .filter(school -> !school.getIsActive())
                    .map(this::convertToDTO)
                    .collect(Collectors.toList());
        }
    }
}
