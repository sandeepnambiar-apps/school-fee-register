-- Create homework tables
USE school_fee_register;

-- Homework assignments table
CREATE TABLE IF NOT EXISTS homework_assignments (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    subject VARCHAR(100) NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    class_name VARCHAR(50) NOT NULL,
    section VARCHAR(10) NOT NULL,
    teacher_id BIGINT NOT NULL,
    teacher_name VARCHAR(100) NOT NULL,
    assigned_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    due_date TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_class_section (class_name, section),
    INDEX idx_subject (subject),
    INDEX idx_teacher_id (teacher_id),
    INDEX idx_due_date (due_date)
);

-- Homework submissions table
CREATE TABLE IF NOT EXISTS homework_submissions (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    homework_id BIGINT NOT NULL,
    student_id BIGINT NOT NULL,
    submission_text TEXT,
    attachment_url VARCHAR(500),
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('SUBMITTED', 'LATE', 'GRADED') DEFAULT 'SUBMITTED',
    grade VARCHAR(10) NULL,
    feedback TEXT,
    graded_by BIGINT NULL,
    graded_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_homework_id (homework_id),
    INDEX idx_student_id (student_id),
    INDEX idx_status (status),
    INDEX idx_submitted_at (submitted_at),
    FOREIGN KEY (homework_id) REFERENCES homework_assignments(id) ON DELETE CASCADE,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    UNIQUE KEY unique_submission (homework_id, student_id)
);

-- Insert sample homework assignments
INSERT INTO homework_assignments (subject, title, description, class_name, section, teacher_id, teacher_name, due_date) VALUES
('Mathematics', 'Algebra Problems', 'Complete exercises 1-20 from Chapter 5. Show all your work and submit by the due date.', 'Class 10', 'A', 1, 'Mr. Smith', DATE_ADD(NOW(), INTERVAL 3 DAY)),
('English', 'Essay Writing', 'Write a 500-word essay on "The Importance of Education in Modern Society".', 'Class 10', 'A', 2, 'Mrs. Johnson', DATE_ADD(NOW(), INTERVAL 7 DAY)),
('Science', 'Lab Report', 'Complete the lab report for the Chemistry experiment conducted last week.', 'Class 10', 'A', 3, 'Dr. Brown', DATE_ADD(NOW(), INTERVAL 1 DAY)),
('History', 'World War II Research', 'Research paper on the causes and effects of World War II.', 'Class 10', 'A', 4, 'Ms. Davis', DATE_ADD(NOW(), INTERVAL 10 DAY)),
('Physics', 'Force and Motion Problems', 'Solve problems 1-15 from the textbook.', 'Class 10', 'A', 5, 'Mr. Wilson', DATE_ADD(NOW(), INTERVAL 5 DAY));

-- Insert sample homework submissions
INSERT INTO homework_submissions (homework_id, student_id, submission_text, status, submitted_at) VALUES
(4, 1, 'Completed research paper on World War II. The paper covers the main causes including Treaty of Versailles, rise of fascism, and economic depression.', 'GRADED', DATE_SUB(NOW(), INTERVAL 3 DAY)),
(5, 1, 'Completed all physics problems with detailed solutions showing force calculations and motion analysis.', 'GRADED', DATE_SUB(NOW(), INTERVAL 6 DAY)); 