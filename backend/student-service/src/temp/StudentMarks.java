package com.school.studentservice.model;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.math.BigDecimal;

@Entity
@Table(name = "student_marks")
public class StudentMarks {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "student_id", nullable = false)
    private Long studentId;
    
    @Column(name = "subject_id", nullable = false)
    private Long subjectId;
    
    @Column(name = "class_id", nullable = false)
    private Long classId;
    
    @Column(name = "teacher_id", nullable = false)
    private Long teacherId;
    
    @Enumerated(EnumType.STRING)
    @Column(name = "exam_type", nullable = false)
    private ExamType examType;
    
    @Column(name = "exam_date", nullable = false)
    private LocalDate examDate;
    
    @Column(name = "marks_obtained", nullable = false, precision = 5, scale = 2)
    private BigDecimal marksObtained;
    
    @Column(name = "total_marks", nullable = false, precision = 5, scale = 2)
    private BigDecimal totalMarks;
    
    @Column(name = "percentage", precision = 5, scale = 2)
    private BigDecimal percentage;
    
    @Column(name = "grade", length = 3)
    private String grade;
    
    @Column(name = "remarks", length = 500)
    private String remarks;
    
    @Column(name = "created_at")
    private LocalDate createdAt;
    
    @Column(name = "updated_at")
    private LocalDate updatedAt;
    
    // Constructors
    public StudentMarks() {}
    
    public StudentMarks(Long studentId, Long subjectId, Long classId, Long teacherId, 
                       ExamType examType, LocalDate examDate, BigDecimal marksObtained, 
                       BigDecimal totalMarks, String remarks) {
        this.studentId = studentId;
        this.subjectId = subjectId;
        this.classId = classId;
        this.teacherId = teacherId;
        this.examType = examType;
        this.examDate = examDate;
        this.marksObtained = marksObtained;
        this.totalMarks = totalMarks;
        this.remarks = remarks;
        this.calculatePercentageAndGrade();
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public Long getStudentId() {
        return studentId;
    }
    
    public void setStudentId(Long studentId) {
        this.studentId = studentId;
    }
    
    public Long getSubjectId() {
        return subjectId;
    }
    
    public void setSubjectId(Long subjectId) {
        this.subjectId = subjectId;
    }
    
    public Long getClassId() {
        return classId;
    }
    
    public void setClassId(Long classId) {
        this.classId = classId;
    }
    
    public Long getTeacherId() {
        return teacherId;
    }
    
    public void setTeacherId(Long teacherId) {
        this.teacherId = teacherId;
    }
    
    public ExamType getExamType() {
        return examType;
    }
    
    public void setExamType(ExamType examType) {
        this.examType = examType;
    }
    
    public LocalDate getExamDate() {
        return examDate;
    }
    
    public void setExamDate(LocalDate examDate) {
        this.examDate = examDate;
    }
    
    public BigDecimal getMarksObtained() {
        return marksObtained;
    }
    
    public void setMarksObtained(BigDecimal marksObtained) {
        this.marksObtained = marksObtained;
        this.calculatePercentageAndGrade();
    }
    
    public BigDecimal getTotalMarks() {
        return totalMarks;
    }
    
    public void setTotalMarks(BigDecimal totalMarks) {
        this.totalMarks = totalMarks;
        this.calculatePercentageAndGrade();
    }
    
    public BigDecimal getPercentage() {
        return percentage;
    }
    
    public void setPercentage(BigDecimal percentage) {
        this.percentage = percentage;
    }
    
    public String getGrade() {
        return grade;
    }
    
    public void setGrade(String grade) {
        this.grade = grade;
    }
    
    public String getRemarks() {
        return remarks;
    }
    
    public void setRemarks(String remarks) {
        this.remarks = remarks;
    }
    
    public LocalDate getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(LocalDate createdAt) {
        this.createdAt = createdAt;
    }
    
    public LocalDate getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(LocalDate updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    // Helper method to calculate percentage and grade
    private void calculatePercentageAndGrade() {
        if (marksObtained != null && totalMarks != null && totalMarks.compareTo(BigDecimal.ZERO) > 0) {
            this.percentage = marksObtained.divide(totalMarks, 2, BigDecimal.ROUND_HALF_UP)
                                          .multiply(new BigDecimal("100"));
            this.grade = calculateGrade(this.percentage);
        }
    }
    
    private String calculateGrade(BigDecimal percentage) {
        if (percentage.compareTo(new BigDecimal("90")) >= 0) return "A+";
        if (percentage.compareTo(new BigDecimal("80")) >= 0) return "A";
        if (percentage.compareTo(new BigDecimal("70")) >= 0) return "B+";
        if (percentage.compareTo(new BigDecimal("60")) >= 0) return "B";
        if (percentage.compareTo(new BigDecimal("50")) >= 0) return "C+";
        if (percentage.compareTo(new BigDecimal("40")) >= 0) return "C";
        return "F";
    }
    
    @PrePersist
    protected void onCreate() {
        createdAt = LocalDate.now();
        updatedAt = LocalDate.now();
    }
    
    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDate.now();
    }
    
    // Exam Type Enum
    public enum ExamType {
        UNIT_TEST,
        MID_TERM,
        FINAL_EXAM,
        QUIZ,
        ASSIGNMENT
    }
} 