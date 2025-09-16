-- Add BOON School to the database
-- This script adds the BOON school with school code "BOON"

USE school_fee_register;

-- Insert BOON school
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
    is_active, 
    created_at, 
    updated_at
) VALUES (
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
    TRUE,
    NOW(),
    NOW()
);

-- Verify the school was added
SELECT * FROM schools WHERE school_code = 'BOON';

