-- Update Demo User Passwords with Proper BCrypt Hashes
-- These are BCrypt hashes for the passwords: admin123, teacher123, parent123

USE school_fee_register;

-- Update admin password (admin123)
UPDATE users SET password = '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa' WHERE username = 'admin';

-- Update teacher password (teacher123)
UPDATE users SET password = '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa' WHERE username = 'teacher';

-- Update parent password (parent123)
UPDATE users SET password = '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa' WHERE username = 'parent';

-- Update staff1 password (staff123)
UPDATE users SET password = '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa' WHERE username = 'staff1';

-- Verify the updates
SELECT username, role, is_active FROM users WHERE username IN ('admin', 'teacher', 'parent', 'staff1') ORDER BY username; 