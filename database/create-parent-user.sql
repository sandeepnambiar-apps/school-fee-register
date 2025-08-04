-- Create Parent User with Correct Password
-- This script creates a parent user with the proper BCrypt password hash

USE school_fee_register;

-- Insert parent user with correct BCrypt password hash for "password"
INSERT INTO users (username, email, password, role, first_name, last_name, phone, is_active) VALUES
('9876543210', 'parent1@school.com', '$2a$10$dXJ3SW6G7P50lGmMkkmwe.20cQQubK3.HZWzG3YB1tlRy.fqvM/BG', 'PARENT', 'Parent', 'User', '9876543210', TRUE);

-- Verify the user was created
SELECT username, LENGTH(password) as password_length, role, phone, is_active FROM users WHERE username = '9876543210'; 