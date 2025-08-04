-- Sample Data for School Fee Register System
-- Insert sample data for testing and development

USE school_fee_register;

-- Insert Academic Years
INSERT INTO academic_years (year_name, start_date, end_date, is_active) VALUES
('2024-2025', '2024-06-01', '2025-05-31', TRUE),
('2023-2024', '2023-06-01', '2024-05-31', FALSE),
('2025-2026', '2025-06-01', '2026-05-31', FALSE);

-- Insert Classes
INSERT INTO classes (class_name, class_level, description, is_active) VALUES
('Class 1', 1, 'First Grade - Primary School', TRUE),
('Class 2', 2, 'Second Grade - Primary School', TRUE),
('Class 3', 3, 'Third Grade - Primary School', TRUE),
('Class 4', 4, 'Fourth Grade - Primary School', TRUE),
('Class 5', 5, 'Fifth Grade - Primary School', TRUE),
('Class 6', 6, 'Sixth Grade - Middle School', TRUE),
('Class 7', 7, 'Seventh Grade - Middle School', TRUE),
('Class 8', 8, 'Eighth Grade - Middle School', TRUE),
('Class 9', 9, 'Ninth Grade - High School', TRUE),
('Class 10', 10, 'Tenth Grade - High School', TRUE);

-- Insert Fee Categories
INSERT INTO fee_categories (category_name, description, is_active) VALUES
('Tuition Fee', 'Monthly tuition fee for academic instruction', TRUE),
('Library Fee', 'Annual library membership and book access', TRUE),
('Laboratory Fee', 'Science lab equipment and materials', TRUE),
('Sports Fee', 'Physical education and sports facilities', TRUE),
('Computer Fee', 'Computer lab access and IT resources', TRUE),
('Transportation Fee', 'School bus service (optional)', TRUE),
('Examination Fee', 'Term and final examination charges', TRUE),
('Development Fee', 'School infrastructure and development', TRUE),
('Admission Fee', 'One-time admission processing fee', TRUE),
('Uniform Fee', 'School uniform and dress code items', TRUE);

-- Insert Students
INSERT INTO students (student_id, first_name, last_name, date_of_birth, gender, address, phone, email, parent_name, parent_phone, parent_email, class_id, academic_year_id, admission_date, is_active) VALUES
('STU001', 'John', 'Smith', '2015-03-15', 'MALE', '123 Main Street, City Center', '+1234567890', 'john.smith@email.com', 'Michael Smith', '+1234567891', 'michael.smith@email.com', 1, 1, '2024-06-01', TRUE),
('STU002', 'Emma', 'Johnson', '2015-07-22', 'FEMALE', '456 Oak Avenue, Downtown', '+1234567892', 'emma.johnson@email.com', 'Sarah Johnson', '+1234567893', 'sarah.johnson@email.com', 1, 1, '2024-06-01', TRUE),
('STU003', 'Michael', 'Brown', '2014-11-08', 'MALE', '789 Pine Road, Suburb', '+1234567894', 'michael.brown@email.com', 'David Brown', '+1234567895', 'david.brown@email.com', 2, 1, '2024-06-01', TRUE),
('STU004', 'Sophia', 'Davis', '2014-05-12', 'FEMALE', '321 Elm Street, Westside', '+1234567896', 'sophia.davis@email.com', 'Robert Davis', '+1234567897', 'robert.davis@email.com', 2, 1, '2024-06-01', TRUE),
('STU005', 'William', 'Wilson', '2013-09-30', 'MALE', '654 Maple Drive, Eastside', '+1234567898', 'william.wilson@email.com', 'James Wilson', '+1234567899', 'james.wilson@email.com', 3, 1, '2024-06-01', TRUE),
('STU006', 'Olivia', 'Taylor', '2013-12-03', 'FEMALE', '987 Cedar Lane, Northside', '+1234567900', 'olivia.taylor@email.com', 'Christopher Taylor', '+1234567901', 'christopher.taylor@email.com', 3, 1, '2024-06-01', TRUE),
('STU007', 'James', 'Anderson', '2012-04-18', 'MALE', '147 Birch Court, Southside', '+1234567902', 'james.anderson@email.com', 'Andrew Anderson', '+1234567903', 'andrew.anderson@email.com', 4, 1, '2024-06-01', TRUE),
('STU008', 'Ava', 'Thomas', '2012-08-25', 'FEMALE', '258 Spruce Way, Central', '+1234567904', 'ava.thomas@email.com', 'Daniel Thomas', '+1234567905', 'daniel.thomas@email.com', 4, 1, '2024-06-01', TRUE),
('STU009', 'Benjamin', 'Jackson', '2011-01-14', 'MALE', '369 Willow Path, Riverside', '+1234567906', 'benjamin.jackson@email.com', 'Matthew Jackson', '+1234567907', 'matthew.jackson@email.com', 5, 1, '2024-06-01', TRUE),
('STU010', 'Isabella', 'White', '2011-06-07', 'FEMALE', '741 Aspen Circle, Hilltop', '+1234567908', 'isabella.white@email.com', 'Joshua White', '+1234567909', 'joshua.white@email.com', 5, 1, '2024-06-01', TRUE);

