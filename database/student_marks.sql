-- Create student_marks table
CREATE TABLE IF NOT EXISTS student_marks (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    student_id BIGINT NOT NULL,
    subject_id BIGINT NOT NULL,
    class_id BIGINT NOT NULL,
    teacher_id BIGINT NOT NULL,
    exam_type ENUM('UNIT_TEST', 'MID_TERM', 'FINAL_EXAM', 'QUIZ', 'ASSIGNMENT') NOT NULL,
    exam_date DATE NOT NULL,
    marks_obtained DECIMAL(5,2) NOT NULL,
    total_marks DECIMAL(5,2) NOT NULL,
    percentage DECIMAL(5,2),
    grade VARCHAR(3),
    remarks VARCHAR(500),
    created_at DATE DEFAULT CURRENT_DATE,
    updated_at DATE DEFAULT CURRENT_DATE ON UPDATE CURRENT_DATE,
    
    -- Foreign key constraints
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY (subject_id) REFERENCES subjects(id) ON DELETE CASCADE,
    FOREIGN KEY (class_id) REFERENCES classes(id) ON DELETE CASCADE,
    
    -- Indexes for better performance
    INDEX idx_student_id (student_id),
    INDEX idx_subject_id (subject_id),
    INDEX idx_class_id (class_id),
    INDEX idx_teacher_id (teacher_id),
    INDEX idx_exam_date (exam_date),
    INDEX idx_exam_type (exam_type)
);

-- Insert sample data for testing
INSERT INTO student_marks (student_id, subject_id, class_id, teacher_id, exam_type, exam_date, marks_obtained, total_marks, remarks) VALUES
(1, 1, 1, 1, 'UNIT_TEST', '2024-01-15', 85.00, 100.00, 'Good performance in Mathematics'),
(1, 2, 1, 2, 'UNIT_TEST', '2024-01-16', 92.00, 100.00, 'Excellent work in English'),
(1, 3, 1, 3, 'UNIT_TEST', '2024-01-17', 78.00, 100.00, 'Needs improvement in Science'),
(2, 1, 1, 1, 'UNIT_TEST', '2024-01-15', 90.00, 100.00, 'Outstanding performance'),
(2, 2, 1, 2, 'UNIT_TEST', '2024-01-16', 88.00, 100.00, 'Very good work'),
(2, 3, 1, 3, 'UNIT_TEST', '2024-01-17', 95.00, 100.00, 'Excellent understanding'),
(3, 1, 2, 1, 'MID_TERM', '2024-01-20', 82.00, 100.00, 'Good effort'),
(3, 2, 2, 2, 'MID_TERM', '2024-01-21', 87.00, 100.00, 'Well done'),
(3, 3, 2, 3, 'MID_TERM', '2024-01-22', 91.00, 100.00, 'Excellent work'),
(4, 1, 2, 1, 'MID_TERM', '2024-01-20', 89.00, 100.00, 'Great performance'),
(4, 2, 2, 2, 'MID_TERM', '2024-01-21', 93.00, 100.00, 'Outstanding'),
(4, 3, 2, 3, 'MID_TERM', '2024-01-22', 86.00, 100.00, 'Good work'),
(5, 1, 3, 1, 'QUIZ', '2024-01-25', 95.00, 100.00, 'Perfect score'),
(5, 2, 3, 2, 'QUIZ', '2024-01-26', 88.00, 100.00, 'Very good'),
(5, 3, 3, 3, 'QUIZ', '2024-01-27', 92.00, 100.00, 'Excellent'),
(6, 1, 3, 1, 'QUIZ', '2024-01-25', 87.00, 100.00, 'Good work'),
(6, 2, 3, 2, 'QUIZ', '2024-01-26', 91.00, 100.00, 'Well done'),
(6, 3, 3, 3, 'QUIZ', '2024-01-27', 89.00, 100.00, 'Great effort'); 