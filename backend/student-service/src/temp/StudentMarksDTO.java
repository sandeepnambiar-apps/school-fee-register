package com.school.studentservice.dto;

import com.school.studentservice.model.StudentMarks.ExamType;
import java.time.LocalDate;
import java.math.BigDecimal;

public class StudentMarksDTO {
    
    private Long id;
    private Long studentId;
    private Long subjectId;
    private Long classId;
    private Long teacherId;
    private ExamType examType;
    private LocalDate examDate;
    private BigDecimal marksObtained;
    private BigDecimal totalMarks;
    private BigDecimal percentage;
    private String grade;
    private String remarks;
    private LocalDate createdAt;
    private LocalDate updatedAt;
    
    // Additional fields for display
    private String studentName;
    private String subjectName;
    private String className;
    private String teacherName;
    
    // Constructors
    public StudentMarksDTO() {}
    
    public StudentMarksDTO(Long studentId, Long subjectId, Long classId, Long teacherId,
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
    }
    
    public BigDecimal getTotalMarks() {
        return totalMarks;
    }
    
    public void setTotalMarks(BigDecimal totalMarks) {
        this.totalMarks = totalMarks;
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
    
    public String getStudentName() {
        return studentName;
    }
    
    public void setStudentName(String studentName) {
        this.studentName = studentName;
    }
    
    public String getSubjectName() {
        return subjectName;
    }
    
    public void setSubjectName(String subjectName) {
        this.subjectName = subjectName;
    }
    
    public String getClassName() {
        return className;
    }
    
    public void setClassName(String className) {
        this.className = className;
    }
    
    public String getTeacherName() {
        return teacherName;
    }
    
    public void setTeacherName(String teacherName) {
        this.teacherName = teacherName;
    }
} 