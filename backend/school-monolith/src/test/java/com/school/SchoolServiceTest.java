package com.school;

import com.school.dto.SchoolDTO;
import com.school.dto.SchoolRegistrationDTO;
import com.school.service.SchoolService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
public class SchoolServiceTest {

    @Autowired
    private SchoolService schoolService;

    @Test
    public void testGetAllSchools() {
        // Test that we can retrieve all schools
        var schools = schoolService.getAllSchools();
        assertNotNull(schools);
        assertTrue(schools.size() > 0);
        
        // Verify demo school exists
        boolean demoSchoolExists = schools.stream()
                .anyMatch(school -> "DEMO".equals(school.getSchoolCode()));
        assertTrue(demoSchoolExists, "Demo school should exist");
    }

    @Test
    public void testGetSchoolByCode() {
        // Test retrieving school by code
        SchoolDTO school = schoolService.getSchoolByCode("DEMO");
        assertNotNull(school);
        assertEquals("Demo School", school.getName());
        assertEquals("DEMO", school.getSchoolCode());
    }

    @Test
    public void testSchoolExists() {
        // Test school existence check
        assertTrue(schoolService.schoolExists("DEMO"));
        assertFalse(schoolService.schoolExists("NONEXISTENT"));
    }

    @Test
    public void testRegisterNewSchool() {
        // Test school registration
        SchoolRegistrationDTO registration = new SchoolRegistrationDTO();
        registration.setName("Test Academy");
        registration.setSchoolCode("TEST");
        registration.setAddress("789 Test Street");
        registration.setCity("Test City");
        registration.setState("Test State");
        registration.setCountry("Test Country");
        registration.setPostalCode("54321");
        registration.setPhone("+1-555-9999");
        registration.setEmail("info@testacademy.com");
        registration.setAdminUsername("testadmin");
        registration.setAdminFullName("Test Admin");
        registration.setAdminEmail("admin@testacademy.com");
        registration.setAdminPhone("+1-555-9998");
        registration.setAdminPassword("password123");

        SchoolDTO newSchool = schoolService.registerSchool(registration);
        assertNotNull(newSchool);
        assertEquals("Test Academy", newSchool.getName());
        assertEquals("TEST", newSchool.getSchoolCode());
        assertEquals("ACTIVE", newSchool.getStatus());

        // Verify school was added
        assertTrue(schoolService.schoolExists("TEST"));
    }
}


