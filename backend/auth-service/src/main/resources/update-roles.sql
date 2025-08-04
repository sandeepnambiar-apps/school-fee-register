-- Update Roles Script for School Fee Register Application
-- Run this script to update existing databases with the new role structure

-- Update existing admin users to SUPER_ADMIN (for backward compatibility)
UPDATE users SET role = 'SUPER_ADMIN' WHERE role = 'ADMIN' AND username = 'admin';

-- Update test user to SCHOOL_ADMIN
UPDATE users SET role = 'SCHOOL_ADMIN' WHERE username = 'test';

-- Insert new SUPER_ADMIN user if not exists
INSERT INTO users (username, email, password, full_name, role, user_type, enabled, created_at) 
SELECT 'superadmin', 'superadmin@school.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'System Administrator', 'SUPER_ADMIN', 'ADMIN', true, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM users WHERE username = 'superadmin');

-- Insert new SCHOOL_ADMIN user if not exists
INSERT INTO users (username, email, password, full_name, role, user_type, enabled, created_at) 
SELECT 'schooladmin', 'schooladmin@school.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'School Administrator', 'SCHOOL_ADMIN', 'ADMIN', true, CURRENT_TIMESTAMP
WHERE NOT EXISTS (SELECT 1 FROM users WHERE username = 'schooladmin');

-- Display updated users
SELECT username, email, full_name, role, user_type FROM users ORDER BY role, username; 