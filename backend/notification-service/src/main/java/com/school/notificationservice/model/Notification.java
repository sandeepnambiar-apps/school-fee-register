package com.school.notificationservice.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.time.LocalDateTime;

@Entity
@Table(name = "notifications")
public class Notification {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @NotBlank
    @Column(name = "title")
    private String title;
    
    @NotBlank
    @Column(columnDefinition = "TEXT")
    private String message;
    
    @NotNull
    @Enumerated(EnumType.STRING)
    private NotificationType type;
    
    @Enumerated(EnumType.STRING)
    private Priority priority = Priority.NORMAL;
    
    @Column(name = "target_audience")
    @Enumerated(EnumType.STRING)
    private TargetAudience targetAudience;
    
    @Column(name = "class_id")
    private Long classId; // null for all classes
    
    @Column(name = "academic_year_id")
    private Long academicYearId;
    
    @Column(name = "scheduled_at")
    private LocalDateTime scheduledAt;
    
    @Column(name = "sent_at")
    private LocalDateTime sentAt;
    
    @Enumerated(EnumType.STRING)
    private Status status = Status.DRAFT;
    
    @Column(name = "created_by")
    private String createdBy;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
    
    @Column(name = "section")
    private String section; // null for all sections
    
    public enum NotificationType {
        HOLIDAY, CIRCULAR, ANNOUNCEMENT, FEE_REMINDER, EXAM_SCHEDULE, 
        SPORTS_EVENT, CULTURAL_EVENT, EMERGENCY, GENERAL
    }
    
    public enum Priority {
        LOW, NORMAL, HIGH, URGENT
    }
    
    public enum TargetAudience {
        ALL_PARENTS, ALL_STUDENTS, SPECIFIC_CLASS, SPECIFIC_STUDENT, 
        ALL_STAFF, ADMIN_ONLY
    }
    
    public enum Status {
        DRAFT, SCHEDULED, SENT, FAILED, CANCELLED
    }
    
    // Constructors
    public Notification() {}
    
    public Notification(String title, String message, NotificationType type, TargetAudience targetAudience) {
        this.title = title;
        this.message = message;
        this.type = type;
        this.targetAudience = targetAudience;
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
    
    public String getMessage() {
        return message;
    }
    
    public void setMessage(String message) {
        this.message = message;
    }
    
    public NotificationType getType() {
        return type;
    }
    
    public void setType(NotificationType type) {
        this.type = type;
    }
    
    public Priority getPriority() {
        return priority;
    }
    
    public void setPriority(Priority priority) {
        this.priority = priority;
    }
    
    public TargetAudience getTargetAudience() {
        return targetAudience;
    }
    
    public void setTargetAudience(TargetAudience targetAudience) {
        this.targetAudience = targetAudience;
    }
    
    public Long getClassId() {
        return classId;
    }
    
    public void setClassId(Long classId) {
        this.classId = classId;
    }
    
    public Long getAcademicYearId() {
        return academicYearId;
    }
    
    public void setAcademicYearId(Long academicYearId) {
        this.academicYearId = academicYearId;
    }
    
    public LocalDateTime getScheduledAt() {
        return scheduledAt;
    }
    
    public void setScheduledAt(LocalDateTime scheduledAt) {
        this.scheduledAt = scheduledAt;
    }
    
    public LocalDateTime getSentAt() {
        return sentAt;
    }
    
    public void setSentAt(LocalDateTime sentAt) {
        this.sentAt = sentAt;
    }
    
    public Status getStatus() {
        return status;
    }
    
    public void setStatus(Status status) {
        this.status = status;
    }
    
    public String getCreatedBy() {
        return createdBy;
    }
    
    public void setCreatedBy(String createdBy) {
        this.createdBy = createdBy;
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
    
    public String getSection() {
        return section;
    }
    
    public void setSection(String section) {
        this.section = section;
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