-- Insert Fee Structures
INSERT INTO fee_structures (class_id, fee_category_id, academic_year_id, amount, frequency, due_date, is_active) VALUES
-- Class 1 Fee Structures
(1, 1, 1, 500.00, 'MONTHLY', '2024-07-05', TRUE),  -- Tuition Fee
(1, 2, 1, 200.00, 'ANNUAL', '2024-07-15', TRUE),   -- Library Fee
(1, 3, 1, 150.00, 'ANNUAL', '2024-07-20', TRUE),   -- Laboratory Fee
(1, 4, 1, 100.00, 'ANNUAL', '2024-07-25', TRUE),   -- Sports Fee
(1, 5, 1, 120.00, 'ANNUAL', '2024-08-01', TRUE),   -- Computer Fee

-- Class 2 Fee Structures
(2, 1, 1, 550.00, 'MONTHLY', '2024-07-05', TRUE),  -- Tuition Fee
(2, 2, 1, 220.00, 'ANNUAL', '2024-07-15', TRUE),   -- Library Fee
(2, 3, 1, 170.00, 'ANNUAL', '2024-07-20', TRUE),   -- Laboratory Fee
(2, 4, 1, 110.00, 'ANNUAL', '2024-07-25', TRUE),   -- Sports Fee
(2, 5, 1, 130.00, 'ANNUAL', '2024-08-01', TRUE),   -- Computer Fee

-- Class 3 Fee Structures
(3, 1, 1, 600.00, 'MONTHLY', '2024-07-05', TRUE),  -- Tuition Fee
(3, 2, 1, 240.00, 'ANNUAL', '2024-07-15', TRUE),   -- Library Fee
(3, 3, 1, 190.00, 'ANNUAL', '2024-07-20', TRUE),   -- Laboratory Fee
(3, 4, 1, 120.00, 'ANNUAL', '2024-07-25', TRUE),   -- Sports Fee
(3, 5, 1, 140.00, 'ANNUAL', '2024-08-01', TRUE),   -- Computer Fee

-- Class 4 Fee Structures
(4, 1, 1, 650.00, 'MONTHLY', '2024-07-05', TRUE),  -- Tuition Fee
(4, 2, 1, 260.00, 'ANNUAL', '2024-07-15', TRUE),   -- Library Fee
(4, 3, 1, 210.00, 'ANNUAL', '2024-07-20', TRUE),   -- Laboratory Fee
(4, 4, 1, 130.00, 'ANNUAL', '2024-07-25', TRUE),   -- Sports Fee
(4, 5, 1, 150.00, 'ANNUAL', '2024-08-01', TRUE),   -- Computer Fee

-- Class 5 Fee Structures
(5, 1, 1, 700.00, 'MONTHLY', '2024-07-05', TRUE),  -- Tuition Fee
(5, 2, 1, 280.00, 'ANNUAL', '2024-07-15', TRUE),   -- Library Fee
(5, 3, 1, 230.00, 'ANNUAL', '2024-07-20', TRUE),   -- Laboratory Fee
(5, 4, 1, 140.00, 'ANNUAL', '2024-07-25', TRUE),   -- Sports Fee
(5, 5, 1, 160.00, 'ANNUAL', '2024-08-01', TRUE);   -- Computer Fee

-- Insert Student Fees (Sample assignments for first 5 students)
INSERT INTO student_fees (student_id, fee_structure_id, academic_year_id, amount, discount_amount, net_amount, due_date, status) VALUES
-- Student 1 (STU001) - Class 1
(1, 1, 1, 500.00, 0.00, 500.00, '2024-07-05', 'PENDING'),  -- Tuition Fee
(1, 2, 1, 200.00, 0.00, 200.00, '2024-07-15', 'PENDING'),  -- Library Fee
(1, 3, 1, 150.00, 0.00, 150.00, '2024-07-20', 'PENDING'),  -- Laboratory Fee
(1, 4, 1, 100.00, 0.00, 100.00, '2024-07-25', 'PENDING'),  -- Sports Fee
(1, 5, 1, 120.00, 0.00, 120.00, '2024-08-01', 'PENDING'),  -- Computer Fee

-- Student 2 (STU002) - Class 1
(2, 1, 1, 500.00, 50.00, 450.00, '2024-07-05', 'PARTIAL'),  -- Tuition Fee (with discount)
(2, 2, 1, 200.00, 0.00, 200.00, '2024-07-15', 'PAID'),      -- Library Fee
(2, 3, 1, 150.00, 0.00, 150.00, '2024-07-20', 'PENDING'),  -- Laboratory Fee
(2, 4, 1, 100.00, 0.00, 100.00, '2024-07-25', 'PENDING'),  -- Sports Fee
(2, 5, 1, 120.00, 0.00, 120.00, '2024-08-01', 'PENDING'),  -- Computer Fee

