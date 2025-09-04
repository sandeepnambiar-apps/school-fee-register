package com.school.config;

import com.school.entity.School;
import com.school.entity.Student;
import com.school.repository.SchoolRepository;
import com.school.repository.StudentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.time.LocalDate;
import java.util.Arrays;
import java.util.List;

@Component
public class StudentDataInitializer implements CommandLineRunner {

    @Autowired
    private StudentRepository studentRepository;

    @Autowired
    private SchoolRepository schoolRepository;

    @Override
    public void run(String... args) throws Exception {
        try {
            System.out.println("Starting StudentDataInitializer...");
            
            // Check if data already exists
            if (studentRepository.count() > 0) {
                System.out.println("Student data already exists, skipping initialization.");
                return;
            }

            System.out.println("Creating default school...");
            // Create or get default school
            School defaultSchool = getOrCreateDefaultSchool();
            System.out.println("Default school created/found with ID: " + defaultSchool.getId());

            System.out.println("Creating sample students...");
            // Create sample students
            List<Student> students = Arrays.asList(
                createStudent("John Doe", "10A", "A", "Male", "john.doe@school.com", "1001", 
                    LocalDate.of(2008, 5, 15), "Mike Doe", "+1234567891", "Jane Doe", "+1234567892",
                    "123 Main St, City, State", LocalDate.of(2023, 9, 1), defaultSchool,
                    "123456789012", "PEN001", "987654321098", "876543210987", "General", "General"),
                
                createStudent("Sarah Smith", "9B", "B", "Female", "sarah.smith@school.com", "2001",
                    LocalDate.of(2009, 3, 20), "David Smith", "+1234567893", "Lisa Smith", "+1234567894",
                    "456 Oak Ave, City, State", LocalDate.of(2023, 9, 1), defaultSchool,
                    "234567890123", "PEN002", "876543210987", "765432109876", "OBC", "OBC"),
                
                createStudent("Michael Johnson", "11C", "C", "Male", "michael.johnson@school.com", "3001",
                    LocalDate.of(2007, 8, 10), "Robert Johnson", "+1234567895", "Patricia Johnson", "+1234567896",
                    "789 Pine Rd, City, State", LocalDate.of(2023, 9, 1), defaultSchool,
                    "345678901234", "PEN003", "765432109876", "654321098765", "SC", "SC"),
                
                createStudent("Emily Davis", "8A", "A", "Female", "emily.davis@school.com", "4001",
                    LocalDate.of(2010, 12, 5), "James Davis", "+1234567897", "Mary Davis", "+1234567898",
                    "321 Elm St, City, State", LocalDate.of(2023, 9, 1), defaultSchool,
                    "456789012345", "PEN004", "654321098765", "543210987654", "ST", "ST"),
                
                createStudent("David Wilson", "12D", "D", "Male", "david.wilson@school.com", "5001",
                    LocalDate.of(2006, 6, 15), "Thomas Wilson", "+1234567899", "Helen Wilson", "+1234567900",
                    "654 Maple Dr, City, State", LocalDate.of(2023, 9, 1), defaultSchool,
                    "567890123456", "PEN005", "543210987654", "432109876543", "EWS", "EWS")
            );

            System.out.println("Saving students to database...");
            // Save all students
            studentRepository.saveAll(students);
            System.out.println("Successfully initialized " + students.size() + " students with complete data including Aadhaar and category fields.");
        } catch (Exception e) {
            System.err.println("Error in StudentDataInitializer: " + e.getMessage());
            e.printStackTrace();
        }
    }

    private School getOrCreateDefaultSchool() {
        try {
            System.out.println("Looking for existing schools...");
            
            // First try to find any existing school
            List<School> existingSchools = schoolRepository.findAll();
            if (!existingSchools.isEmpty()) {
                School firstSchool = existingSchools.get(0);
                System.out.println("Using existing school: " + firstSchool.getName() + " with ID: " + firstSchool.getId());
                return firstSchool;
            }
            
            // If no schools exist, create a default one
            System.out.println("No schools found, creating new default school...");
            School school = new School();
            school.setName("Default School");
            school.setAddress("123 Education Street, City");
            school.setPhone("+1234567890");
            school.setEmail("admin@defaultschool.com");
            school.setPrincipalName("Dr. Principal");
            school.setIsActive(true);
            
            System.out.println("Saving school to database...");
            School savedSchool = schoolRepository.save(school);
            System.out.println("School saved with ID: " + savedSchool.getId());
            return savedSchool;
        } catch (Exception e) {
            System.err.println("Error in getOrCreateDefaultSchool: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }

    private Student createStudent(String name, String className, String section, String gender, 
                                String email, String rollNumber, LocalDate dateOfBirth,
                                String fatherName, String fatherPhone, String motherName, String motherPhone,
                                String address, LocalDate admissionDate, School school,
                                String kidAadhaar, String pen, String fatherAadhaar, String motherAadhaar,
                                String caste, String category) {
        Student student = new Student();
        student.setName(name);
        student.setClassName(className);
        student.setSection(section);
        student.setGender(gender);
        student.setEmail(email);
        student.setRollNumber(rollNumber);
        student.setDateOfBirth(dateOfBirth);
        student.setFatherName(fatherName);
        student.setFatherPhone(fatherPhone);
        student.setMotherName(motherName);
        student.setMotherPhone(motherPhone);
        student.setAddress(address);
        student.setAdmissionDate(admissionDate);
        student.setSchool(school);
        student.setIsActive(true);
        
        // NEW: Set the additional fields
        student.setKidAadhaar(kidAadhaar);
        student.setPen(pen);
        student.setFatherAadhaar(fatherAadhaar);
        student.setMotherAadhaar(motherAadhaar);
        student.setCaste(caste);
        student.setCategory(category);
        

        
        return student;
    }
}
