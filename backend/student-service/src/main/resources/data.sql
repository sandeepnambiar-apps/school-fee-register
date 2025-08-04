-- Sample data for School Fee Register System

-- Insert Academic Years
INSERT INTO academic_years (year_name, start_date, end_date, is_active, created_at) VALUES
('2024-2025', '2024-06-01', '2025-05-31', true, CURRENT_TIMESTAMP),
('2023-2024', '2023-06-01', '2024-05-31', false, CURRENT_TIMESTAMP);

-- Insert Classes
INSERT INTO classes (class_name, class_level, description, is_active, created_at) VALUES
('Class 10', 10, 'Class 10 Section A', true, CURRENT_TIMESTAMP),
('Class 10', 10, 'Class 10 Section B', true, CURRENT_TIMESTAMP),
('Class 9', 9, 'Class 9 Section A', true, CURRENT_TIMESTAMP),
('Class 8', 8, 'Class 8 Section A', true, CURRENT_TIMESTAMP);

-- Insert Students
INSERT INTO students (student_id, first_name, last_name, date_of_birth, gender, class_id, parent_name, parent_phone, parent_email, address, admission_date, is_active, created_at) VALUES
('STU001', 'Rahul', 'Kumar', '2010-05-15', 'MALE', 1, 'Rajesh Kumar', '8094979799', 'rajesh@email.com', '123 Main Street, Delhi', '2024-06-01', true, CURRENT_TIMESTAMP),
('STU002', 'Priya', 'Sharma', '2010-08-22', 'FEMALE', 1, 'Amit Sharma', '9876543210', 'amit@email.com', '456 Park Avenue, Mumbai', '2024-06-01', true, CURRENT_TIMESTAMP),
('STU003', 'Arjun', 'Singh', '2011-03-10', 'MALE', 2, 'Vikram Singh', '8765432109', 'vikram@email.com', '789 Lake Road, Bangalore', '2024-06-01', true, CURRENT_TIMESTAMP),
('STU004', 'Ananya', 'Patel', '2011-11-05', 'FEMALE', 2, 'Ramesh Patel', '7654321098', 'ramesh@email.com', '321 Garden Street, Chennai', '2024-06-01', true, CURRENT_TIMESTAMP),
('STU005', 'Vivaan', 'Gupta', '2012-01-20', 'MALE', 3, 'Suresh Gupta', '6543210987', 'suresh@email.com', '654 River View, Kolkata', '2024-06-01', true, CURRENT_TIMESTAMP),
('STU006', 'Zara', 'Khan', '2012-07-12', 'FEMALE', 3, 'Imran Khan', '5432109876', 'imran@email.com', '987 Hill Street, Hyderabad', '2024-06-01', true, CURRENT_TIMESTAMP),
('STU007', 'Aarav', 'Joshi', '2013-04-08', 'MALE', 4, 'Prakash Joshi', '4321098765', 'prakash@email.com', '147 Valley Road, Pune', '2024-06-01', true, CURRENT_TIMESTAMP),
('STU008', 'Ishaan', 'Verma', '2013-09-25', 'MALE', 4, 'Rahul Verma', '3210987654', 'rahul.verma@email.com', '258 Mountain View, Jaipur', '2024-06-01', true, CURRENT_TIMESTAMP);

-- Insert Fee Categories
INSERT INTO fee_categories (category_name, description, is_active, created_at) VALUES
('Tuition Fee', 'Monthly tuition fee', true, CURRENT_TIMESTAMP),
('Library Fee', 'Annual library membership fee', true, CURRENT_TIMESTAMP),
('Sports Fee', 'Annual sports facility fee', true, CURRENT_TIMESTAMP),
('Laboratory Fee', 'Science laboratory usage fee', true, CURRENT_TIMESTAMP),
('Computer Fee', 'Computer lab and technology fee', true, CURRENT_TIMESTAMP),
('Transport Fee', 'Optional school transport fee', true, CURRENT_TIMESTAMP);

-- Insert Fee Structures
INSERT INTO fee_structures (class_id, fee_category_id, academic_year_id, amount, frequency, due_date, is_active, created_at) VALUES
(1, 1, 1, 30000.00, 'MONTHLY', '2024-12-31', true, CURRENT_TIMESTAMP),
(1, 2, 1, 5000.00, 'ANNUAL', '2024-12-31', true, CURRENT_TIMESTAMP),
(1, 3, 1, 3000.00, 'ANNUAL', '2024-12-31', true, CURRENT_TIMESTAMP),
(1, 4, 1, 2000.00, 'ANNUAL', '2024-12-31', true, CURRENT_TIMESTAMP),
(1, 5, 1, 2000.00, 'ANNUAL', '2024-12-31', true, CURRENT_TIMESTAMP),
(2, 1, 1, 30000.00, 'MONTHLY', '2024-12-31', true, CURRENT_TIMESTAMP),
(2, 2, 1, 5000.00, 'ANNUAL', '2024-12-31', true, CURRENT_TIMESTAMP),
(2, 3, 1, 3000.00, 'ANNUAL', '2024-12-31', true, CURRENT_TIMESTAMP),
(3, 1, 1, 27000.00, 'MONTHLY', '2024-12-31', true, CURRENT_TIMESTAMP),
(3, 2, 1, 4500.00, 'ANNUAL', '2024-12-31', true, CURRENT_TIMESTAMP),
(4, 1, 1, 24000.00, 'MONTHLY', '2024-12-31', true, CURRENT_TIMESTAMP),
(4, 2, 1, 4000.00, 'ANNUAL', '2024-12-31', true, CURRENT_TIMESTAMP);



-- Insert Student Fees
INSERT INTO student_fees (student_id, fee_structure_id, academic_year_id, amount, discount_amount, net_amount, due_date, status, created_at) VALUES
(1, 1, 1, 30000.00, 0.00, 30000.00, '2024-12-31', 'PENDING', CURRENT_TIMESTAMP),
(1, 2, 1, 5000.00, 0.00, 5000.00, '2024-12-31', 'PENDING', CURRENT_TIMESTAMP),
(2, 1, 1, 30000.00, 2000.00, 28000.00, '2024-12-31', 'PARTIAL', CURRENT_TIMESTAMP),
(2, 2, 1, 5000.00, 0.00, 5000.00, '2024-12-31', 'PENDING', CURRENT_TIMESTAMP),
(3, 6, 1, 30000.00, 0.00, 30000.00, '2024-12-31', 'PENDING', CURRENT_TIMESTAMP),
(4, 6, 1, 30000.00, 0.00, 30000.00, '2024-12-31', 'PAID', CURRENT_TIMESTAMP),
(5, 9, 1, 27000.00, 0.00, 27000.00, '2024-12-31', 'PENDING', CURRENT_TIMESTAMP),
(6, 9, 1, 27000.00, 2000.00, 25000.00, '2024-12-31', 'PARTIAL', CURRENT_TIMESTAMP);

-- Insert Payments
INSERT INTO payments (student_fee_id, amount, payment_date, payment_method, reference_number, notes, created_at) VALUES
(3, 25000.00, '2024-07-15', 'ONLINE', 'TXN001', 'Online payment for tuition fee', CURRENT_TIMESTAMP),
(6, 30000.00, '2024-07-20', 'CASH', 'TXN002', 'Cash payment for complete fee', CURRENT_TIMESTAMP),
(8, 20000.00, '2024-07-25', 'CHEQUE', 'TXN003', 'Cheque payment for partial fee', CURRENT_TIMESTAMP);

 