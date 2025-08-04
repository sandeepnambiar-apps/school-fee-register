-- Add Phone Column to Users Table for Mobile Login
-- This script adds the phone column to the existing users table

USE school_fee_register;

-- Add phone column to users table
ALTER TABLE users ADD COLUMN phone VARCHAR(20) NULL;

-- Update existing parent users with their phone numbers
-- Based on the sample data from init.sql

-- Update parent1 (Michael Smith)
UPDATE users SET phone = '1234567890' WHERE username = 'parent1';

-- Update the generic parent account
UPDATE users SET phone = '1234567892' WHERE username = 'parent';

-- Update admin and staff accounts with dummy phone numbers for testing
UPDATE users SET phone = '1234567890' WHERE username = 'admin';
UPDATE users SET phone = '1234567891' WHERE username = 'staff1';

-- Verify the changes
SELECT username, email, role, phone FROM users ORDER BY username;

-- Show the table structure
DESCRIBE users; 