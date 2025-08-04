-- Create timetable_entries table
CREATE TABLE IF NOT EXISTS timetable_entries (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    day_of_week ENUM('MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY') NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    period_number INT NOT NULL,
    subject_id BIGINT NOT NULL,
    class_id BIGINT NOT NULL,
    section VARCHAR(10) NOT NULL,
    teacher_id BIGINT NOT NULL,
    room_number VARCHAR(20),
    created_by BIGINT,
    updated_by BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_day_period (day_of_week, period_number),
    INDEX idx_class_section (class_id, section),
    INDEX idx_teacher (teacher_id),
    INDEX idx_subject (subject_id),
    INDEX idx_created_by (created_by),
    UNIQUE KEY unique_class_section_day_period (class_id, section, day_of_week, period_number),
    UNIQUE KEY unique_teacher_day_period (teacher_id, day_of_week, period_number)
);

-- Insert sample timetable entries for Class 10 Section A
INSERT INTO timetable_entries (day_of_week, start_time, end_time, period_number, subject_id, class_id, section, teacher_id, room_number, created_by) VALUES
-- Monday
('MONDAY', '08:00:00', '08:45:00', 1, 1, 10, 'A', 1, '101', 1),
('MONDAY', '08:45:00', '09:30:00', 2, 2, 10, 'A', 2, '101', 1),
('MONDAY', '09:30:00', '10:15:00', 3, 3, 10, 'A', 3, '101', 1),
('MONDAY', '10:15:00', '11:00:00', 4, 4, 10, 'A', 4, '101', 1),
('MONDAY', '11:15:00', '12:00:00', 5, 5, 10, 'A', 5, '101', 1),
('MONDAY', '12:00:00', '12:45:00', 6, 1, 10, 'A', 1, '101', 1),
('MONDAY', '14:00:00', '14:45:00', 8, 2, 10, 'A', 2, '101', 1),
('MONDAY', '14:45:00', '15:30:00', 9, 3, 10, 'A', 3, '101', 1),

-- Tuesday
('TUESDAY', '08:00:00', '08:45:00', 1, 2, 10, 'A', 2, '101', 1),
('TUESDAY', '08:45:00', '09:30:00', 2, 3, 10, 'A', 3, '101', 1),
('TUESDAY', '09:30:00', '10:15:00', 3, 4, 10, 'A', 4, '101', 1),
('TUESDAY', '10:15:00', '11:00:00', 4, 5, 10, 'A', 5, '101', 1),
('TUESDAY', '11:15:00', '12:00:00', 5, 1, 10, 'A', 1, '101', 1),
('TUESDAY', '12:00:00', '12:45:00', 6, 2, 10, 'A', 2, '101', 1),
('TUESDAY', '14:00:00', '14:45:00', 8, 3, 10, 'A', 3, '101', 1),
('TUESDAY', '14:45:00', '15:30:00', 9, 4, 10, 'A', 4, '101', 1),

-- Wednesday
('WEDNESDAY', '08:00:00', '08:45:00', 1, 3, 10, 'A', 3, '101', 1),
('WEDNESDAY', '08:45:00', '09:30:00', 2, 4, 10, 'A', 4, '101', 1),
('WEDNESDAY', '09:30:00', '10:15:00', 3, 5, 10, 'A', 5, '101', 1),
('WEDNESDAY', '10:15:00', '11:00:00', 4, 1, 10, 'A', 1, '101', 1),
('WEDNESDAY', '11:15:00', '12:00:00', 5, 2, 10, 'A', 2, '101', 1),
('WEDNESDAY', '12:00:00', '12:45:00', 6, 3, 10, 'A', 3, '101', 1),
('WEDNESDAY', '14:00:00', '14:45:00', 8, 4, 10, 'A', 4, '101', 1),
('WEDNESDAY', '14:45:00', '15:30:00', 9, 5, 10, 'A', 5, '101', 1),