-- Student 3 (STU003) - Class 2
(3, 6, 1, 550.00, 0.00, 550.00, '2024-07-05', 'PENDING'),   -- Tuition Fee
(3, 7, 1, 220.00, 0.00, 220.00, '2024-07-15', 'PENDING'),   -- Library Fee
(3, 8, 1, 170.00, 0.00, 170.00, '2024-07-20', 'PENDING'),   -- Laboratory Fee
(3, 9, 1, 110.00, 0.00, 110.00, '2024-07-25', 'PENDING'),   -- Sports Fee
(3, 10, 1, 130.00, 0.00, 130.00, '2024-08-01', 'PENDING'),  -- Computer Fee

-- Student 4 (STU004) - Class 2
(4, 6, 1, 550.00, 0.00, 550.00, '2024-07-05', 'PAID'),      -- Tuition Fee
(4, 7, 1, 220.00, 0.00, 220.00, '2024-07-15', 'PAID'),      -- Library Fee
(4, 8, 1, 170.00, 0.00, 170.00, '2024-07-20', 'PAID'),      -- Laboratory Fee
(4, 9, 1, 110.00, 0.00, 110.00, '2024-07-25', 'PAID'),      -- Sports Fee
(4, 10, 1, 130.00, 0.00, 130.00, '2024-08-01', 'PAID'),     -- Computer Fee

-- Student 5 (STU005) - Class 3
(5, 11, 1, 600.00, 0.00, 600.00, '2024-07-05', 'OVERDUE'),  -- Tuition Fee (overdue)
(5, 12, 1, 240.00, 0.00, 240.00, '2024-07-15', 'PENDING'),  -- Library Fee
(5, 13, 1, 190.00, 0.00, 190.00, '2024-07-20', 'PENDING'),  -- Laboratory Fee
(5, 14, 1, 120.00, 0.00, 120.00, '2024-07-25', 'PENDING'),  -- Sports Fee
(5, 15, 1, 140.00, 0.00, 140.00, '2024-08-01', 'PENDING');  -- Computer Fee

-- Insert Sample Payments
INSERT INTO payments (student_fee_id, amount, payment_date, payment_method, reference_number, notes) VALUES
-- Payments for Student 2 (STU002)
(6, 200.00, '2024-07-10', 'BANK_TRANSFER', 'TXN001', 'Library fee payment'),
(6, 250.00, '2024-07-12', 'CASH', 'CASH001', 'Partial tuition payment'),

-- Payments for Student 4 (STU004) - All fees paid
(16, 550.00, '2024-07-03', 'ONLINE', 'TXN002', 'Tuition fee payment'),
(17, 220.00, '2024-07-12', 'BANK_TRANSFER', 'TXN003', 'Library fee payment'),
(18, 170.00, '2024-07-18', 'CASH', 'CASH002', 'Laboratory fee payment'),
(19, 110.00, '2024-07-22', 'CARD', 'CARD001', 'Sports fee payment'),
(20, 130.00, '2024-07-28', 'ONLINE', 'TXN004', 'Computer fee payment');

-- Insert Sample Users (for authentication)
INSERT INTO users (username, email, password, role, first_name, last_name, phone, is_active) VALUES
('admin', 'admin@school.com', '$2a$10$rAM0QZqZqZqZqZqZqZqZqO', 'ADMIN', 'Admin', 'User', '1234567890', TRUE),
('staff1', 'staff1@school.com', '$2a$10$rAM0QZqZqZqZqZqZqZqZqO', 'STAFF', 'John', 'Staff', '1234567891', TRUE),
('parent1', 'michael.smith@email.com', '$2a$10$rAM0QZqZqZqZqZqZqZqZqO', 'PARENT', 'Michael', 'Smith', '1234567890', TRUE),
('parent2', 'sarah.johnson@email.com', '$2a$10$rAM0QZqZqZqZqZqZqZqZqO', 'PARENT', 'Sarah', 'Johnson', '1234567892', TRUE);

-- Insert Sample Audit Logs
INSERT INTO audit_logs (table_name, record_id, action, old_values, new_values, user_id) VALUES
('students', 1, 'INSERT', NULL, '{"student_id":"STU001","first_name":"John","last_name":"Smith"}', 'admin'),
('students', 2, 'INSERT', NULL, '{"student_id":"STU002","first_name":"Emma","last_name":"Johnson"}', 'admin'),
('fee_structures', 1, 'INSERT', NULL, '{"class_id":1,"fee_category_id":1,"amount":500.00}', 'admin'),
('student_fees', 1, 'INSERT', NULL, '{"student_id":1,"fee_structure_id":1,"amount":500.00}', 'staff1'),
('payments', 1, 'INSERT', NULL, '{"student_fee_id":6,"amount":200.00,"payment_method":"BANK_TRANSFER"}', 'parent2'); 