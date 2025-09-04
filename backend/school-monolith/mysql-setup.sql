-- MySQL Setup Script for School Management System
-- Run this script as root user in MySQL

-- Create the database
CREATE DATABASE IF NOT EXISTS school_management 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

-- Use the database
USE school_management;

-- Create a dedicated user (optional - you can use root if preferred)
-- CREATE USER IF NOT EXISTS 'school_user'@'localhost' IDENTIFIED BY 'school_password';
-- GRANT ALL PRIVILEGES ON school_management.* TO 'school_user'@'localhost';
-- FLUSH PRIVILEGES;

-- Show the created database
SHOW DATABASES;

-- Show current database
SELECT DATABASE();

-- Note: The tables will be automatically created by Hibernate when you start the application
-- with ddl-auto: update in application.yml

