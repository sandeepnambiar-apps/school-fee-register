package com.school.notification.service;

import com.school.notification.dto.StudentContactDTO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class StudentContactService {
    private static final Logger log = LoggerFactory.getLogger(StudentContactService.class);
    
    private final RestTemplate restTemplate = new RestTemplate();
    
    @Value("${student.service.url:http://localhost:8081}")
    private String studentServiceUrl;
    
    public StudentContactDTO getStudentContact(Long studentId) {
        try {
            String url = studentServiceUrl + "/api/students/" + studentId;
            return restTemplate.getForObject(url, StudentContactDTO.class);
        } catch (Exception e) {
            log.error("Failed to fetch student contact for ID {}: {}", studentId, e.getMessage());
            return null;
        }
    }
    
    public List<StudentContactDTO> getStudentsByClass(Long classId) {
        try {
            String url = studentServiceUrl + "/api/students/class/" + classId;
            StudentContactDTO[] students = restTemplate.getForObject(url, StudentContactDTO[].class);
            return students != null ? Arrays.asList(students) : List.of();
        } catch (Exception e) {
            log.error("Failed to fetch students for class {}: {}", classId, e.getMessage());
            return List.of();
        }
    }
    
    public List<StudentContactDTO> getStudentsByIds(List<Long> studentIds) {
        try {
            String url = studentServiceUrl + "/api/students/bulk";
            StudentContactDTO[] students = restTemplate.postForObject(url, studentIds, StudentContactDTO[].class);
            return students != null ? Arrays.asList(students) : List.of();
        } catch (Exception e) {
            log.error("Failed to fetch students by IDs: {}", e.getMessage());
            return List.of();
        }
    }
    
    public List<String> getParentPhoneNumbers(List<StudentContactDTO> students) {
        return students.stream()
                .filter(student -> student.getParentPhone() != null && !student.getParentPhone().trim().isEmpty())
                .map(StudentContactDTO::getParentPhone)
                .distinct()
                .collect(Collectors.toList());
    }
    
    public List<String> getParentEmailAddresses(List<StudentContactDTO> students) {
        return students.stream()
                .filter(student -> student.getParentEmail() != null && !student.getParentEmail().trim().isEmpty())
                .map(StudentContactDTO::getParentEmail)
                .distinct()
                .collect(Collectors.toList());
    }
} 