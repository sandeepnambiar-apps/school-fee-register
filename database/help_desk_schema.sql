-- Help Desk Ticket System Schema

USE school_fee_register;

-- Create support_tickets table
CREATE TABLE IF NOT EXISTS support_tickets (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    category VARCHAR(100) NOT NULL,
    priority ENUM('LOW', 'MEDIUM', 'HIGH', 'URGENT') NOT NULL DEFAULT 'MEDIUM',
    status ENUM('OPEN', 'IN_PROGRESS', 'RESOLVED', 'CLOSED') NOT NULL DEFAULT 'OPEN',
    created_by VARCHAR(100) NOT NULL,
    created_by_phone VARCHAR(20) NOT NULL,
    assigned_to VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_status (status),
    INDEX idx_priority (priority),
    INDEX idx_category (category),
    INDEX idx_created_by_phone (created_by_phone),
    INDEX idx_created_at (created_at)
);

-- Create ticket_responses table
CREATE TABLE IF NOT EXISTS ticket_responses (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    ticket_id BIGINT NOT NULL,
    message TEXT NOT NULL,
    responded_by VARCHAR(100) NOT NULL,
    responded_by_role VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ticket_id) REFERENCES support_tickets(id) ON DELETE CASCADE,
    INDEX idx_ticket_id (ticket_id),
    INDEX idx_responded_by (responded_by),
    INDEX idx_created_at (created_at)
);

-- Insert sample data
INSERT INTO support_tickets (title, description, category, priority, status, created_by, created_by_phone, assigned_to) VALUES
('Payment Gateway Issue', 'I am unable to make payment through the online portal. Getting an error message.', 'Fee Related', 'HIGH', 'OPEN', 'John Doe', '9876543210', NULL),
('Student Attendance Query', 'I want to know about my child\'s attendance for the last month.', 'Academic', 'MEDIUM', 'IN_PROGRESS', 'Jane Smith', '8095978779', 'Admin'),
('Transport Route Change Request', 'Can you please change the pickup time for my child? Current time is too early.', 'Transport', 'LOW', 'RESOLVED', 'Mike Johnson', '8765432109', 'Admin'),
('Technical Support Needed', 'I cannot access the parent portal from my mobile device.', 'Technical', 'HIGH', 'OPEN', 'Sarah Wilson', '7654321098', NULL),
('Fee Structure Query', 'I need clarification on the new fee structure for Class 10.', 'Fee Related', 'MEDIUM', 'OPEN', 'David Brown', '6543210987', NULL);

INSERT INTO ticket_responses (ticket_id, message, responded_by, responded_by_role) VALUES
(2, 'Thank you for your query. I will check the attendance records and get back to you within 24 hours.', 'Admin', 'ADMIN'),
(3, 'I have updated the pickup time to 8:00 AM as requested. The change will be effective from tomorrow.', 'Admin', 'ADMIN'); 