-- Fix all remaining FLOAT columns to DECIMAL(10,2)
-- This script fixes all schema validation errors in the Fee Service

USE school_fee_register;

-- Disable foreign key checks temporarily
SET FOREIGN_KEY_CHECKS = 0;

-- 1. Fix fee_discounts table
CREATE TEMPORARY TABLE fee_discounts_backup AS SELECT * FROM fee_discounts;
DROP TABLE IF EXISTS fee_discounts;
CREATE TABLE fee_discounts (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    discount_type ENUM('PERCENTAGE', 'FIXED_AMOUNT') NOT NULL,
    discount_value DECIMAL(10,2) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO fee_discounts SELECT id, name, description, discount_type, CAST(discount_value AS DECIMAL(10,2)), is_active, created_at FROM fee_discounts_backup;
DROP TEMPORARY TABLE fee_discounts_backup;

-- 2. Fix student_discounts table
CREATE TEMPORARY TABLE student_discounts_backup AS SELECT * FROM student_discounts;
DROP TABLE IF EXISTS student_discounts;
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
INSERT INTO student_discounts SELECT id, student_id, discount_id, academic_year_id, CAST(amount AS DECIMAL(10,2)), reason, created_at FROM student_discounts_backup;
DROP TEMPORARY TABLE student_discounts_backup;

-- 3. Fix homework_submissions table
CREATE TEMPORARY TABLE homework_submissions_backup AS SELECT * FROM homework_submissions;
DROP TABLE IF EXISTS homework_submissions;
CREATE TABLE homework_submissions (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    homework_id BIGINT NOT NULL,
    student_id BIGINT NOT NULL,
    submission_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    submission_text TEXT,
    attachment_url VARCHAR(500),
    attachment_name VARCHAR(255),
    grade DECIMAL(5,2),
    feedback TEXT,
    status ENUM('SUBMITTED', 'GRADED', 'LATE') DEFAULT 'SUBMITTED',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (homework_id) REFERENCES homework(id) ON DELETE CASCADE,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    UNIQUE KEY unique_homework_student (homework_id, student_id),
    INDEX idx_submission_homework (homework_id),
    INDEX idx_submission_student (student_id),
    INDEX idx_submission_status (status)
);
INSERT INTO homework_submissions SELECT id, homework_id, student_id, submission_date, submission_text, attachment_url, attachment_name, CAST(grade AS DECIMAL(5,2)), feedback, status, created_at, updated_at FROM homework_submissions_backup;
DROP TEMPORARY TABLE homework_submissions_backup;

-- 4. Fix transport_routes table (if it exists)
CREATE TEMPORARY TABLE transport_routes_backup AS SELECT * FROM transport_routes;
DROP TABLE IF EXISTS transport_routes;
CREATE TABLE transport_routes (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    route_name VARCHAR(100) NOT NULL,
    start_location VARCHAR(100) NOT NULL,
    end_location VARCHAR(100) NOT NULL,
    distance_km DECIMAL(10,2) NOT NULL,
    monthly_fee DECIMAL(10,2) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO transport_routes SELECT id, route_name, start_location, end_location, CAST(distance_km AS DECIMAL(10,2)), CAST(monthly_fee AS DECIMAL(10,2)), is_active, created_at FROM transport_routes_backup;
DROP TEMPORARY TABLE transport_routes_backup;

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;

-- Verify all fixes
SELECT 
    TABLE_NAME,
    COLUMN_NAME, 
    DATA_TYPE, 
    NUMERIC_PRECISION, 
    NUMERIC_SCALE
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = 'school_fee_register' 
    AND DATA_TYPE = 'decimal'
    AND COLUMN_NAME IN ('amount', 'discount_value', 'grade', 'distance_km', 'monthly_fee')
ORDER BY TABLE_NAME, COLUMN_NAME;

-- Show summary of all tables with decimal columns
SELECT 
    TABLE_NAME,
    COUNT(*) as decimal_columns
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = 'school_fee_register' 
    AND DATA_TYPE = 'decimal'
GROUP BY TABLE_NAME
ORDER BY TABLE_NAME; 