package com.school.studentservice.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "homework")
public class Homework {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @NotBlank
    @Column(name = "title")
    private String title;
    
    @NotBlank
    @Column(columnDefinition = "TEXT")
    private String description;
    
    @NotNull
    @Column(name = "subject_id")
    private Long subjectId;
    
    @NotNull
    @Column(name = "class_id")
    private Long classId;
    
    @Column(name = "section")
    private String section;
    
    @NotNull
    @Column(name = "teacher_id")
    private Long teacherId;
    
    @Column(name = "academic_year_id")
    private Long academicYearId;
    
    @NotNull
    @Column(name = "assigned_date")
    private LocalDate assignedDate;
    
    @NotNull
    @Column(name = "due_date")
    private LocalDate dueDate;
    
    @Column(name = "attachment_url")
    private String attachmentUrl;
    
    @Column(name = "attachment_name")
    private String attachmentName;
    
    @Enumerated(EnumType.STRING)
    private Priority priority = Priority.NORMAL;
    
    @Enumerated(EnumType.STRING)
    private Status status = Status.ACTIVE;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
    
    // Many-to-One relationships
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "subject_id", insertable = false, updatable = false)
    private Subject subject;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "class_id", insertable = false, updatable = false)
    private Class classInfo;
    
    public enum Priority {
        LOW, NORMAL, HIGH, URGENT
    }
    
    public enum Status {
        ACTIVE, COMPLETED, CANCELLED, ARCHIVED
    }
    
    // Constructors
    public Homework() {}
    
    public Homework(String title, String description, Long subjectId, Long classId, String section, 
                   Long teacherId, LocalDate assignedDate, LocalDate dueDate) {
        this.title = title;
        this.description = description;
        this.subjectId = subjectId;
        this.classId = classId;
        this.section = section;
        this.teacherId = teacherId;
        this.assignedDate = assignedDate;
        this.dueDate = dueDate;
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
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
    
    public Priority getPriority() {
        return priority;
    }
    
    public void setPriority(Priority priority) {
        this.priority = priority;
    }
    
    public Status getStatus() {
        return status;
    }
    
    public void setStatus(Status status) {
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
    
    public Subject getSubject() {
        return subject;
    }
    
    public void setSubject(Subject subject) {
        this.subject = subject;
    }
    
    public Class getClassInfo() {
        return classInfo;
    }
    
    public void setClassInfo(Class classInfo) {
        this.classInfo = classInfo;
    }
    
    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }
    
    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
} 