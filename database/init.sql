-- School Fee Register Database Initialization Script
-- Run this script to initialize the database manually

-- Create database if not exists
CREATE DATABASE IF NOT EXISTS school_fee_register;
USE school_fee_register;

-- Drop tables if they exist (for clean setup)
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS student_fees;
DROP TABLE IF EXISTS fee_structures;
DROP TABLE IF EXISTS fee_categories;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS academic_years;
DROP TABLE IF EXISTS classes;
DROP TABLE IF EXISTS audit_logs;
DROP TABLE IF EXISTS users;

-- Create classes table
CREATE TABLE classes (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    class_name VARCHAR(50) NOT NULL,
    class_level INT NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create academic_years table
CREATE TABLE academic_years (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    year_name VARCHAR(20) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create fee_categories table
CREATE TABLE fee_categories (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create students table
CREATE TABLE students (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    student_id VARCHAR(20) NOT NULL UNIQUE,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE,
    gender ENUM('MALE', 'FEMALE', 'OTHER'),
    address TEXT,
    phone VARCHAR(20),
    email VARCHAR(100),
    parent_name VARCHAR(100),
    parent_phone VARCHAR(20),
    parent_email VARCHAR(100),
    class_id BIGINT,
    academic_year_id BIGINT,
    admission_date DATE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (class_id) REFERENCES classes(id),
    FOREIGN KEY (academic_year_id) REFERENCES academic_years(id),
    INDEX idx_student_id (student_id),
    INDEX idx_class_id (class_id),
    INDEX idx_academic_year_id (academic_year_id),
    INDEX idx_is_active (is_active)
);

-- Create fee_structures table
CREATE TABLE fee_structures (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    class_id BIGINT NOT NULL,
    fee_category_id BIGINT NOT NULL,
    academic_year_id BIGINT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    frequency ENUM('MONTHLY', 'QUARTERLY', 'SEMESTER', 'ANNUAL'),
    due_date DATE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (class_id) REFERENCES classes(id),
    FOREIGN KEY (fee_category_id) REFERENCES fee_categories(id),
    FOREIGN KEY (academic_year_id) REFERENCES academic_years(id),
    INDEX idx_class_id (class_id),
    INDEX idx_fee_category_id (fee_category_id),
    INDEX idx_academic_year_id (academic_year_id),
    INDEX idx_is_active (is_active)
);

-- Create student_fees table
CREATE TABLE student_fees (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    student_id BIGINT NOT NULL,
    fee_structure_id BIGINT NOT NULL,
    academic_year_id BIGINT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    discount_amount DECIMAL(10,2) DEFAULT 0.00,
    net_amount DECIMAL(10,2) NOT NULL,
    due_date DATE NOT NULL,
    status ENUM('PENDING', 'PAID', 'PARTIAL', 'OVERDUE') DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(id),
    FOREIGN KEY (fee_structure_id) REFERENCES fee_structures(id),
    FOREIGN KEY (academic_year_id) REFERENCES academic_years(id),
    INDEX idx_student_id (student_id),
    INDEX idx_fee_structure_id (fee_structure_id),
    INDEX idx_academic_year_id (academic_year_id),
    INDEX idx_status (status),
    INDEX idx_due_date (due_date)
);

-- Create payments table (for payment tracking)
CREATE TABLE payments (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    student_fee_id BIGINT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_date DATE NOT NULL,
    payment_method ENUM('CASH', 'BANK_TRANSFER', 'CARD', 'CHEQUE', 'ONLINE') NOT NULL,
    reference_number VARCHAR(100),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_fee_id) REFERENCES student_fees(id),
    INDEX idx_student_fee_id (student_fee_id),
    INDEX idx_payment_date (payment_date)
);

-- Create audit_logs table (for tracking changes)
CREATE TABLE audit_logs (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    table_name VARCHAR(50) NOT NULL,
    record_id BIGINT NOT NULL,
    action ENUM('INSERT', 'UPDATE', 'DELETE') NOT NULL,
    old_values JSON,
    new_values JSON,
    user_id VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_table_name (table_name),
    INDEX idx_record_id (record_id),
    INDEX idx_created_at (created_at)
);

-- Create users table for authentication and authorization
CREATE TABLE users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('ADMIN', 'STAFF', 'PARENT') NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone VARCHAR(20),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Insert sample data
-- Academic Years
INSERT INTO academic_years (year_name, start_date, end_date, is_active) VALUES
('2024-2025', '2024-06-01', '2025-05-31', TRUE),
('2023-2024', '2023-06-01', '2024-05-31', FALSE),
('2025-2026', '2025-06-01', '2026-05-31', FALSE);

-- Classes
INSERT INTO classes (class_name, class_level, description, is_active) VALUES
('Class 1', 1, 'First Grade - Primary School', TRUE),
('Class 2', 2, 'Second Grade - Primary School', TRUE),
('Class 3', 3, 'Third Grade - Primary School', TRUE),
('Class 4', 4, 'Fourth Grade - Primary School', TRUE),
('Class 5', 5, 'Fifth Grade - Primary School', TRUE),
('Class 6', 6, 'Sixth Grade - Middle School', TRUE),
('Class 7', 7, 'Seventh Grade - Middle School', TRUE),
('Class 8', 8, 'Eighth Grade - Middle School', TRUE),
('Class 9', 9, 'Ninth Grade - High School', TRUE),
('Class 10', 10, 'Tenth Grade - High School', TRUE);

-- Fee Categories
INSERT INTO fee_categories (category_name, description, is_active) VALUES
('Tuition Fee', 'Monthly tuition fee for academic instruction', TRUE),
('Library Fee', 'Annual library membership and book access', TRUE),
('Laboratory Fee', 'Science lab equipment and materials', TRUE),
('Sports Fee', 'Physical education and sports facilities', TRUE),
('Computer Fee', 'Computer lab access and IT resources', TRUE),
('Transportation Fee', 'School bus service (optional)', TRUE),
('Examination Fee', 'Term and final examination charges', TRUE),
('Development Fee', 'School infrastructure and development', TRUE),
('Admission Fee', 'One-time admission processing fee', TRUE),
('Uniform Fee', 'School uniform and dress code items', TRUE);

-- Students
INSERT INTO students (student_id, first_name, last_name, date_of_birth, gender, address, phone, email, parent_name, parent_phone, parent_email, class_id, academic_year_id, admission_date, is_active) VALUES
('STU001', 'John', 'Smith', '2015-03-15', 'MALE', '123 Main Street, City Center', '+1234567890', 'john.smith@email.com', 'Michael Smith', '+1234567891', 'michael.smith@email.com', 1, 1, '2024-06-01', TRUE),
('STU002', 'Emma', 'Johnson', '2015-07-22', 'FEMALE', '456 Oak Avenue, Downtown', '+1234567892', 'emma.johnson@email.com', 'Sarah Johnson', '+1234567893', 'sarah.johnson@email.com', 1, 1, '2024-06-01', TRUE),
('STU003', 'Michael', 'Brown', '2014-11-08', 'MALE', '789 Pine Road, Suburb', '+1234567894', 'michael.brown@email.com', 'David Brown', '+1234567895', 'david.brown@email.com', 2, 1, '2024-06-01', TRUE),
('STU004', 'Sophia', 'Davis', '2014-05-12', 'FEMALE', '321 Elm Street, Westside', '+1234567896', 'sophia.davis@email.com', 'Robert Davis', '+1234567897', 'robert.davis@email.com', 2, 1, '2024-06-01', TRUE),
('STU005', 'William', 'Wilson', '2013-09-30', 'MALE', '654 Maple Drive, Eastside', '+1234567898', 'william.wilson@email.com', 'James Wilson', '+1234567899', 'james.wilson@email.com', 3, 1, '2024-06-01', TRUE);

-- Fee Structures
INSERT INTO fee_structures (class_id, fee_category_id, academic_year_id, amount, frequency, due_date, is_active) VALUES
-- Class 1 Fee Structures
(1, 1, 1, 500.00, 'MONTHLY', '2024-07-05', TRUE),  -- Tuition Fee
(1, 2, 1, 200.00, 'ANNUAL', '2024-07-15', TRUE),   -- Library Fee
(1, 3, 1, 150.00, 'ANNUAL', '2024-07-20', TRUE),   -- Laboratory Fee
(1, 4, 1, 100.00, 'ANNUAL', '2024-07-25', TRUE),   -- Sports Fee
(1, 5, 1, 120.00, 'ANNUAL', '2024-08-01', TRUE),   -- Computer Fee

-- Class 2 Fee Structures
(2, 1, 1, 550.00, 'MONTHLY', '2024-07-05', TRUE),  -- Tuition Fee
(2, 2, 1, 220.00, 'ANNUAL', '2024-07-15', TRUE),   -- Library Fee
(2, 3, 1, 170.00, 'ANNUAL', '2024-07-20', TRUE),   -- Laboratory Fee
(2, 4, 1, 110.00, 'ANNUAL', '2024-07-25', TRUE),   -- Sports Fee
(2, 5, 1, 130.00, 'ANNUAL', '2024-08-01', TRUE),   -- Computer Fee

-- Class 3 Fee Structures
(3, 1, 1, 600.00, 'MONTHLY', '2024-07-05', TRUE),  -- Tuition Fee
(3, 2, 1, 240.00, 'ANNUAL', '2024-07-15', TRUE),   -- Library Fee
(3, 3, 1, 190.00, 'ANNUAL', '2024-07-20', TRUE),   -- Laboratory Fee
(3, 4, 1, 120.00, 'ANNUAL', '2024-07-25', TRUE),   -- Sports Fee
(3, 5, 1, 140.00, 'ANNUAL', '2024-08-01', TRUE);   -- Computer Fee

-- Student Fees
INSERT INTO student_fees (student_id, fee_structure_id, academic_year_id, amount, discount_amount, net_amount, due_date, status) VALUES
-- Student 1 (STU001) - Class 1
(1, 1, 1, 500.00, 0.00, 500.00, '2024-07-05', 'PENDING'),  -- Tuition Fee
(1, 2, 1, 200.00, 0.00, 200.00, '2024-07-15', 'PENDING'),  -- Library Fee
(1, 3, 1, 150.00, 0.00, 150.00, '2024-07-20', 'PENDING'),  -- Laboratory Fee
(1, 4, 1, 100.00, 0.00, 100.00, '2024-07-25', 'PENDING'),  -- Sports Fee
(1, 5, 1, 120.00, 0.00, 120.00, '2024-08-01', 'PENDING'),  -- Computer Fee

-- Student 2 (STU002) - Class 1
(2, 1, 1, 500.00, 50.00, 450.00, '2024-07-05', 'PARTIAL'),  -- Tuition Fee (with discount)
(2, 2, 1, 200.00, 0.00, 200.00, '2024-07-15', 'PAID'),      -- Library Fee
(2, 3, 1, 150.00, 0.00, 150.00, '2024-07-20', 'PENDING'),  -- Laboratory Fee
(2, 4, 1, 100.00, 0.00, 100.00, '2024-07-25', 'PENDING'),  -- Sports Fee
(2, 5, 1, 120.00, 0.00, 120.00, '2024-08-01', 'PENDING');  -- Computer Fee

-- Users
INSERT INTO users (username, email, password, role, first_name, last_name, phone, is_active) VALUES
('admin', 'admin@school.com', '$2a$10$rAM0QZqZqZqZqZqZqZqZqO', 'ADMIN', 'Admin', 'User', '1234567890', TRUE),
('staff1', 'staff1@school.com', '$2a$10$rAM0QZqZqZqZqZqZqZqZqO', 'STAFF', 'John', 'Staff', '1234567891', TRUE),
('parent1', 'michael.smith@email.com', '$2a$10$rAM0QZqZqZqZqZqZqZqZqO', 'PARENT', 'Michael', 'Smith', '1234567890', TRUE);

-- Display success message
SELECT 'Database initialized successfully!' as message;
SELECT COUNT(*) as total_students FROM students;
SELECT COUNT(*) as total_fee_structures FROM fee_structures;
SELECT COUNT(*) as total_student_fees FROM student_fees; 