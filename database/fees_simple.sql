-- Create fees table (simplified version)
CREATE TABLE IF NOT EXISTS fees (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    student_id BIGINT NOT NULL,
    class_id BIGINT NOT NULL,
    fee_type ENUM('TUITION_FEE', 'TRANSPORT_FEE', 'LIBRARY_FEE', 'LABORATORY_FEE', 'SPORTS_FEE', 'EXAMINATION_FEE', 'MISCELLANEOUS_FEE') NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    due_date DATE NOT NULL,
    status ENUM('PENDING', 'PARTIAL', 'PAID', 'OVERDUE') NOT NULL DEFAULT 'PENDING',
    paid_amount DECIMAL(10,2) DEFAULT 0.00,
    remarks VARCHAR(500),
    created_at DATE,
    updated_at DATE,
    
    -- Foreign key constraints
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY (class_id) REFERENCES classes(id) ON DELETE CASCADE,
    
    -- Indexes for better performance
    INDEX idx_student_id (student_id),
    INDEX idx_class_id (class_id),
    INDEX idx_fee_type (fee_type),
    INDEX idx_status (status),
    INDEX idx_due_date (due_date)
);

-- Insert sample data for testing
INSERT INTO fees (student_id, class_id, fee_type, amount, due_date, status, paid_amount, remarks, created_at, updated_at) VALUES
(1, 1, 'TUITION_FEE', 500.00, '2024-02-15', 'PENDING', 0.00, 'Monthly tuition fee for January 2024', CURDATE(), CURDATE()),
(1, 1, 'TRANSPORT_FEE', 200.00, '2024-02-15', 'PENDING', 0.00, 'Monthly transport fee', CURDATE(), CURDATE()),
(1, 1, 'LIBRARY_FEE', 50.00, '2024-02-15', 'PENDING', 0.00, 'Annual library membership fee', CURDATE(), CURDATE()),
(2, 1, 'TUITION_FEE', 500.00, '2024-02-15', 'PAID', 500.00, 'Monthly tuition fee for January 2024', CURDATE(), CURDATE()),
(2, 1, 'TRANSPORT_FEE', 200.00, '2024-02-15', 'PENDING', 0.00, 'Monthly transport fee', CURDATE(), CURDATE()),
(2, 1, 'LABORATORY_FEE', 100.00, '2024-02-15', 'PARTIAL', 50.00, 'Science lab fee', CURDATE(), CURDATE()),
(3, 2, 'TUITION_FEE', 600.00, '2024-02-20', 'PENDING', 0.00, 'Monthly tuition fee for January 2024', CURDATE(), CURDATE()),
(3, 2, 'SPORTS_FEE', 75.00, '2024-02-20', 'PENDING', 0.00, 'Sports facility fee', CURDATE(), CURDATE()),
(3, 2, 'EXAMINATION_FEE', 150.00, '2024-02-20', 'PENDING', 0.00, 'Mid-term examination fee', CURDATE(), CURDATE()),
(4, 2, 'TUITION_FEE', 600.00, '2024-02-20', 'PAID', 600.00, 'Monthly tuition fee for January 2024', CURDATE(), CURDATE()),
(4, 2, 'TRANSPORT_FEE', 250.00, '2024-02-20', 'PENDING', 0.00, 'Monthly transport fee', CURDATE(), CURDATE()),
(4, 2, 'MISCELLANEOUS_FEE', 25.00, '2024-02-20', 'PENDING', 0.00, 'Student activity fee', CURDATE(), CURDATE()),
(5, 3, 'TUITION_FEE', 700.00, '2024-02-25', 'PENDING', 0.00, 'Monthly tuition fee for January 2024', CURDATE(), CURDATE()),
(5, 3, 'LABORATORY_FEE', 120.00, '2024-02-25', 'PENDING', 0.00, 'Computer lab fee', CURDATE(), CURDATE()),
(5, 3, 'LIBRARY_FEE', 60.00, '2024-02-25', 'PENDING', 0.00, 'Annual library membership fee', CURDATE(), CURDATE()),
(6, 3, 'TUITION_FEE', 700.00, '2024-02-25', 'PARTIAL', 350.00, 'Monthly tuition fee for January 2024', CURDATE(), CURDATE()),
(6, 3, 'TRANSPORT_FEE', 300.00, '2024-02-25', 'PENDING', 0.00, 'Monthly transport fee', CURDATE(), CURDATE()),
(6, 3, 'SPORTS_FEE', 80.00, '2024-02-25', 'PENDING', 0.00, 'Sports facility fee', CURDATE(), CURDATE()); 