-- Thursday
('THURSDAY', '08:00:00', '08:45:00', 1, 4, 10, 'A', 4, '101', 1),
('THURSDAY', '08:45:00', '09:30:00', 2, 5, 10, 'A', 5, '101', 1),
('THURSDAY', '09:30:00', '10:15:00', 3, 1, 10, 'A', 1, '101', 1),
('THURSDAY', '10:15:00', '11:00:00', 4, 2, 10, 'A', 2, '101', 1),
('THURSDAY', '11:15:00', '12:00:00', 5, 3, 10, 'A', 3, '101', 1),
('THURSDAY', '12:00:00', '12:45:00', 6, 4, 10, 'A', 4, '101', 1),
('THURSDAY', '14:00:00', '14:45:00', 8, 5, 10, 'A', 5, '101', 1),
('THURSDAY', '14:45:00', '15:30:00', 9, 1, 10, 'A', 1, '101', 1),

-- Friday
('FRIDAY', '08:00:00', '08:45:00', 1, 5, 10, 'A', 5, '101', 1),
('FRIDAY', '08:45:00', '09:30:00', 2, 1, 10, 'A', 1, '101', 1),
('FRIDAY', '09:30:00', '10:15:00', 3, 2, 10, 'A', 2, '101', 1),
('FRIDAY', '10:15:00', '11:00:00', 4, 3, 10, 'A', 3, '101', 1),
('FRIDAY', '11:15:00', '12:00:00', 5, 4, 10, 'A', 4, '101', 1),
('FRIDAY', '12:00:00', '12:45:00', 6, 5, 10, 'A', 5, '101', 1),
('FRIDAY', '14:00:00', '14:45:00', 8, 1, 10, 'A', 1, '101', 1),
('FRIDAY', '14:45:00', '15:30:00', 9, 2, 10, 'A', 2, '101', 1);

-- Insert sample timetable entries for Class 9 Section B
INSERT INTO timetable_entries (day_of_week, start_time, end_time, period_number, subject_id, class_id, section, teacher_id, room_number, created_by) VALUES
-- Monday
('MONDAY', '08:00:00', '08:45:00', 1, 2, 9, 'B', 2, '102', 1),
('MONDAY', '08:45:00', '09:30:00', 2, 3, 9, 'B', 3, '102', 1),
('MONDAY', '09:30:00', '10:15:00', 3, 4, 9, 'B', 4, '102', 1),
('MONDAY', '10:15:00', '11:00:00', 4, 5, 9, 'B', 5, '102', 1),
('MONDAY', '11:15:00', '12:00:00', 5, 1, 9, 'B', 1, '102', 1),
('MONDAY', '12:00:00', '12:45:00', 6, 2, 9, 'B', 2, '102', 1),
('MONDAY', '14:00:00', '14:45:00', 8, 3, 9, 'B', 3, '102', 1),
('MONDAY', '14:45:00', '15:30:00', 9, 4, 9, 'B', 4, '102', 1),

-- Tuesday
('TUESDAY', '08:00:00', '08:45:00', 1, 3, 9, 'B', 3, '102', 1),
('TUESDAY', '08:45:00', '09:30:00', 2, 4, 9, 'B', 4, '102', 1),
('TUESDAY', '09:30:00', '10:15:00', 3, 5, 9, 'B', 5, '102', 1),
('TUESDAY', '10:15:00', '11:00:00', 4, 1, 9, 'B', 1, '102', 1),
('TUESDAY', '11:15:00', '12:00:00', 5, 2, 9, 'B', 2, '102', 1),
('TUESDAY', '12:00:00', '12:45:00', 6, 3, 9, 'B', 3, '102', 1),
('TUESDAY', '14:00:00', '14:45:00', 8, 4, 9, 'B', 4, '102', 1),
('TUESDAY', '14:45:00', '15:30:00', 9, 5, 9, 'B', 5, '102', 1); 