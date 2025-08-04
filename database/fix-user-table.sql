-- Fix Users Table Structure for Auth Service
-- The auth service expects both 'role' and 'userType' columns

USE school_fee_register;

-- Add missing columns to match auth service User model
ALTER TABLE users 
ADD COLUMN role ENUM('STUDENT', 'PARENT', 'TEACHER', 'ADMIN') AFTER password,
ADD COLUMN userType ENUM('STUDENT', 'PARENT', 'STAFF', 'ADMIN') AFTER role,
ADD COLUMN fullName VARCHAR(100) AFTER userType,
ADD COLUMN studentId BIGINT AFTER fullName,
ADD COLUMN enabled BOOLEAN DEFAULT TRUE AFTER studentId,
ADD COLUMN createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP AFTER enabled,
ADD COLUMN lastLoginAt TIMESTAMP NULL AFTER createdAt;

-- Update existing users with proper role mapping
UPDATE users SET 
    role = CASE 
        WHEN username = 'admin' THEN 'ADMIN'
        WHEN username = 'teacher' THEN 'TEACHER'
        WHEN username = 'parent' THEN 'PARENT'
        WHEN username = 'staff1' THEN 'TEACHER'
        ELSE 'PARENT'
    END,
    userType = CASE 
        WHEN username = 'admin' THEN 'ADMIN'
        WHEN username = 'teacher' THEN 'STAFF'
        WHEN username = 'parent' THEN 'PARENT'
        WHEN username = 'staff1' THEN 'STAFF'
        ELSE 'PARENT'
    END,
    fullName = CASE 
        WHEN username = 'admin' THEN 'School Admin'
        WHEN username = 'teacher' THEN 'Jane Teacher'
        WHEN username = 'parent' THEN 'John Parent'
        WHEN username = 'staff1' THEN 'John Staff'
        ELSE CONCAT(first_name, ' ', last_name)
    END,
    enabled = TRUE;

-- Verify the structure
DESCRIBE users;

-- Show updated users
SELECT username, email, role, userType, fullName, enabled FROM users ORDER BY username; 