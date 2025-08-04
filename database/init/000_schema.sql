-- School Fee Register Database Schema
-- MySQL Database Schema for School Fee Management System

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

-- Users table for authentication and authorization
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

-- Fee discounts
CREATE TABLE fee_discounts (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    discount_type ENUM('PERCENTAGE', 'FIXED_AMOUNT') NOT NULL,
    discount_value DECIMAL(10,2) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Student discounts
CREATE TABLE student_discounts (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    student_id BIGINT,
    discount_id BIGINT,
    academic_year_id BIGINT,
    amount DECIMAL(10,2) NOT NULL,
    reason TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(id),
    FOREIGN KEY (discount_id) REFERENCES fee_discounts(id),
    FOREIGN KEY (academic_year_id) REFERENCES academic_years(id)
);

-- Insert sample data
INSERT INTO users (username, email, password, role, first_name, last_name, phone) VALUES
('admin', 'admin@school.com', '$2a$10$rAM0QZqZqZqZqZqZqZqZqO', 'ADMIN', 'School', 'Admin', '1234567890'),
('staff1', 'staff1@school.com', '$2a$10$rAM0QZqZqZqZqZqZqZqZqO', 'STAFF', 'John', 'Staff', '1234567891');

INSERT INTO academic_years (year_name, start_date, end_date, is_active) VALUES
('2024-2025', '2024-06-01', '2025-05-31', TRUE);

INSERT INTO classes (class_name, class_level) VALUES
('Class 1', 1),
('Class 2', 2);

INSERT INTO fee_categories (category_name, description) VALUES
('Tuition Fee', 'Monthly tuition fee'),
('Library Fee', 'Annual library membership'),
('Sports Fee', 'Sports and physical education'),
('Laboratory Fee', 'Science laboratory usage'),
('Transport Fee', 'School bus transportation');

INSERT INTO fee_structures (class_id, fee_category_id, academic_year_id, amount, frequency, due_date) VALUES
(1, 1, 1, 5000.00, 'MONTHLY', '2024-06-05'),
(1, 2, 1, 2000.00, 'ANNUAL', '2024-06-15'),
(1, 3, 1, 1500.00, 'ANNUAL', '2024-06-20'),
(2, 1, 1, 5000.00, 'MONTHLY', '2024-06-05'),
(2, 2, 1, 2000.00, 'ANNUAL', '2024-06-15');

INSERT INTO fee_discounts (name, description, discount_type, discount_value) VALUES
('Sibling Discount', 'Discount for siblings', 'PERCENTAGE', 10.00),
('Early Payment', 'Discount for early payment', 'PERCENTAGE', 5.00),
('Scholarship', 'Merit-based scholarship', 'FIXED_AMOUNT', 1000.00); 