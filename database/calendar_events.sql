-- Create calendar_events table
CREATE TABLE IF NOT EXISTS calendar_events (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    type ENUM('EVENT', 'HOLIDAY') NOT NULL,
    color VARCHAR(7) DEFAULT '#1976d2',
    is_recurring BOOLEAN DEFAULT FALSE,
    recurring_type ENUM('YEARLY', 'MONTHLY', 'WEEKLY'),
    created_by BIGINT,
    updated_by BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_start_date (start_date),
    INDEX idx_end_date (end_date),
    INDEX idx_type (type),
    INDEX idx_created_by (created_by),
    INDEX idx_recurring (is_recurring)
);

-- Insert sample holidays for the current year
INSERT INTO calendar_events (title, description, start_date, end_date, type, color, is_recurring, recurring_type, created_by) VALUES
('New Year''s Day', 'New Year''s Day Holiday', '2024-01-01', '2024-01-01', 'HOLIDAY', '#ff9800', TRUE, 'YEARLY', 1),
('Republic Day', 'Republic Day of India', '2024-01-26', '2024-01-26', 'HOLIDAY', '#ff9800', TRUE, 'YEARLY', 1),
('Independence Day', 'Independence Day of India', '2024-08-15', '2024-08-15', 'HOLIDAY', '#ff9800', TRUE, 'YEARLY', 1),
('Gandhi Jayanti', 'Mahatma Gandhi''s Birthday', '2024-10-02', '2024-10-02', 'HOLIDAY', '#ff9800', TRUE, 'YEARLY', 1),
('Christmas Day', 'Christmas Holiday', '2024-12-25', '2024-12-25', 'HOLIDAY', '#ff9800', TRUE, 'YEARLY', 1);

-- Insert sample events
INSERT INTO calendar_events (title, description, start_date, end_date, type, color, is_recurring, recurring_type, created_by) VALUES
('Parent-Teacher Meeting', 'Annual parent-teacher meeting for all classes', '2024-03-15', '2024-03-15', 'EVENT', '#1976d2', FALSE, NULL, 1),
('Annual Sports Day', 'Annual sports competition and activities', '2024-02-20', '2024-02-20', 'EVENT', '#4caf50', FALSE, NULL, 1),
('Science Fair', 'Annual science exhibition and fair', '2024-04-10', '2024-04-12', 'EVENT', '#9c27b0', FALSE, NULL, 1),
('Annual Day Celebration', 'Annual day celebration with cultural programs', '2024-12-20', '2024-12-20', 'EVENT', '#e91e63', FALSE, NULL, 1),
('Exam Week', 'Mid-term examinations for all classes', '2024-09-15', '2024-09-20', 'EVENT', '#f44336', FALSE, NULL, 1);

-- Insert events for 2025 (recurring yearly events)
INSERT INTO calendar_events (title, description, start_date, end_date, type, color, is_recurring, recurring_type, created_by) VALUES
('New Year''s Day', 'New Year''s Day Holiday', '2025-01-01', '2025-01-01', 'HOLIDAY', '#ff9800', TRUE, 'YEARLY', 1),
('Republic Day', 'Republic Day of India', '2025-01-26', '2025-01-26', 'HOLIDAY', '#ff9800', TRUE, 'YEARLY', 1),
('Independence Day', 'Independence Day of India', '2025-08-15', '2025-08-15', 'HOLIDAY', '#ff9800', TRUE, 'YEARLY', 1),
('Gandhi Jayanti', 'Mahatma Gandhi''s Birthday', '2025-10-02', '2025-10-02', 'HOLIDAY', '#ff9800', TRUE, 'YEARLY', 1),
('Christmas Day', 'Christmas Holiday', '2025-12-25', '2025-12-25', 'HOLIDAY', '#ff9800', TRUE, 'YEARLY', 1); 