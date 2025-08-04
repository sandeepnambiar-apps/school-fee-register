-- Transport Fee Management System Database Tables (Clean Version)
-- This file contains only the table structures without sample data

-- Transport Routes table
CREATE TABLE IF NOT EXISTS transport_routes (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    code VARCHAR(20) NOT NULL UNIQUE,
    pickup_location VARCHAR(200) NOT NULL,
    drop_location VARCHAR(200) NOT NULL,
    distance_km DECIMAL(5,2),
    estimated_time_minutes INT,
    vehicle_number VARCHAR(20),
    driver_name VARCHAR(100),
    driver_phone VARCHAR(20),
    capacity INT DEFAULT 50,
    current_occupancy INT DEFAULT 0,
    monthly_fee DECIMAL(10,2),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_route_code (code),
    INDEX idx_route_active (is_active),
    INDEX idx_pickup_location (pickup_location),
    INDEX idx_drop_location (drop_location)
);

-- Transport Fees table
CREATE TABLE IF NOT EXISTS transport_fees (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    student_id BIGINT NOT NULL,
    route_id BIGINT NOT NULL,
    academic_year_id BIGINT NOT NULL,
    monthly_fee DECIMAL(10,2) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    pickup_location VARCHAR(200),
    drop_location VARCHAR(200),
    vehicle_number VARCHAR(20),
    driver_name VARCHAR(100),
    driver_phone VARCHAR(20),
    payment_status ENUM('PENDING', 'PAID', 'OVERDUE', 'CANCELLED') DEFAULT 'PENDING',
    is_active BOOLEAN DEFAULT TRUE,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY (route_id) REFERENCES transport_routes(id) ON DELETE CASCADE,
    FOREIGN KEY (academic_year_id) REFERENCES academic_years(id) ON DELETE CASCADE,
    INDEX idx_transport_student (student_id),
    INDEX idx_transport_route (route_id),
    INDEX idx_transport_academic_year (academic_year_id),
    INDEX idx_transport_payment_status (payment_status),
    INDEX idx_transport_active (is_active),
    INDEX idx_transport_dates (start_date, end_date)
);

-- Transport Payments table (for tracking individual payments)
CREATE TABLE IF NOT EXISTS transport_payments (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    transport_fee_id BIGINT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_date DATE NOT NULL,
    payment_method ENUM('CASH', 'CARD', 'BANK_TRANSFER', 'CHEQUE', 'ONLINE') NOT NULL,
    reference_number VARCHAR(50),
    receipt_number VARCHAR(50),
    payment_status ENUM('PENDING', 'COMPLETED', 'FAILED', 'REFUNDED') DEFAULT 'PENDING',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (transport_fee_id) REFERENCES transport_fees(id) ON DELETE CASCADE,
    INDEX idx_payment_transport_fee (transport_fee_id),
    INDEX idx_payment_date (payment_date),
    INDEX idx_payment_status (payment_status)
);

-- Create indexes for better performance
CREATE INDEX idx_transport_fee_student_route ON transport_fees(student_id, route_id);
CREATE INDEX idx_transport_fee_academic_year_status ON transport_fees(academic_year_id, payment_status);
CREATE INDEX idx_transport_fee_dates_status ON transport_fees(start_date, end_date, payment_status);
CREATE INDEX idx_transport_payment_fee_date ON transport_payments(transport_fee_id, payment_date); 