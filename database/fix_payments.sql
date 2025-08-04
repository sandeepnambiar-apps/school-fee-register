-- Fix payments table - Change amount column from FLOAT to DECIMAL(10,2)
-- This script fixes the schema validation error in the Fee Service

USE school_fee_register;

-- Disable foreign key checks temporarily
SET FOREIGN_KEY_CHECKS = 0;

-- Backup the current data
CREATE TEMPORARY TABLE payments_backup AS 
SELECT * FROM payments;

-- Drop the existing table
DROP TABLE IF EXISTS payments;

-- Recreate the table with correct column types
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

-- Restore the data
INSERT INTO payments (
    id, student_fee_id, amount, payment_date, payment_method, reference_number, notes, created_at
)
SELECT 
    id, student_fee_id, CAST(amount AS DECIMAL(10,2)), payment_date, payment_method, reference_number, notes, created_at
FROM payments_backup;

-- Drop the backup table
DROP TEMPORARY TABLE payments_backup;

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;

-- Verify the fix
SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    NUMERIC_PRECISION, 
    NUMERIC_SCALE
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = 'school_fee_register' 
    AND TABLE_NAME = 'payments' 
    AND COLUMN_NAME = 'amount';

-- Show sample data to verify
SELECT * FROM payments LIMIT 5; 