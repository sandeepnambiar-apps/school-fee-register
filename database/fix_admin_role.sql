-- Fix ADMIN role issue in change password functionality
-- The Java code expects SUPER_ADMIN and SCHOOL_ADMIN, but database has ADMIN

USE school_fee_register;

-- First, check if the users table exists and what roles it has
SELECT DISTINCT role FROM users WHERE role IS NOT NULL;

-- Update any existing ADMIN users to SUPER_ADMIN
UPDATE users SET role = 'SUPER_ADMIN' WHERE role = 'ADMIN';

-- Update the role enum to match the Java UserRole enum
ALTER TABLE users MODIFY COLUMN role ENUM('SUPER_ADMIN', 'SCHOOL_ADMIN', 'TEACHER', 'PARENT') NOT NULL;

-- Verify the fix
SELECT DISTINCT role FROM users WHERE role IS NOT NULL;

-- Show updated users
SELECT id, mobileNumber, name, role, schoolId FROM users ORDER BY id;

