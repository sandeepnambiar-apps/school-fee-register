-- School Fee Register Database Setup
-- Run this script in your MySQL database

-- Create database if not exists
CREATE DATABASE IF NOT EXISTS school_fee_register;
USE school_fee_register;

-- Create users table
CREATE TABLE IF NOT EXISTS users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    mobile_number VARCHAR(20) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    role ENUM('SUPER_ADMIN', 'SCHOOL_ADMIN', 'TEACHER', 'PARENT') NOT NULL,
    school_id BIGINT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    is_first_time BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
    class_assigned VARCHAR(50) NULL,
    subject_taught VARCHAR(100) NULL,
    parent_id BIGINT NULL
);

-- Create students table
CREATE TABLE IF NOT EXISTS students (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    class_name VARCHAR(50) NOT NULL,
    section VARCHAR(20) NOT NULL,
    gender ENUM('MALE', 'FEMALE') NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    roll_number VARCHAR(20) NULL,
    date_of_birth DATE NULL,
    father_name VARCHAR(100) NOT NULL,
    father_phone VARCHAR(20) NOT NULL,
    mother_name VARCHAR(100) NOT NULL,
    mother_phone VARCHAR(20) NOT NULL,
    address TEXT NOT NULL,
    admission_date DATE NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at DATE DEFAULT (CURRENT_DATE),
    updated_at DATE NULL,
    kid_aadhaar VARCHAR(12) NOT NULL,
    pen VARCHAR(20) NOT NULL,
    father_aadhaar VARCHAR(12) NOT NULL,
    mother_aadhaar VARCHAR(12) NOT NULL
);

-- Create schools table
CREATE TABLE IF NOT EXISTS schools (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    code VARCHAR(20) UNIQUE NOT NULL,
    address TEXT NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(100) NOT NULL,
    principal_name VARCHAR(100) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP
);

-- Insert sample schools
INSERT INTO schools (name, code, address, phone, email, principal_name) VALUES
('Demo School', 'DEMO001', '123 Demo Street, Demo City', '9876543210', 'demo@school.com', 'Demo Principal'),
('Sample Academy', 'SAMP001', '456 Sample Road, Sample City', '9876543211', 'sample@school.com', 'Sample Principal'),
('BOON School', 'BOON', '789 BOON Avenue, BOON City', '9876543212', 'boon@school.com', 'BOON Principal')
ON DUPLICATE KEY UPDATE name = VALUES(name);

-- Insert sample users with proper password encoding
INSERT INTO users (mobile_number, password, name, email, role, school_id, is_first_time) VALUES
('9999999999', '$2a$10$dXJ3SW6G7P50lGmMkkmwe.20cQQubK3.HZWzG3YB1tlRy.fqvM/BG', 'Super Admin', 'admin@school.com', 'SUPER_ADMIN', NULL, FALSE),
('1111111111', '$2a$10$dXJ3SW6G7P50lGmMkkmwe.20cQQubK3.HZWzG3YB1tlRy.fqvM/BG', 'School 1 Admin', 'admin1@school.com', 'SCHOOL_ADMIN', 1, FALSE),
('3333333333', '$2a$10$dXJ3SW6G7P50lGmMkkmwe.20cQQubK3.HZWzG3YB1tlRy.fqvM/BG', 'John Teacher', 'teacher1@school.com', 'TEACHER', 1, FALSE),
('6666666666', '$2a$10$dXJ3SW6G7P50lGmMkkmwe.20cQQubK3.HZWzG3YB1tlRy.fqvM/BG', 'David Parent', 'parent1@school.com', 'PARENT', 1, FALSE),
('5555555555', '$2a$10$dXJ3SW6G7P50lGmMkkmwe.20cQQubK3.HZWzG3YB1tlRy.fqvM/BG', 'Mike Teacher', 'teacher2@school.com', 'TEACHER', 2, FALSE),
('8888888888', '$2a$10$dXJ3SW6G7P50lGmMkkmwe.20cQQubK3.HZWzG3YB1tlRy.fqvM/BG', 'Robert Parent', 'parent2@school.com', 'PARENT', 2, FALSE)
ON DUPLICATE KEY UPDATE 
    password = VALUES(password),
    name = VALUES(name),
    email = VALUES(email),
    role = VALUES(role),
    school_id = VALUES(school_id),
    is_first_time = VALUES(is_first_time);

