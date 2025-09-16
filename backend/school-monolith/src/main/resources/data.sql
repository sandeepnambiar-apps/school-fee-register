-- Sample data for School Fee Register System (PostgreSQL)
-- This file is automatically executed when the application starts

-- Insert sample schools
INSERT INTO schools (id, name, school_code, address, phone, email, principal_name, is_active, created_at) VALUES
(1, 'Demo School', 'DEMO001', '123 Demo Street, Demo City', '9876543210', 'demo@school.com', 'Demo Principal', TRUE, NOW()),
(2, 'Sample Academy', 'SAMP001', '456 Sample Road, Sample City', '9876543211', 'sample@school.com', 'Sample Principal', TRUE, NOW()),
(3, 'BOON School', 'BOON', '789 BOON Avenue, BOON City', '9876543212', 'boon@school.com', 'BOON Principal', TRUE, NOW())
ON CONFLICT (id) DO NOTHING;

-- Insert sample users with encoded passwords (Welcome@123)
INSERT INTO users (id, mobile_number, password, name, email, role, school_id, is_active, is_first_time, created_at) VALUES
(1, '9999999999', '$2a$10$dXJ3SW6G7P50lGmMkkmwe.20cQQubK3.HZWzG3YB1tlRy.fqvM/BG', 'Super Admin', 'admin@school.com', 'SUPER_ADMIN', NULL, TRUE, FALSE, NOW()),
(2, '1111111111', '$2a$10$dXJ3SW6G7P50lGmMkkmwe.20cQQubK3.HZWzG3YB1tlRy.fqvM/BG', 'School 1 Admin', 'admin1@school.com', 'SCHOOL_ADMIN', 1, TRUE, FALSE, NOW()),
(3, '3333333333', '$2a$10$dXJ3SW6G7P50lGmMkkmwe.20cQQubK3.HZWzG3YB1tlRy.fqvM/BG', 'John Teacher', 'teacher1@school.com', 'TEACHER', 1, TRUE, FALSE, NOW()),
(4, '6666666666', '$2a$10$dXJ3SW6G7P50lGmMkkmwe.20cQQubK3.HZWzG3YB1tlRy.fqvM/BG', 'David Parent', 'parent1@school.com', 'PARENT', 1, TRUE, FALSE, NOW()),
(5, '5555555555', '$2a$10$dXJ3SW6G7P50lGmMkkmwe.20cQQubK3.HZWzG3YB1tlRy.fqvM/BG', 'Mike Teacher', 'teacher2@school.com', 'TEACHER', 2, TRUE, FALSE, NOW()),
(6, '8888888888', '$2a$10$dXJ3SW6G7P50lGmMkkmwe.20cQQubK3.HZWzG3YB1tlRy.fqvM/BG', 'Robert Parent', 'parent2@school.com', 'PARENT', 2, TRUE, FALSE, NOW())
ON CONFLICT (id) DO NOTHING;