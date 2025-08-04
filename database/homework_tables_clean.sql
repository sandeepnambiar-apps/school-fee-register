-- Homework System Database Tables
-- This file contains all the necessary tables for the homework management system

-- Subjects table
CREATE TABLE IF NOT EXISTS subjects (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    code VARCHAR(10) NOT NULL UNIQUE,
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_subject_code (code),
    INDEX idx_subject_active (is_active)
);

-- Teacher-Subject assignments
CREATE TABLE IF NOT EXISTS teacher_subjects (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    teacher_id BIGINT NOT NULL,
    subject_id BIGINT NOT NULL,
    class_id BIGINT NOT NULL,
    section VARCHAR(10) NOT NULL,
    academic_year_id BIGINT NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (teacher_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (subject_id) REFERENCES subjects(id) ON DELETE CASCADE,
    FOREIGN KEY (class_id) REFERENCES classes(id) ON DELETE CASCADE,
    FOREIGN KEY (academic_year_id) REFERENCES academic_years(id) ON DELETE CASCADE,
    UNIQUE KEY unique_teacher_subject_class (teacher_id, subject_id, class_id, section, academic_year_id),
    INDEX idx_teacher_subject (teacher_id, subject_id),
    INDEX idx_class_section (class_id, section),
    INDEX idx_academic_year (academic_year_id)
);

-- Homework table
CREATE TABLE IF NOT EXISTS homework (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    subject_id BIGINT NOT NULL,
    class_id BIGINT NOT NULL,
    section VARCHAR(10) NOT NULL,
    teacher_id BIGINT NOT NULL,
    academic_year_id BIGINT NOT NULL,
    assigned_date DATE NOT NULL,
    due_date DATE NOT NULL,
    priority ENUM('LOW', 'NORMAL', 'HIGH', 'URGENT') DEFAULT 'NORMAL',
    status ENUM('ACTIVE', 'COMPLETED', 'ARCHIVED') DEFAULT 'ACTIVE',
    attachment_url VARCHAR(500),
    attachment_name VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (subject_id) REFERENCES subjects(id) ON DELETE CASCADE,
    FOREIGN KEY (class_id) REFERENCES classes(id) ON DELETE CASCADE,
    FOREIGN KEY (teacher_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (academic_year_id) REFERENCES academic_years(id) ON DELETE CASCADE,
    INDEX idx_homework_teacher (teacher_id),
    INDEX idx_homework_subject (subject_id),
    INDEX idx_homework_class_section (class_id, section),
    INDEX idx_homework_due_date (due_date),
    INDEX idx_homework_status (status),
    INDEX idx_homework_priority (priority),
    INDEX idx_homework_academic_year (academic_year_id)
);

-- Homework submissions (for future enhancement)
CREATE TABLE IF NOT EXISTS homework_submissions (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    homework_id BIGINT NOT NULL,
    student_id BIGINT NOT NULL,
    submission_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    submission_text TEXT,
    attachment_url VARCHAR(500),
    attachment_name VARCHAR(255),
    grade DECIMAL(5,2),
    feedback TEXT,
    status ENUM('SUBMITTED', 'GRADED', 'LATE') DEFAULT 'SUBMITTED',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (homework_id) REFERENCES homework(id) ON DELETE CASCADE,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    UNIQUE KEY unique_homework_student (homework_id, student_id),
    INDEX idx_submission_homework (homework_id),
    INDEX idx_submission_student (student_id),
    INDEX idx_submission_status (status)
);

-- Insert sample subjects
INSERT INTO subjects (name, code, description) VALUES
('Mathematics', 'MATH', 'Core mathematics including algebra, geometry, and calculus'),
('Science', 'SCI', 'General science including physics, chemistry, and biology'),
('English', 'ENG', 'English language and literature'),
('History', 'HIST', 'World history and social studies'),
('Geography', 'GEO', 'Physical and human geography'),
('Computer Science', 'CS', 'Programming and computer fundamentals'),
('Physical Education', 'PE', 'Sports and physical fitness'),
('Art', 'ART', 'Creative arts and design'),
('Music', 'MUSIC', 'Music theory and performance'),
('Literature', 'LIT', 'Advanced literature and composition');

-- Insert sample teacher-subject assignments (IDs 3-12)
INSERT INTO teacher_subjects (teacher_id, subject_id, class_id, section, academic_year_id) VALUES
(3, 1, 1, 'A', 1), -- Math teacher for Class 1A
(3, 1, 1, 'B', 1), -- Math teacher for Class 1B
(4, 2, 1, 'A', 1), -- Science teacher for Class 1A
(4, 2, 1, 'B', 1), -- Science teacher for Class 1B
(5, 3, 1, 'A', 1), -- English teacher for Class 1A
(5, 3, 1, 'B', 1), -- English teacher for Class 1B
(3, 1, 2, 'A', 1), -- Math teacher for Class 2A
(4, 2, 2, 'A', 1), -- Science teacher for Class 2A
(5, 3, 2, 'A', 1), -- English teacher for Class 2A
(6, 4, 2, 'A', 1); -- History teacher for Class 2A

-- Insert sample homework assignments (IDs 3-12)
INSERT INTO homework (title, description, subject_id, class_id, section, teacher_id, academic_year_id, assigned_date, due_date, priority, status, attachment_url, attachment_name) VALUES
('Algebra Basics', 'Complete exercises 1-20 in Chapter 3. Focus on solving linear equations.', 1, 1, 'A', 3, 1, '2024-01-15', '2024-01-22', 'NORMAL', 'ACTIVE', 'https://example.com/algebra-worksheet.pdf', 'Algebra_Worksheet.pdf'),
('Science Project', 'Research and create a presentation on renewable energy sources. Include at least 3 sources.', 2, 1, 'A', 4, 1, '2024-01-16', '2024-01-30', 'HIGH', 'ACTIVE', 'https://example.com/science-project-guidelines.pdf', 'Project_Guidelines.pdf'),
('Essay Writing', 'Write a 500-word essay on "The Importance of Education". Follow MLA format.', 3, 1, 'A', 5, 1, '2024-01-17', '2024-01-24', 'NORMAL', 'ACTIVE', NULL, NULL),
('World War II Timeline', 'Create a timeline of major events during World War II. Include dates and brief descriptions.', 4, 2, 'A', 6, 1, '2024-01-18', '2024-01-25', 'LOW', 'ACTIVE', 'https://example.com/ww2-resources.pdf', 'WW2_Resources.pdf'),
('Geography Quiz Preparation', 'Study chapters 5-7 for the upcoming geography quiz. Focus on climate zones and natural resources.', 5, 2, 'A', 7, 1, '2024-01-19', '2024-01-26', 'URGENT', 'ACTIVE', NULL, NULL),
('Programming Basics', 'Complete the Python programming exercises in the online platform. Submit screenshots of completed exercises.', 6, 2, 'A', 8, 1, '2024-01-20', '2024-01-27', 'HIGH', 'ACTIVE', 'https://example.com/python-exercises.pdf', 'Python_Exercises.pdf'),
('Physical Fitness Log', 'Maintain a daily fitness log for one week. Record activities, duration, and heart rate.', 7, 1, 'B', 9, 1, '2024-01-21', '2024-01-28', 'NORMAL', 'ACTIVE', 'https://example.com/fitness-log-template.pdf', 'Fitness_Log_Template.pdf'),
('Art Portfolio', 'Create 3 original artworks using different mediums. Include a brief description of each piece.', 8, 2, 'A', 10, 1, '2024-01-22', '2024-02-05', 'NORMAL', 'ACTIVE', NULL, NULL),
('Music Theory Assignment', 'Complete the music theory worksheet on scales and chords. Practice the assigned pieces.', 9, 1, 'A', 11, 1, '2024-01-23', '2024-01-30', 'LOW', 'ACTIVE', 'https://example.com/music-theory-worksheet.pdf', 'Music_Theory_Worksheet.pdf'),
('Literature Analysis', 'Read Chapter 5 of "To Kill a Mockingbird" and write a character analysis of Scout.', 10, 2, 'A', 12, 1, '2024-01-24', '2024-01-31', 'HIGH', 'ACTIVE', 'https://example.com/character-analysis-template.pdf', 'Character_Analysis_Template.pdf');

-- Create views for easier querying
CREATE VIEW homework_with_details AS
SELECT 
    h.id,
    h.title,
    h.description,
    h.subject_id,
    s.name as subject_name,
    s.code as subject_code,
    h.class_id,
    c.name as class_name,
    h.section,
    h.teacher_id,
    CONCAT(u.first_name, ' ', u.last_name) as teacher_name,
    h.academic_year_id,
    ay.name as academic_year_name,
    h.assigned_date,
    h.due_date,
    h.priority,
    h.status,
    h.attachment_url,
    h.attachment_name,
    h.created_at,
    h.updated_at
FROM homework h
JOIN subjects s ON h.subject_id = s.id
JOIN classes c ON h.class_id = c.id
JOIN users u ON h.teacher_id = u.id
JOIN academic_years ay ON h.academic_year_id = ay.id;

-- Create view for homework statistics
CREATE VIEW homework_statistics AS
SELECT 
    teacher_id,
    subject_id,
    class_id,
    section,
    academic_year_id,
    COUNT(*) as total_homework,
    COUNT(CASE WHEN status = 'ACTIVE' THEN 1 END) as active_homework,
    COUNT(CASE WHEN status = 'COMPLETED' THEN 1 END) as completed_homework,
    COUNT(CASE WHEN status = 'ARCHIVED' THEN 1 END) as archived_homework,
    COUNT(CASE WHEN due_date < CURDATE() AND status = 'ACTIVE' THEN 1 END) as overdue_homework,
    COUNT(CASE WHEN due_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 7 DAY) AND status = 'ACTIVE' THEN 1 END) as upcoming_homework
FROM homework
GROUP BY teacher_id, subject_id, class_id, section, academic_year_id;

-- Create indexes for better performance
CREATE INDEX idx_homework_teacher_subject ON homework(teacher_id, subject_id);
CREATE INDEX idx_homework_class_section_academic ON homework(class_id, section, academic_year_id);
CREATE INDEX idx_homework_due_date_status ON homework(due_date, status);
CREATE INDEX idx_homework_priority_status ON homework(priority, status);

-- Create stored procedure for getting homework by teacher with filters
DELIMITER //
CREATE PROCEDURE GetHomeworkByTeacher(
    IN p_teacher_id BIGINT,
    IN p_subject_id BIGINT,
    IN p_class_id BIGINT,
    IN p_section VARCHAR(10),
    IN p_status VARCHAR(20),
    IN p_priority VARCHAR(20)
)
BEGIN
    SELECT 
        h.*,
        s.name as subject_name,
        c.name as class_name,
        CONCAT(u.first_name, ' ', u.last_name) as teacher_name
    FROM homework h
    JOIN subjects s ON h.subject_id = s.id
    JOIN classes c ON h.class_id = c.id
    JOIN users u ON h.teacher_id = u.id
    WHERE h.teacher_id = p_teacher_id
        AND (p_subject_id IS NULL OR h.subject_id = p_subject_id)
        AND (p_class_id IS NULL OR h.class_id = p_class_id)
        AND (p_section IS NULL OR h.section = p_section)
        AND (p_status IS NULL OR h.status = p_status)
        AND (p_priority IS NULL OR h.priority = p_priority)
    ORDER BY h.due_date ASC, h.priority DESC;
END //
DELIMITER ;

-- Create stored procedure for getting homework statistics
DELIMITER //
CREATE PROCEDURE GetHomeworkStatistics(
    IN p_teacher_id BIGINT,
    IN p_academic_year_id BIGINT
)
BEGIN
    SELECT 
        COUNT(*) as total_homework,
        COUNT(CASE WHEN status = 'ACTIVE' THEN 1 END) as active_homework,
        COUNT(CASE WHEN status = 'COMPLETED' THEN 1 END) as completed_homework,
        COUNT(CASE WHEN status = 'ARCHIVED' THEN 1 END) as archived_homework,
        COUNT(CASE WHEN due_date < CURDATE() AND status = 'ACTIVE' THEN 1 END) as overdue_homework,
        COUNT(CASE WHEN due_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 7 DAY) AND status = 'ACTIVE' THEN 1 END) as upcoming_homework,
        COUNT(CASE WHEN priority = 'URGENT' THEN 1 END) as urgent_homework,
        COUNT(CASE WHEN priority = 'HIGH' THEN 1 END) as high_priority_homework,
        COUNT(CASE WHEN priority = 'NORMAL' THEN 1 END) as normal_priority_homework,
        COUNT(CASE WHEN priority = 'LOW' THEN 1 END) as low_priority_homework
    FROM homework
    WHERE teacher_id = p_teacher_id
        AND (p_academic_year_id IS NULL OR academic_year_id = p_academic_year_id);
END //
DELIMITER ; 