package com.school.studentservice.exception;

public class StudentNotFoundException extends RuntimeException {
    
    public StudentNotFoundException(String message) {
        super(message);
    }
    
    public StudentNotFoundException(Long id) {
        super("Student not found with id: " + id);
    }
    
    public StudentNotFoundException(String studentId, String type) {
        super("Student not found with " + type + ": " + studentId);
    }
} 