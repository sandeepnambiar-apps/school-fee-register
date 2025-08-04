-- Add Demo Users for School Fee Register
-- This script adds the missing demo users that are referenced in the startup scripts

USE school_fee_register;

-- Add Parent user
INSERT INTO users (username, email, password, role, first_name, last_name, phone, is_active) VALUES
('parent', 'parent@school.com', '$2a$10$rAM0QZqZqZqZqZqZqZqZqO', 'PARENT', 'John', 'Parent', '1234567892', TRUE)
ON DUPLICATE KEY UPDATE 
    email = VALUES(email),
    password = VALUES(password),
    role = VALUES(role),
    first_name = VALUES(first_name),
    last_name = VALUES(last_name),
    phone = VALUES(phone),
    is_active = VALUES(is_active);

-- Add Teacher user
INSERT INTO users (username, email, password, role, first_name, last_name, phone, is_active) VALUES
('teacher', 'teacher@school.com', '$2a$10$rAM0QZqZqZqZqZqZqZqZqO', 'STAFF', 'Jane', 'Teacher', '1234567893', TRUE)
ON DUPLICATE KEY UPDATE 
    email = VALUES(email),
    password = VALUES(password),
    role = VALUES(role),
    first_name = VALUES(first_name),
    last_name = VALUES(last_name),
    phone = VALUES(phone),
    is_active = VALUES(is_active);

-- Verify the users were added
SELECT username, email, role, first_name, last_name, is_active FROM users ORDER BY username; 