-- Test Users for School Fee Register Application
-- This file will be automatically executed by Spring Boot on startup

-- Insert test users with encrypted passwords
-- Password for all users is: password (BCrypt encrypted with strength 10)

INSERT INTO users (username, email, password, full_name, role, user_type, enabled, created_at) 
VALUES 
-- SUPER_ADMIN: Full system access including server monitoring (for developers/support)
('superadmin', 'superadmin@school.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'System Administrator', 'SUPER_ADMIN', 'ADMIN', true, CURRENT_TIMESTAMP),

-- SCHOOL_ADMIN: Complete business functionality without server monitoring (for school management)
('schooladmin', 'schooladmin@school.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'School Administrator', 'SCHOOL_ADMIN', 'ADMIN', true, CURRENT_TIMESTAMP),

-- Legacy admin user (kept for backward compatibility)
('admin', 'admin@school.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Admin User', 'SUPER_ADMIN', 'ADMIN', true, CURRENT_TIMESTAMP),

-- Teacher user
('teacher1', 'teacher1@school.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'John Teacher', 'TEACHER', 'STAFF', true, CURRENT_TIMESTAMP),

-- Parent user
('parent1', 'parent1@email.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Jane Parent', 'PARENT', 'PARENT', true, CURRENT_TIMESTAMP),

-- Student user
('student1', 'student1@school.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Bob Student', 'STUDENT', 'STUDENT', true, CURRENT_TIMESTAMP),

-- Test user (updated to SCHOOL_ADMIN)
('test', 'test@test.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Test User', 'SCHOOL_ADMIN', 'ADMIN', true, CURRENT_TIMESTAMP); 
