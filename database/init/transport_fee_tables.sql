-- Transport Fee Management System Database Tables
-- This file contains all the necessary tables for the transport fee management system

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

-- Insert sample transport routes
INSERT INTO transport_routes (name, code, pickup_location, drop_location, distance_km, estimated_time_minutes, vehicle_number, driver_name, driver_phone, capacity, current_occupancy, monthly_fee) VALUES
('Route 1 - Central City', 'R001', 'Central Bus Stand', 'School Campus', 5.5, 25, 'KA01AB1234', 'Rajesh Kumar', '+91-9876543210', 45, 12, 1500.00),
('Route 2 - North Zone', 'R002', 'North Market', 'School Campus', 8.2, 35, 'KA01CD5678', 'Mohan Singh', '+91-9876543211', 45, 8, 1800.00),
('Route 3 - South Zone', 'R003', 'South Terminal', 'School Campus', 6.8, 30, 'KA01EF9012', 'Suresh Patel', '+91-9876543212', 45, 15, 1600.00),
('Route 4 - East Zone', 'R004', 'East Railway Station', 'School Campus', 7.5, 32, 'KA01GH3456', 'Amit Sharma', '+91-9876543213', 45, 6, 1700.00),
('Route 5 - West Zone', 'R005', 'West Mall', 'School Campus', 4.2, 20, 'KA01IJ7890', 'Vikram Verma', '+91-9876543214', 45, 18, 1400.00),
('Route 6 - Suburban Area', 'R006', 'Suburban Complex', 'School Campus', 12.5, 45, 'KA01KL1234', 'Ramesh Yadav', '+91-9876543215', 45, 4, 2200.00),
('Route 7 - Industrial Area', 'R007', 'Industrial Park', 'School Campus', 9.8, 40, 'KA01MN5678', 'Dinesh Gupta', '+91-9876543216', 45, 7, 1900.00),
('Route 8 - Residential Colony', 'R008', 'Residential Colony A', 'School Campus', 3.5, 18, 'KA01OP9012', 'Prakash Reddy', '+91-9876543217', 45, 22, 1300.00);

-- Insert sample transport fees
INSERT INTO transport_fees (student_id, route_id, academic_year_id, monthly_fee, start_date, end_date, pickup_location, drop_location, vehicle_number, driver_name, driver_phone, payment_status, is_active, notes) VALUES
(1, 1, 1, 1500.00, '2024-01-01', '2024-12-31', 'Central Bus Stand', 'School Campus', 'KA01AB1234', 'Rajesh Kumar', '+91-9876543210', 'PAID', true, 'Student prefers front seat'),
(2, 1, 1, 1500.00, '2024-01-01', '2024-12-31', 'Central Bus Stand', 'School Campus', 'KA01AB1234', 'Rajesh Kumar', '+91-9876543210', 'PENDING', true, NULL),
(3, 2, 1, 1800.00, '2024-01-01', '2024-12-31', 'North Market', 'School Campus', 'KA01CD5678', 'Mohan Singh', '+91-9876543211', 'PAID', true, NULL),
(4, 3, 1, 1600.00, '2024-01-01', '2024-12-31', 'South Terminal', 'School Campus', 'KA01EF9012', 'Suresh Patel', '+91-9876543212', 'OVERDUE', true, 'Payment delayed due to family emergency'),
(5, 4, 1, 1700.00, '2024-01-01', '2024-12-31', 'East Railway Station', 'School Campus', 'KA01GH3456', 'Amit Sharma', '+91-9876543213', 'PENDING', true, NULL),
(6, 5, 1, 1400.00, '2024-01-01', '2024-12-31', 'West Mall', 'School Campus', 'KA01IJ7890', 'Vikram Verma', '+91-9876543214', 'PAID', true, NULL),
(7, 6, 1, 2200.00, '2024-01-01', '2024-12-31', 'Suburban Complex', 'School Campus', 'KA01KL1234', 'Ramesh Yadav', '+91-9876543215', 'PENDING', true, 'Long distance route'),
(8, 7, 1, 1900.00, '2024-01-01', '2024-12-31', 'Industrial Park', 'School Campus', 'KA01MN5678', 'Dinesh Gupta', '+91-9876543216', 'PAID', true, NULL),
(9, 8, 1, 1300.00, '2024-01-01', '2024-12-31', 'Residential Colony A', 'School Campus', 'KA01OP9012', 'Prakash Reddy', '+91-9876543217', 'PENDING', true, NULL),
(10, 1, 1, 1500.00, '2024-01-01', '2024-12-31', 'Central Bus Stand', 'School Campus', 'KA01AB1234', 'Rajesh Kumar', '+91-9876543210', 'PAID', true, NULL);

