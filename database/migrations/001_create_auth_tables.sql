-- Create authentication tables
USE school_fee_register;

-- Users table for authentication
CREATE TABLE IF NOT EXISTS users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    full_name VARCHAR(100) NOT NULL,
    role ENUM('STUDENT', 'PARENT', 'TEACHER', 'SCHOOL_ADMIN', 'SUPER_ADMIN') NOT NULL,
    user_type ENUM('STUDENT', 'PARENT', 'STAFF', 'ADMIN') NOT NULL,
    student_id BIGINT NULL,
    enabled BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login_at TIMESTAMP NULL,
    INDEX idx_username (username),
    INDEX idx_email (email),
    INDEX idx_student_id (student_id),
    INDEX idx_role (role)
);

-- JWT token blacklist (for logout functionality)
CREATE TABLE IF NOT EXISTS token_blacklist (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    token_hash VARCHAR(255) NOT NULL UNIQUE,
    user_id BIGINT NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_token_hash (token_hash),
    INDEX idx_user_id (user_id),
    INDEX idx_expires_at (expires_at),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Insert default admin user
INSERT INTO users (username, password, email, full_name, role, user_type, enabled) 
VALUES (
    'admin',
    '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', -- password: admin123
    'admin@school.com',
    'System Administrator',
    'SUPER_ADMIN',
    'ADMIN',
    TRUE
) ON DUPLICATE KEY UPDATE username = username;

-- Insert sample student user
INSERT INTO users (username, password, email, full_name, role, user_type, student_id, enabled) 
VALUES (
    'student1',
    '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', -- password: admin123
    'student1@school.com',
    'John Doe',
    'STUDENT',
    'STUDENT',
    1,
    TRUE
) ON DUPLICATE KEY UPDATE username = username;

-- Insert sample parent user
INSERT INTO users (username, password, email, full_name, role, user_type, student_id, enabled) 
VALUES (
    'parent1',
    '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', -- password: admin123
    'parent1@email.com',
    'Jane Doe',
    'PARENT',
    'PARENT',
    1,
    TRUE
) ON DUPLICATE KEY UPDATE username = username; 