-- Create fee structures table
CREATE TABLE IF NOT EXISTS fee_structures (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    fee_type VARCHAR(100) NOT NULL,
    description TEXT,
    amount DECIMAL(10,2) NOT NULL,
    frequency VARCHAR(20) NOT NULL,
    class_name VARCHAR(50) NOT NULL,
    due_date DATE NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    school_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP
);

-- Create fee payments table
CREATE TABLE IF NOT EXISTS fee_payments (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    student_id BIGINT NOT NULL,
    student_name VARCHAR(100) NOT NULL,
    fee_structure_id BIGINT NOT NULL,
    fee_type VARCHAR(100) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    paid_amount DECIMAL(10,2) DEFAULT 0.00,
    due_date DATE NOT NULL,
    paid_date DATE NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Pending',
    payment_method VARCHAR(50) NULL,
    transaction_id VARCHAR(100) NULL,
    receipt_number VARCHAR(100) NULL,
    notes TEXT NULL,
    school_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP
);

-- Insert sample fee structures
INSERT INTO fee_structures (fee_type, description, amount, frequency, class_name, due_date, school_id) VALUES
('Tuition Fee', 'Monthly tuition fee for academic instruction', 1000.00, 'monthly', 'All', '2024-01-31', 1),
('Transportation Fee', 'Monthly transportation fee for bus service', 500.00, 'monthly', 'All', '2024-02-15', 1),
('Library Fee', 'Annual library membership fee', 300.00, 'yearly', 'All', '2024-03-10', 1),
('Sports Fee', 'Physical education and sports facilities', 200.00, 'yearly', 'All', '2024-04-20', 1),
('Computer Fee', 'Computer lab access and IT resources', 400.00, 'yearly', 'All', '2024-05-15', 1)
ON DUPLICATE KEY UPDATE 
    description = VALUES(description),
    amount = VALUES(amount),
    frequency = VALUES(frequency),
    class_name = VALUES(class_name),
    due_date = VALUES(due_date);

-- Insert sample fee payments
INSERT INTO fee_payments (student_id, student_name, fee_structure_id, fee_type, amount, paid_amount, due_date, paid_date, status, payment_method, transaction_id, receipt_number, school_id) VALUES
(1, 'John Doe', 1, 'Tuition Fee', 1000.00, 1000.00, '2024-01-31', '2024-01-15', 'Completed', 'Online', 'TXN001', 'R001', 1),
(1, 'John Doe', 2, 'Transportation Fee', 500.00, 250.00, '2024-02-15', '2024-01-20', 'Partially Paid', 'Cash', 'TXN002', 'R002', 1),
(1, 'John Doe', 3, 'Library Fee', 300.00, 150.00, '2024-03-10', '2024-02-05', 'Partially Paid', 'Online', 'TXN003', 'R003', 1),
(1, 'John Doe', 4, 'Sports Fee', 200.00, 0.00, '2024-04-20', NULL, 'Pending', 'N/A', NULL, NULL, 1),
(1, 'John Doe', 5, 'Computer Fee', 400.00, 0.00, '2024-05-15', NULL, 'Pending', 'N/A', NULL, NULL, 1)
ON DUPLICATE KEY UPDATE 
    student_name = VALUES(student_name),
    fee_structure_id = VALUES(fee_structure_id),
    fee_type = VALUES(fee_type),
    amount = VALUES(amount),
    paid_amount = VALUES(paid_amount),
    due_date = VALUES(due_date),
    paid_date = VALUES(paid_date),
    status = VALUES(status),
    payment_method = VALUES(payment_method),
    transaction_id = VALUES(transaction_id),
    receipt_number = VALUES(receipt_number);

-- Show success message
SELECT 'Database setup completed successfully!' as message;