-- Insert sample transport payments
INSERT INTO transport_payments (transport_fee_id, amount, payment_date, payment_method, reference_number, receipt_number, payment_status, notes) VALUES
(1, 1500.00, '2024-01-15', 'BANK_TRANSFER', 'TXN123456', 'RCP001', 'COMPLETED', 'January 2024 payment'),
(1, 1500.00, '2024-02-15', 'CASH', NULL, 'RCP002', 'COMPLETED', 'February 2024 payment'),
(3, 1800.00, '2024-01-20', 'ONLINE', 'TXN789012', 'RCP003', 'COMPLETED', 'January 2024 payment'),
(6, 1400.00, '2024-01-10', 'CARD', 'TXN345678', 'RCP004', 'COMPLETED', 'January 2024 payment'),
(8, 1900.00, '2024-01-25', 'CHEQUE', 'CHQ901234', 'RCP005', 'COMPLETED', 'January 2024 payment'),
(10, 1500.00, '2024-01-30', 'BANK_TRANSFER', 'TXN567890', 'RCP006', 'COMPLETED', 'January 2024 payment');

-- Create views for easier querying
CREATE VIEW transport_fees_with_details AS
SELECT 
    tf.id,
    tf.student_id,
    CONCAT(s.first_name, ' ', s.last_name) as student_name,
    s.class_id,
    c.name as class_name,
    s.section,
    tf.route_id,
    tr.name as route_name,
    tr.code as route_code,
    tf.academic_year_id,
    ay.name as academic_year_name,
    tf.monthly_fee,
    tf.start_date,
    tf.end_date,
    tf.pickup_location,
    tf.drop_location,
    tf.vehicle_number,
    tf.driver_name,
    tf.driver_phone,
    tf.payment_status,
    tf.is_active,
    tf.notes,
    tf.created_at,
    tf.updated_at
FROM transport_fees tf
JOIN students s ON tf.student_id = s.id
JOIN classes c ON s.class_id = c.id
JOIN transport_routes tr ON tf.route_id = tr.id
JOIN academic_years ay ON tf.academic_year_id = ay.id;

-- Create view for transport fee statistics
CREATE VIEW transport_fee_statistics AS
SELECT 
    route_id,
    academic_year_id,
    COUNT(*) as total_students,
    COUNT(CASE WHEN payment_status = 'PAID' THEN 1 END) as paid_students,
    COUNT(CASE WHEN payment_status = 'PENDING' THEN 1 END) as pending_students,
    COUNT(CASE WHEN payment_status = 'OVERDUE' THEN 1 END) as overdue_students,
    COUNT(CASE WHEN is_active = TRUE THEN 1 END) as active_students,
    SUM(monthly_fee) as total_monthly_revenue,
    AVG(monthly_fee) as average_monthly_fee
FROM transport_fees
GROUP BY route_id, academic_year_id;

-- Create view for route occupancy
CREATE VIEW route_occupancy AS
SELECT 
    tr.id,
    tr.name,
    tr.code,
    tr.capacity,
    tr.current_occupancy,
    (tr.capacity - tr.current_occupancy) as available_seats,
    ROUND((tr.current_occupancy / tr.capacity) * 100, 2) as occupancy_percentage,
    tr.monthly_fee,
    tr.is_active
