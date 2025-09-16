-- Create schools table for School Fee Register System
-- This table stores school information and school codes

USE school_fee_register;

-- Create schools table
CREATE TABLE IF NOT EXISTS schools (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    school_code VARCHAR(10) NOT NULL UNIQUE,
    address TEXT NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(255) NOT NULL,
    principal_name VARCHAR(255),
    established_year INT,
    school_type VARCHAR(50),
    max_capacity INT,
    current_enrollment INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Insert demo schools for testing
INSERT INTO schools (
    name, 
    school_code, 
    address, 
    phone, 
    email, 
    principal_name, 
    established_year, 
    school_type, 
    max_capacity, 
    current_enrollment, 
    is_active
) VALUES 
(
    'Demo School 001',
    'DEMO001',
    '123 Demo Street, Demo City, DC 12345',
    '+1-555-0001',
    'info@demoschool001.edu',
    'Dr. Demo Principal',
    2020,
    'PRIMARY_SECONDARY',
    1000,
    0,
    TRUE
),
(
    'Sample School 001',
    'SAMP001',
    '456 Sample Avenue, Sample Town, ST 67890',
    '+1-555-0002',
    'info@sampleschool001.edu',
    'Dr. Sample Principal',
    2021,
    'PRIMARY_SECONDARY',
    800,
    0,
    TRUE
),
(
    'BOON School',
    'BOON',
    '123 Education Street, Learning City, LC 12345',
    '+1-555-0123',
    'info@boonschool.edu',
    'Dr. Jane Smith',
    2020,
    'PRIMARY_SECONDARY',
    1000,
    0,
    TRUE
);

-- Verify the schools were added
SELECT * FROM schools;

