-- Migration 002: Update Roles to Support SUPER_ADMIN and SCHOOL_ADMIN
-- This script updates the role enum and existing users

USE school_fee_register;

-- First, update existing ADMIN users to SUPER_ADMIN for backward compatibility
UPDATE users SET role = 'SUPER_ADMIN' WHERE role = 'ADMIN';

-- Alter the role enum to include the new roles
ALTER TABLE users MODIFY COLUMN role ENUM('STUDENT', 'PARENT', 'TEACHER', 'SCHOOL_ADMIN', 'SUPER_ADMIN') NOT NULL;

-- Insert new test users with the new roles
INSERT INTO users (username, email, password, full_name, role, user_type, enabled, created_at) 
SELECT 'superadmin', 'superadmin@school.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'System Administrator', 'SUPER_ADMIN', 'ADMIN', true, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM users WHERE username = 'superadmin');

INSERT INTO users (username, email, password, full_name, role, user_type, enabled, created_at) 
SELECT 'schooladmin', 'schooladmin@school.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'School Administrator', 'SCHOOL_ADMIN', 'ADMIN', true, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM users WHERE username = 'schooladmin');

-- Update test user to SCHOOL_ADMIN
UPDATE users SET role = 'SCHOOL_ADMIN' WHERE username = 'test';

-- Display updated users
SELECT username, email, full_name, role, user_type, enabled FROM users ORDER BY role, username; 