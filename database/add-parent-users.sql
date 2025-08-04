-- Add Parent Users with Mobile Numbers for Mobile-Based Login
-- This script creates parent user accounts based on the mobile numbers from student admissions

USE school_fee_register;

-- Add parent users based on student data
-- These are the parents from the student admission data

-- Parent 1: Michael Smith (from STU001)
INSERT INTO users (username, email, password, role, first_name, last_name, phone, is_active) VALUES
('michael.smith', 'michael.smith@email.com', '$2a$10$dXJ3SW6G7P50lGmMkkmwe.20cQQubK3.HZWzG3YB1tlRy.fqvM/BG', 'PARENT', 'Michael', 'Smith', '1234567890', TRUE)
ON DUPLICATE KEY UPDATE 
    email = VALUES(email),
    password = VALUES(password),
    role = VALUES(role),
    first_name = VALUES(first_name),
    last_name = VALUES(last_name),
    phone = VALUES(phone),
    is_active = VALUES(is_active);

-- Parent 2: Sarah Johnson (from STU002)
INSERT INTO users (username, email, password, role, first_name, last_name, phone, is_active) VALUES
('sarah.johnson', 'sarah.johnson@email.com', '$2a$10$dXJ3SW6G7P50lGmMkkmwe.20cQQubK3.HZWzG3YB1tlRy.fqvM/BG', 'PARENT', 'Sarah', 'Johnson', '1234567892', TRUE)
ON DUPLICATE KEY UPDATE 
    email = VALUES(email),
    password = VALUES(password),
    role = VALUES(role),
    first_name = VALUES(first_name),
    last_name = VALUES(last_name),
    phone = VALUES(phone),
    is_active = VALUES(is_active);

-- Parent 3: David Brown (from STU003)
INSERT INTO users (username, email, password, role, first_name, last_name, phone, is_active) VALUES
('david.brown', 'david.brown@email.com', '$2a$10$dXJ3SW6G7P50lGmMkkmwe.20cQQubK3.HZWzG3YB1tlRy.fqvM/BG', 'PARENT', 'David', 'Brown', '1234567894', TRUE)
ON DUPLICATE KEY UPDATE 
    email = VALUES(email),
    password = VALUES(password),
    role = VALUES(role),
    first_name = VALUES(first_name),
    last_name = VALUES(last_name),
    phone = VALUES(phone),
    is_active = VALUES(is_active);

-- Parent 4: Robert Davis (from STU004)
INSERT INTO users (username, email, password, role, first_name, last_name, phone, is_active) VALUES
('robert.davis', 'robert.davis@email.com', '$2a$10$dXJ3SW6G7P50lGmMkkmwe.20cQQubK3.HZWzG3YB1tlRy.fqvM/BG', 'PARENT', 'Robert', 'Davis', '1234567896', TRUE)
ON DUPLICATE KEY UPDATE 
    email = VALUES(email),
    password = VALUES(password),
    role = VALUES(role),
    first_name = VALUES(first_name),
    last_name = VALUES(last_name),
    phone = VALUES(phone),
    is_active = VALUES(is_active);

-- Parent 5: James Wilson (from STU005)
INSERT INTO users (username, email, password, role, first_name, last_name, phone, is_active) VALUES
('james.wilson', 'james.wilson@email.com', '$2a$10$dXJ3SW6G7P50lGmMkkmwe.20cQQubK3.HZWzG3YB1tlRy.fqvM/BG', 'PARENT', 'James', 'Wilson', '1234567898', TRUE)
ON DUPLICATE KEY UPDATE 
    email = VALUES(email),
    password = VALUES(password),
    role = VALUES(role),
    first_name = VALUES(first_name),
    last_name = VALUES(last_name),
    phone = VALUES(phone),
    is_active = VALUES(is_active);

-- Also add a generic parent account for testing
INSERT INTO users (username, email, password, role, first_name, last_name, phone, is_active) VALUES
('parent', 'parent@school.com', '$2a$10$dXJ3SW6G7P50lGmMkkmwe.20cQQubK3.HZWzG3YB1tlRy.fqvM/BG', 'PARENT', 'John', 'Parent', '1234567892', TRUE)
ON DUPLICATE KEY UPDATE 
    email = VALUES(email),
    password = VALUES(password),
    role = VALUES(role),
    first_name = VALUES(first_name),
    last_name = VALUES(last_name),
    phone = VALUES(phone),
    is_active = VALUES(is_active);

-- Verify the parent users were added
SELECT username, email, role, first_name, last_name, phone, is_active FROM users WHERE role = 'PARENT' ORDER BY username; 