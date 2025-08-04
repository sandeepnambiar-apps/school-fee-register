-- Create separate payment tables for student-service and fee-service
-- This follows microservices best practices with database per service

USE school_fee_register;

-- Disable foreign key checks temporarily
SET FOREIGN_KEY_CHECKS = 0;

-- Drop the existing unified payments table
DROP TABLE IF EXISTS payments;

-- Create student_payments table for student-service
CREATE TABLE student_payments (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    student_fee_id BIGINT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_date DATETIME NOT NULL,
    payment_method ENUM('CASH', 'BANK_TRANSFER', 'CARD', 'CHEQUE', 'ONLINE') NOT NULL,
    reference_number VARCHAR(100),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_fee_id) REFERENCES student_fees(id),
    INDEX idx_student_fee_id (student_fee_id),
    INDEX idx_payment_date (payment_date)
);

-- Create fee_payments table for fee-service
CREATE TABLE fee_payments (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    student_id BIGINT NOT NULL,
    fee_structure_id BIGINT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_method ENUM('CASH', 'BANK_TRANSFER', 'CARD', 'CHEQUE', 'ONLINE') NOT NULL,
    payment_status ENUM('PENDING', 'COMPLETED', 'FAILED', 'CANCELLED', 'REFUNDED') NOT NULL DEFAULT 'COMPLETED',
    transaction_id VARCHAR(255) UNIQUE,
    receipt_number VARCHAR(255) UNIQUE,
    payment_date DATETIME NOT NULL,
    due_date DATETIME,
    discount_amount DECIMAL(10,2),
    late_fee_amount DECIMAL(10,2),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(id),
    FOREIGN KEY (fee_structure_id) REFERENCES fee_structures(id),
    INDEX idx_student_id (student_id),
    INDEX idx_fee_structure_id (fee_structure_id),
    INDEX idx_payment_date (payment_date),
    INDEX idx_payment_status (payment_status)
);

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;

-- Verify the tables
DESCRIBE student_payments;
DESCRIBE fee_payments; 