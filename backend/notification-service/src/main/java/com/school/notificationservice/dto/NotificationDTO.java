package com.school.notificationservice.dto;

import com.school.notificationservice.model.Notification;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.time.LocalDateTime;
import java.util.List;

public class NotificationDTO {
    
    private Long id;
    
    @NotBlank(message = "Title is required")
    private String title;
    
    @NotBlank(message = "Message is required")
    private String message;
    
    @NotNull(message = "Notification type is required")
    private Notification.NotificationType type;
    
    private Notification.Priority priority = Notification.Priority.NORMAL;
    
    @NotNull(message = "Target audience is required")
    private Notification.TargetAudience targetAudience;
    
    private Long classId; // null for all classes
    
    private Long academicYearId;
    
    private LocalDateTime scheduledAt;
    
    private LocalDateTime sentAt;
    
    private Notification.Status status = Notification.Status.DRAFT;
    
    private String createdBy;
    
    private LocalDateTime createdAt;
    
    private LocalDateTime updatedAt;
    
    // Additional fields for bulk operations
    private List<Long> studentIds; // For specific students
    private List<String> deliveryMethods; // IN_APP, EMAIL, SMS, PUSH_NOTIFICATION
    
    private String section; // null for all sections
    
    // Constructors
    public NotificationDTO() {}
    
    public NotificationDTO(Notification notification) {
        this.id = notification.getId();
        this.title = notification.getTitle();
        this.message = notification.getMessage();
        this.type = notification.getType();
        this.priority = notification.getPriority();
        this.targetAudience = notification.getTargetAudience();
        this.classId = notification.getClassId();
        this.academicYearId = notification.getAcademicYearId();
        this.scheduledAt = notification.getScheduledAt();
        this.sentAt = notification.getSentAt();
        this.status = notification.getStatus();
        this.createdBy = notification.getCreatedBy();
        this.createdAt = notification.getCreatedAt();
        this.updatedAt = notification.getUpdatedAt();
        this.section = notification.getSection();
    }
    
    // Convert to Entity
    public Notification toEntity() {
        Notification notification = new Notification();
        notification.setId(this.id);
        notification.setTitle(this.title);
        notification.setMessage(this.message);
        notification.setType(this.type);
        notification.setPriority(this.priority);
        notification.setTargetAudience(this.targetAudience);
        notification.setClassId(this.classId);
        notification.setAcademicYearId(this.academicYearId);
        notification.setScheduledAt(this.scheduledAt);
        notification.setSentAt(this.sentAt);
        notification.setStatus(this.status);
        notification.setCreatedBy(this.createdBy);
        notification.setCreatedAt(this.createdAt);
        notification.setUpdatedAt(this.updatedAt);
        notification.setSection(this.section);
        return notification;
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
    
    public Notification.NotificationType getType() {
        return type;
    }
    
    public void setType(Notification.NotificationType type) {
        this.type = type;
    }
    
    public Notification.Priority getPriority() {
        return priority;
    }
    
    public void setPriority(Notification.Priority priority) {
        this.priority = priority;
    }
    
    public Notification.TargetAudience getTargetAudience() {
        return targetAudience;
    }
    
    public void setTargetAudience(Notification.TargetAudience targetAudience) {
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
    
    public Notification.Status getStatus() {
        return status;
    }
    
    public void setStatus(Notification.Status status) {
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
    
    public List<Long> getStudentIds() {
        return studentIds;
    }
    
    public void setStudentIds(List<Long> studentIds) {
        this.studentIds = studentIds;
    }
    
    public List<String> getDeliveryMethods() {
        return deliveryMethods;
    }
    
    public void setDeliveryMethods(List<String> deliveryMethods) {
        this.deliveryMethods = deliveryMethods;
    }
    
    public String getSection() {
        return section;
    }
    
    public void setSection(String section) {
        this.section = section;
    }
} 