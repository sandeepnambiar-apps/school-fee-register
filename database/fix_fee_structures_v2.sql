-- Fix fee_structures table - Change amount column from FLOAT to DECIMAL(10,2)
-- This script fixes the schema validation error in the Fee Service
-- Handles foreign key constraints properly

USE school_fee_register;

-- Disable foreign key checks temporarily
SET FOREIGN_KEY_CHECKS = 0;

-- Backup the current data
CREATE TEMPORARY TABLE fee_structures_backup AS 
SELECT * FROM fee_structures;

-- Drop the existing table
DROP TABLE IF EXISTS fee_structures;

-- Recreate the table with correct column types
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

-- Restore the data
INSERT INTO fee_structures (
    id, class_id, fee_category_id, academic_year_id, 
    amount, frequency, due_date, is_active, created_at
)
SELECT 
    id, class_id, fee_category_id, academic_year_id, 
    CAST(amount AS DECIMAL(10,2)), frequency, due_date, is_active, created_at
FROM fee_structures_backup;

-- Drop the backup table
DROP TEMPORARY TABLE fee_structures_backup;

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
    AND TABLE_NAME = 'fee_structures' 
    AND COLUMN_NAME = 'amount';

-- Show sample data to verify
SELECT * FROM fee_structures LIMIT 5; 