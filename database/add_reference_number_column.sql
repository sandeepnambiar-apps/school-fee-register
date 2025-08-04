-- Add missing reference_number column to payments table
-- This fixes the schema validation error in the Student Service

USE school_fee_register;

-- Add the missing reference_number column
ALTER TABLE payments 
ADD COLUMN reference_number VARCHAR(100) AFTER payment_method;

-- Verify the column was added
DESCRIBE payments; 