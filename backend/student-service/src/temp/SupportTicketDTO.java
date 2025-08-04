package com.school.studentservice.dto;

import com.school.studentservice.model.SupportTicket;
import java.time.LocalDateTime;
import java.util.List;

public class SupportTicketDTO {
    private Long id;
    private String title;
    private String description;
    private String category;
    private SupportTicket.Priority priority;
    private SupportTicket.Status status;
    private String createdBy;
    private String createdByPhone;
    private String assignedTo;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private List<TicketResponseDTO> responses;
    
    // Constructors
    public SupportTicketDTO() {}
    
    public SupportTicketDTO(SupportTicket ticket) {
        this.id = ticket.getId();
        this.title = ticket.getTitle();
        this.description = ticket.getDescription();
        this.category = ticket.getCategory();
        this.priority = ticket.getPriority();
        this.status = ticket.getStatus();
        this.createdBy = ticket.getCreatedBy();
        this.createdByPhone = ticket.getCreatedByPhone();
        this.assignedTo = ticket.getAssignedTo();
        this.createdAt = ticket.getCreatedAt();
        this.updatedAt = ticket.getUpdatedAt();
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
    
    public String getCategory() {
        return category;
    }
    
    public void setCategory(String category) {
        this.category = category;
    }
    
    public SupportTicket.Priority getPriority() {
        return priority;
    }
    
    public void setPriority(SupportTicket.Priority priority) {
        this.priority = priority;
    }
    
    public SupportTicket.Status getStatus() {
        return status;
    }
    
    public void setStatus(SupportTicket.Status status) {
        this.status = status;
    }
    
    public String getCreatedBy() {
        return createdBy;
    }
    
    public void setCreatedBy(String createdBy) {
        this.createdBy = createdBy;
    }
    
    public String getCreatedByPhone() {
        return createdByPhone;
    }
    
    public void setCreatedByPhone(String createdByPhone) {
        this.createdByPhone = createdByPhone;
    }
    
    public String getAssignedTo() {
        return assignedTo;
    }
    
    public void setAssignedTo(String assignedTo) {
        this.assignedTo = assignedTo;
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
    
    public List<TicketResponseDTO> getResponses() {
        return responses;
    }
    
    public void setResponses(List<TicketResponseDTO> responses) {
        this.responses = responses;
    }
} 