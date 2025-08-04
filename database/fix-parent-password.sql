-- Fix Parent User Password
-- This script fixes the password for the parent user created during admission

USE school_fee_register;

-- Update the parent user password with correct BCrypt hash for "password"
UPDATE users 
SET password = '$2a$10$dXJ3SW6G7P50lGmMkkmwe.20cQQubK3.HZWzG3YB1tlRy.fqvM/BG' 
WHERE username = '9876543210';

-- Verify the update
SELECT username, LENGTH(password) as password_length, role, phone 
FROM users 
WHERE username = '9876543210'; 