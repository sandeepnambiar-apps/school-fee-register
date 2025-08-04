-- Fix Role Enum Values for Auth Service
-- The auth service expects: STUDENT, PARENT, TEACHER, SCHOOL_ADMIN, SUPER_ADMIN

USE school_fee_register;

-- First, update the role values to match auth service expectations
UPDATE users SET role = 'TEACHER' WHERE role = 'STAFF';

-- Now alter the enum to include the correct values
ALTER TABLE users MODIFY COLUMN role ENUM('STUDENT', 'PARENT', 'TEACHER', 'SCHOOL_ADMIN', 'SUPER_ADMIN') NOT NULL;

-- Add missing columns that auth service expects
ALTER TABLE users 
ADD COLUMN userType ENUM('STUDENT', 'PARENT', 'STAFF', 'ADMIN') AFTER role,
ADD COLUMN fullName VARCHAR(100) AFTER userType,
ADD COLUMN studentId BIGINT AFTER fullName,
ADD COLUMN enabled BOOLEAN DEFAULT TRUE AFTER studentId,
ADD COLUMN createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP AFTER enabled,
ADD COLUMN lastLoginAt TIMESTAMP NULL AFTER createdAt;

-- Update userType based on role
UPDATE users SET 
    userType = CASE 
        WHEN role = 'SUPER_ADMIN' THEN 'ADMIN'
        WHEN role = 'SCHOOL_ADMIN' THEN 'ADMIN'
        WHEN role = 'TEACHER' THEN 'STAFF'
        WHEN role = 'PARENT' THEN 'PARENT'
        WHEN role = 'STUDENT' THEN 'STUDENT'
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