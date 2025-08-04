package com.school.feeservice.exception;

public class FeeNotFoundException extends RuntimeException {
    
    public FeeNotFoundException(String message) {
        super(message);
    }
    
    public FeeNotFoundException(Long id, String type) {
        super(type + " not found with id: " + id);
    }
    
    public FeeNotFoundException(String type, String value) {
        super(type + " not found with value: " + value);
    }
} 