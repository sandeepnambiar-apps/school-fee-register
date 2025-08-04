-- Fix payments table structure to match Payment entity
-- This script recreates the payments table with the correct structure

USE school_fee_register;

-- Disable foreign key checks temporarily
SET FOREIGN_KEY_CHECKS = 0;

-- Backup existing data if any
CREATE TEMPORARY TABLE payments_backup AS 
SELECT * FROM payments;

-- Drop the existing table
DROP TABLE IF EXISTS payments;

-- Recreate the table with correct structure matching Payment entity
CREATE TABLE payments (
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

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;

-- Verify the table structure
DESCRIBE payments; 