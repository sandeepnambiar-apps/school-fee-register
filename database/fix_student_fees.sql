-- Fix student_fees table - Change amount columns from FLOAT to DECIMAL(10,2)
-- This script fixes the schema validation error in the Fee Service

USE school_fee_register;

-- Disable foreign key checks temporarily
SET FOREIGN_KEY_CHECKS = 0;

-- Backup the current data
CREATE TEMPORARY TABLE student_fees_backup AS 
SELECT * FROM student_fees;

-- Drop the existing table
DROP TABLE IF EXISTS student_fees;

-- Recreate the table with correct column types
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

-- Restore the data
INSERT INTO student_fees (
    id, student_id, fee_structure_id, academic_year_id, 
    amount, discount_amount, net_amount, due_date, status, created_at
)
SELECT 
    id, student_id, fee_structure_id, academic_year_id, 
    CAST(amount AS DECIMAL(10,2)), 
    CAST(discount_amount AS DECIMAL(10,2)), 
    CAST(net_amount AS DECIMAL(10,2)), 
    due_date, status, created_at
FROM student_fees_backup;

-- Drop the backup table
DROP TEMPORARY TABLE student_fees_backup;

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
    AND TABLE_NAME = 'student_fees' 
    AND COLUMN_NAME IN ('amount', 'discount_amount', 'net_amount');

-- Show sample data to verify
SELECT * FROM student_fees LIMIT 5; 