package com.school.controller;

import com.school.dto.SchoolDTO;
import com.school.dto.SchoolRegistrationDTO;
import com.school.service.SchoolService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;

@RestController
@RequestMapping("/api/schools")
@CrossOrigin(origins = "*")
public class SchoolController {

    @Autowired
    private SchoolService schoolService;

    /**
     * Register a new school
     */
    @PostMapping("/register")
    public ResponseEntity<SchoolDTO> registerSchool(@Valid @RequestBody SchoolRegistrationDTO registrationDTO) {
        try {
            SchoolDTO newSchool = schoolService.registerSchool(registrationDTO);
            return ResponseEntity.status(HttpStatus.CREATED).body(newSchool);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().build();
        }
    }

    /**
     * Get all schools (for SUPER_ADMIN only)
     */
    @GetMapping
    public ResponseEntity<List<SchoolDTO>> getAllSchools() {
        List<SchoolDTO> schools = schoolService.getAllSchools();
        return ResponseEntity.ok(schools);
    }

    /**
     * Get school by ID
     */
    @GetMapping("/{id}")
    public ResponseEntity<SchoolDTO> getSchoolById(@PathVariable Long id) {
        SchoolDTO school = schoolService.getSchoolById(id);
        if (school != null) {
            return ResponseEntity.ok(school);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    /**
     * Get school by school code
     */
    @GetMapping("/code/{schoolCode}")
    public ResponseEntity<SchoolDTO> getSchoolByCode(@PathVariable String schoolCode) {
        SchoolDTO school = schoolService.getSchoolByCode(schoolCode);
        if (school != null) {
            return ResponseEntity.ok(school);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    /**
     * Update school information
     */
    @PutMapping("/{id}")
    public ResponseEntity<SchoolDTO> updateSchool(@PathVariable Long id, @Valid @RequestBody SchoolDTO schoolDTO) {
        try {
            SchoolDTO updatedSchool = schoolService.updateSchool(id, schoolDTO);
            return ResponseEntity.ok(updatedSchool);
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }

    /**
     * Update school status
     */
    @PatchMapping("/{id}/status")
    public ResponseEntity<SchoolDTO> updateSchoolStatus(@PathVariable Long id, @RequestParam String status) {
        try {
            SchoolDTO updatedSchool = schoolService.updateSchoolStatus(id, status);
            return ResponseEntity.ok(updatedSchool);
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }

    /**
     * Delete school (soft delete)
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteSchool(@PathVariable Long id) {
        try {
            schoolService.deleteSchool(id);
            return ResponseEntity.noContent().build();
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }

    /**
     * Check if school exists by code
     */
    @GetMapping("/exists/{schoolCode}")
    public ResponseEntity<Boolean> schoolExists(@PathVariable String schoolCode) {
        boolean exists = schoolService.schoolExists(schoolCode);
        return ResponseEntity.ok(exists);
    }

    /**
     * Get schools by status
     */
    @GetMapping("/status/{status}")
    public ResponseEntity<List<SchoolDTO>> getSchoolsByStatus(@PathVariable String status) {
        List<SchoolDTO> schools = schoolService.getSchoolsByStatus(status);
        return ResponseEntity.ok(schools);
    }
}


