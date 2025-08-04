-- Set Simple Passwords for Demo Users
-- All users will have password: "password"

USE school_fee_register;

-- Set all demo users to use simple password "password"
UPDATE users SET password = '$2a$10$dXJ3SW6G7P50lGmMkkmwe.20cQQubK3.HZWzG3YB1tlRy.fqvM/BG' WHERE username IN ('admin', 'teacher', 'parent', 'staff1');

-- Verify the updates
SELECT username, role, is_active FROM users WHERE username IN ('admin', 'teacher', 'parent', 'staff1') ORDER BY username; 