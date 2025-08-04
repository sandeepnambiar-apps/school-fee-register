package com.school.studentservice.dto;

import com.school.studentservice.model.Homework;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.time.LocalDate;
import java.time.LocalDateTime;

public class HomeworkDTO {
    
    private Long id;
    
    @NotBlank(message = "Title is required")
    private String title;
    
    @NotBlank(message = "Description is required")
    private String description;
    
    @NotNull(message = "Subject is required")
    private Long subjectId;
    
    @NotNull(message = "Class is required")
    private Long classId;
    
    private String section;
    
    @NotNull(message = "Teacher is required")
    private Long teacherId;
    
    private Long academicYearId;
    
    @NotNull(message = "Assigned date is required")
    private LocalDate assignedDate;
    
    @NotNull(message = "Due date is required")
    private LocalDate dueDate;
    
    private String attachmentUrl;
    
    private String attachmentName;
    
    private Homework.Priority priority = Homework.Priority.NORMAL;
    
    private Homework.Status status = Homework.Status.ACTIVE;
    
    private LocalDateTime createdAt;
    
    private LocalDateTime updatedAt;
    
    // Additional fields for display
    private String subjectName;
    private String className;
    private String teacherName;
    
    // Constructors
    public HomeworkDTO() {}
    
    public HomeworkDTO(Homework homework) {
        this.id = homework.getId();
        this.title = homework.getTitle();
        this.description = homework.getDescription();
        this.subjectId = homework.getSubjectId();
        this.classId = homework.getClassId();
        this.section = homework.getSection();
        this.teacherId = homework.getTeacherId();
        this.academicYearId = homework.getAcademicYearId();
        this.assignedDate = homework.getAssignedDate();
        this.dueDate = homework.getDueDate();
        this.attachmentUrl = homework.getAttachmentUrl();
        this.attachmentName = homework.getAttachmentName();
        this.priority = homework.getPriority();
        this.status = homework.getStatus();
        this.createdAt = homework.getCreatedAt();
        this.updatedAt = homework.getUpdatedAt();
        
        // Set related entity names if available
        if (homework.getSubject() != null) {
            this.subjectName = homework.getSubject().getName();
        }
        if (homework.getClassInfo() != null) {
            this.className = homework.getClassInfo().getName();
        }
    }
    
    // Convert to Entity
    public Homework toEntity() {
        Homework homework = new Homework();
        homework.setId(this.id);
        homework.setTitle(this.title);
        homework.setDescription(this.description);
        homework.setSubjectId(this.subjectId);
        homework.setClassId(this.classId);
        homework.setSection(this.section);
        homework.setTeacherId(this.teacherId);
        homework.setAcademicYearId(this.academicYearId);
        homework.setAssignedDate(this.assignedDate);
        homework.setDueDate(this.dueDate);
        homework.setAttachmentUrl(this.attachmentUrl);
        homework.setAttachmentName(this.attachmentName);
        homework.setPriority(this.priority);
        homework.setStatus(this.status);
        homework.setCreatedAt(this.createdAt);
        homework.setUpdatedAt(this.updatedAt);
        return homework;
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public String getTitle() {
        return title;
    }
    
    public void setTitle(String title) {
        this.title = title;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
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
    
    public String getSection() {
        return section;
    }
    
    public void setSection(String section) {
        this.section = section;
    }
    
    public Long getTeacherId() {
        return teacherId;
    }
    
    public void setTeacherId(Long teacherId) {
        this.teacherId = teacherId;
    }
    
    public Long getAcademicYearId() {
        return academicYearId;
    }
    
    public void setAcademicYearId(Long academicYearId) {
        this.academicYearId = academicYearId;
    }
    
    public LocalDate getAssignedDate() {
        return assignedDate;
    }
    
    public void setAssignedDate(LocalDate assignedDate) {
        this.assignedDate = assignedDate;
    }
    
    public LocalDate getDueDate() {
        return dueDate;
    }
    
    public void setDueDate(LocalDate dueDate) {
        this.dueDate = dueDate;
    }
    
    public String getAttachmentUrl() {
        return attachmentUrl;
    }
    
    public void setAttachmentUrl(String attachmentUrl) {
        this.attachmentUrl = attachmentUrl;
    }
    
    public String getAttachmentName() {
        return attachmentName;
    }
    
    public void setAttachmentName(String attachmentName) {
        this.attachmentName = attachmentName;
    }
    
    public Homework.Priority getPriority() {
        return priority;
    }
    
    public void setPriority(Homework.Priority priority) {
        this.priority = priority;
    }
    
    public Homework.Status getStatus() {
        return status;
    }
    
    public void setStatus(Homework.Status status) {
        this.status = status;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
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