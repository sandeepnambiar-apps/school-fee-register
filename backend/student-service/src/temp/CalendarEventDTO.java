package com.school.studentservice.dto;

import com.school.studentservice.model.CalendarEvent;
import java.time.LocalDate;
import java.time.LocalDateTime;

public class CalendarEventDTO {
    
    private Long id;
    private String title;
    private String description;
    private LocalDate startDate;
    private LocalDate endDate;
    private CalendarEvent.EventType type;
    private String color;
    private Boolean isRecurring;
    private CalendarEvent.RecurringType recurringType;
    private Long createdBy;
    private Long updatedBy;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    // Constructors
    public CalendarEventDTO() {}
    
    public CalendarEventDTO(CalendarEvent event) {
        this.id = event.getId();
        this.title = event.getTitle();
        this.description = event.getDescription();
        this.startDate = event.getStartDate();
        this.endDate = event.getEndDate();
        this.type = event.getType();
        this.color = event.getColor();
        this.isRecurring = event.getIsRecurring();
        this.recurringType = event.getRecurringType();
        this.createdBy = event.getCreatedBy();
        this.updatedBy = event.getUpdatedBy();
        this.createdAt = event.getCreatedAt();
        this.updatedAt = event.getUpdatedAt();
    }
    
    // Convert DTO to Entity
    public CalendarEvent toEntity() {
        CalendarEvent event = new CalendarEvent();
        event.setId(this.id);
        event.setTitle(this.title);
        event.setDescription(this.description);
        event.setStartDate(this.startDate);
        event.setEndDate(this.endDate);
        event.setType(this.type);
        event.setColor(this.color);
        event.setIsRecurring(this.isRecurring);
        event.setRecurringType(this.recurringType);
        event.setCreatedBy(this.createdBy);
        event.setUpdatedBy(this.updatedBy);
        return event;
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
    
    public LocalDate getStartDate() {
        return startDate;
    }
    
    public void setStartDate(LocalDate startDate) {
        this.startDate = startDate;
    }
    
    public LocalDate getEndDate() {
        return endDate;
    }
    
    public void setEndDate(LocalDate endDate) {
        this.endDate = endDate;
    }
    
    public CalendarEvent.EventType getType() {
        return type;
    }
    
    public void setType(CalendarEvent.EventType type) {
        this.type = type;
    }
    
    public String getColor() {
        return color;
    }
    
    public void setColor(String color) {
        this.color = color;
    }
    
    public Boolean getIsRecurring() {
        return isRecurring;
    }
    
    public void setIsRecurring(Boolean isRecurring) {
        this.isRecurring = isRecurring;
    }
    
    public CalendarEvent.RecurringType getRecurringType() {
        return recurringType;
    }
    
    public void setRecurringType(CalendarEvent.RecurringType recurringType) {
        this.recurringType = recurringType;
    }
    
    public Long getCreatedBy() {
        return createdBy;
    }
    
    public void setCreatedBy(Long createdBy) {
        this.createdBy = createdBy;
    }
    
    public Long getUpdatedBy() {
        return updatedBy;
    }
    
    public void setUpdatedBy(Long updatedBy) {
        this.updatedBy = updatedBy;
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
} 