FROM transport_routes tr;

-- Create indexes for better performance
CREATE INDEX idx_transport_fee_student_route ON transport_fees(student_id, route_id);
CREATE INDEX idx_transport_fee_academic_year_status ON transport_fees(academic_year_id, payment_status);
CREATE INDEX idx_transport_fee_dates_status ON transport_fees(start_date, end_date, payment_status);
CREATE INDEX idx_transport_payment_fee_date ON transport_payments(transport_fee_id, payment_date);

-- Create stored procedure for getting transport fees by student
DELIMITER //
CREATE PROCEDURE GetTransportFeesByStudent(
    IN p_student_id BIGINT,
    IN p_academic_year_id BIGINT
)
BEGIN
    SELECT 
        tf.*,
        tr.name as route_name,
        tr.code as route_code,
        CONCAT(s.first_name, ' ', s.last_name) as student_name,
        c.name as class_name,
        s.section
    FROM transport_fees tf
    JOIN transport_routes tr ON tf.route_id = tr.id
    JOIN students s ON tf.student_id = s.id
    JOIN classes c ON s.class_id = c.id
    WHERE tf.student_id = p_student_id
        AND (p_academic_year_id IS NULL OR tf.academic_year_id = p_academic_year_id)
    ORDER BY tf.start_date DESC;
END //
DELIMITER ;

-- Create stored procedure for getting transport fee statistics
DELIMITER //
CREATE PROCEDURE GetTransportFeeStatistics(
    IN p_academic_year_id BIGINT
)
BEGIN
    SELECT 
        COUNT(*) as total_transport_fees,
        COUNT(CASE WHEN payment_status = 'PAID' THEN 1 END) as paid_fees,
        COUNT(CASE WHEN payment_status = 'PENDING' THEN 1 END) as pending_fees,
        COUNT(CASE WHEN payment_status = 'OVERDUE' THEN 1 END) as overdue_fees,
        COUNT(CASE WHEN is_active = TRUE THEN 1 END) as active_fees,
        SUM(monthly_fee) as total_monthly_revenue,
        AVG(monthly_fee) as average_monthly_fee,
        COUNT(DISTINCT student_id) as total_students,
        COUNT(DISTINCT route_id) as total_routes
    FROM transport_fees
    WHERE p_academic_year_id IS NULL OR academic_year_id = p_academic_year_id;
END //
DELIMITER ;

-- Create stored procedure for updating route occupancy
DELIMITER //
CREATE PROCEDURE UpdateRouteOccupancy(
    IN p_route_id BIGINT
)
BEGIN
    UPDATE transport_routes 
    SET current_occupancy = (
        SELECT COUNT(*) 
        FROM transport_fees 
        WHERE route_id = p_route_id 
        AND is_active = TRUE
    )
    WHERE id = p_route_id;
END //
DELIMITER ;

-- Create trigger to update route occupancy when transport fee is added/updated
DELIMITER //
CREATE TRIGGER after_transport_fee_insert
AFTER INSERT ON transport_fees
FOR EACH ROW
BEGIN
    CALL UpdateRouteOccupancy(NEW.route_id);
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER after_transport_fee_update
AFTER UPDATE ON transport_fees
FOR EACH ROW
BEGIN
    IF OLD.route_id != NEW.route_id THEN
        CALL UpdateRouteOccupancy(OLD.route_id);
        CALL UpdateRouteOccupancy(NEW.route_id);
    ELSE
        CALL UpdateRouteOccupancy(NEW.route_id);
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER after_transport_fee_delete
AFTER DELETE ON transport_fees
FOR EACH ROW
BEGIN
    CALL UpdateRouteOccupancy(OLD.route_id);
END //
DELIMITER ; 