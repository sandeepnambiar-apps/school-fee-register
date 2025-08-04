-- Database Setup Script for School Fee Register
-- Run this script in MySQL as root or a user with CREATE privileges

-- Create the database
CREATE DATABASE IF NOT EXISTS school_fee_register;

-- Create the user
CREATE USER IF NOT EXISTS 'schooluser'@'localhost' IDENTIFIED BY 'schoolpass';

-- Grant privileges
GRANT ALL PRIVILEGES ON school_fee_register.* TO 'schooluser'@'localhost';

-- Grant additional privileges for Hibernate DDL operations
GRANT CREATE, DROP, ALTER, INDEX ON school_fee_register.* TO 'schooluser'@'localhost';

-- Flush privileges
FLUSH PRIVILEGES;

-- Use the database
USE school_fee_register;

-- Create basic tables (optional - Hibernate will create them automatically)
-- You can add any initial data here if needed

SELECT 'Database setup completed successfully!' as status; 