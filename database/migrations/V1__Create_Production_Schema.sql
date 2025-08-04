-- Production Database Migration V1
-- This script creates the complete schema for production

-- Create databases if they don't exist
CREATE DATABASE IF NOT EXISTS school_auth_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS school_fee_register CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Use auth database
USE school_auth_db;

-- Create users table for authentication
CREATE TABLE IF NOT EXISTS users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    role ENUM('STUDENT', 'PARENT', 'TEACHER', 'SCHOOL_ADMIN', 'SUPER_ADMIN') NOT NULL,
    user_type ENUM('STUDENT', 'PARENT', 'STAFF', 'ADMIN') NOT NULL,
    student_id BIGINT NULL,
    enabled BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login_at TIMESTAMP NULL,
    INDEX idx_username (username),
    INDEX idx_email (email),
    INDEX idx_student_id (student_id),
    INDEX idx_role (role)
);

-- Use main database
USE school_fee_register;

-- Create academic_years table
CREATE TABLE IF NOT EXISTS academic_years (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(20) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    is_active BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_is_active (is_active)
);

-- Create classes table
CREATE TABLE IF NOT EXISTS classes (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(20) NOT NULL,
    section VARCHAR(10) NOT NULL,
    academic_year_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (academic_year_id) REFERENCES academic_years(id),
    INDEX idx_academic_year (academic_year_id)
);

-- Create students table
CREATE TABLE IF NOT EXISTS students (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    admission_number VARCHAR(20) NOT NULL UNIQUE,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender ENUM('MALE', 'FEMALE', 'OTHER') NOT NULL,
    class_id BIGINT NOT NULL,
    parent_name VARCHAR(100) NOT NULL,
    parent_phone VARCHAR(20) NOT NULL,
    parent_email VARCHAR(100),
    address TEXT,
    admission_date DATE NOT NULL,
    status ENUM('ACTIVE', 'INACTIVE', 'TRANSFERRED', 'GRADUATED') DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (class_id) REFERENCES classes(id),
    INDEX idx_admission_number (admission_number),
    INDEX idx_parent_phone (parent_phone),
    INDEX idx_status (status),
    INDEX idx_class_id (class_id)
);

-- Create fee_structures table
CREATE TABLE IF NOT EXISTS fee_structures (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    class_id BIGINT NOT NULL,
    academic_year_id BIGINT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (class_id) REFERENCES classes(id),
    FOREIGN KEY (academic_year_id) REFERENCES academic_years(id),
    INDEX idx_class_academic (class_id, academic_year_id),
    INDEX idx_is_active (is_active)
);

-- Create fee_components table
CREATE TABLE IF NOT EXISTS fee_components (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    fee_structure_id BIGINT NOT NULL,
    name VARCHAR(50) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    description TEXT,
    is_optional BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (fee_structure_id) REFERENCES fee_structures(id),
    INDEX idx_fee_structure (fee_structure_id)
);

-- Create student_fees table
CREATE TABLE IF NOT EXISTS student_fees (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    student_id BIGINT NOT NULL,
    fee_structure_id BIGINT NOT NULL,
    academic_year_id BIGINT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    net_amount DECIMAL(10,2) NOT NULL,
    discount_amount DECIMAL(10,2) DEFAULT 0.00,
    due_date DATE NOT NULL,
    status ENUM('PENDING', 'PAID', 'PARTIAL', 'OVERDUE') DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(id),
    FOREIGN KEY (fee_structure_id) REFERENCES fee_structures(id),
    FOREIGN KEY (academic_year_id) REFERENCES academic_years(id),
    INDEX idx_student_academic (student_id, academic_year_id),
    INDEX idx_status (status),
    INDEX idx_due_date (due_date)
);

-- Create payments table
CREATE TABLE IF NOT EXISTS payments (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    student_fee_id BIGINT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_date DATE NOT NULL,
    payment_method ENUM('CASH', 'CHEQUE', 'ONLINE', 'CARD') NOT NULL,
    transaction_id VARCHAR(100),
    status ENUM('PENDING', 'COMPLETED', 'FAILED', 'CANCELLED') DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (student_fee_id) REFERENCES student_fees(id),
    INDEX idx_student_fee (student_fee_id),
    INDEX idx_payment_date (payment_date),
    INDEX idx_status (status)
);

-- Create transport_routes table
CREATE TABLE IF NOT EXISTS transport_routes (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    route_name VARCHAR(100) NOT NULL,
    start_location VARCHAR(100) NOT NULL,
    end_location VARCHAR(100) NOT NULL,
    fare DECIMAL(10,2) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_is_active (is_active)
);

-- Create transport_fees table
CREATE TABLE IF NOT EXISTS transport_fees (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    student_id BIGINT NOT NULL,
    route_id BIGINT NOT NULL,
    academic_year_id BIGINT NOT NULL,
    monthly_fare DECIMAL(10,2) NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    status ENUM('PENDING', 'PAID', 'PARTIAL') DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(id),
    FOREIGN KEY (route_id) REFERENCES transport_routes(id),
    FOREIGN KEY (academic_year_id) REFERENCES academic_years(id),
    INDEX idx_student_academic (student_id, academic_year_id),
    INDEX idx_status (status)
);

-- Create notifications table
CREATE TABLE IF NOT EXISTS notifications (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    type ENUM('GENERAL', 'FEE_REMINDER', 'EVENT', 'HOMEWORK', 'ATTENDANCE') NOT NULL,
    recipient_type ENUM('ALL', 'PARENT', 'TEACHER', 'STUDENT') NOT NULL,
    recipient_id BIGINT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_recipient (recipient_type, recipient_id),
    INDEX idx_type (type),
    INDEX idx_is_read (is_read)
);

-- Create homework table
CREATE TABLE IF NOT EXISTS homework (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    subject VARCHAR(50) NOT NULL,
    class_id BIGINT NOT NULL,
    due_date DATE NOT NULL,
    assigned_by VARCHAR(50) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (class_id) REFERENCES classes(id),
    INDEX idx_class_id (class_id),
    INDEX idx_due_date (due_date),
    INDEX idx_is_active (is_active)
);

-- Create timetable table
CREATE TABLE IF NOT EXISTS timetable (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    class_id BIGINT NOT NULL,
    day_of_week ENUM('MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY') NOT NULL,
    period_number INT NOT NULL,
    subject VARCHAR(50) NOT NULL,
    teacher_id VARCHAR(50) NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    room_number VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (class_id) REFERENCES classes(id),
    INDEX idx_class_day (class_id, day_of_week),
    INDEX idx_teacher (teacher_id)
);

-- Create calendar_events table
CREATE TABLE IF NOT EXISTS calendar_events (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    event_date DATE NOT NULL,
    event_type ENUM('HOLIDAY', 'EVENT', 'MEETING', 'EXAM') NOT NULL,
    is_holiday BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_event_date (event_date),
    INDEX idx_event_type (event_type),
    INDEX idx_is_holiday (is_holiday)
); 