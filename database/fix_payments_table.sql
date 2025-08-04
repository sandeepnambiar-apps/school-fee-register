-- Fix payments table structure to match Payment entity
DROP TABLE IF EXISTS payments;

CREATE TABLE payments (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    student_id BIGINT NOT NULL,
    fee_structure_id BIGINT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_method ENUM('CASH', 'CARD', 'ONLINE', 'BANK_TRANSFER', 'CHEQUE') NOT NULL,
    payment_status ENUM('PENDING', 'COMPLETED', 'FAILED', 'CANCELLED', 'REFUNDED') NOT NULL DEFAULT 'COMPLETED',
    transaction_id VARCHAR(255) UNIQUE,
    receipt_number VARCHAR(255) UNIQUE,
    payment_date DATETIME NOT NULL,
    due_date DATETIME,
    discount_amount DECIMAL(10,2),
    late_fee_amount DECIMAL(10,2),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(id),
    FOREIGN KEY (fee_structure_id) REFERENCES fee_structures(id),
    INDEX idx_student_id (student_id),
    INDEX idx_fee_structure_id (fee_structure_id),
    INDEX idx_payment_date (payment_date),
    INDEX idx_payment_status (payment_status)
); 