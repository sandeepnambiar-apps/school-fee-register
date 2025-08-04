package com.school.studentservice.dto;

import com.school.studentservice.model.TicketResponse;
import java.time.LocalDateTime;

public class TicketResponseDTO {
    private Long id;
    private Long ticketId;
    private String message;
    private String respondedBy;
    private String respondedByRole;
    private LocalDateTime createdAt;
    
    // Constructors
    public TicketResponseDTO() {}
    
    public TicketResponseDTO(TicketResponse response) {
        this.id = response.getId();
        this.ticketId = response.getTicketId();
        this.message = response.getMessage();
        this.respondedBy = response.getRespondedBy();
        this.respondedByRole = response.getRespondedByRole();
        this.createdAt = response.getCreatedAt();
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public Long getTicketId() {
        return ticketId;
    }
    
    public void setTicketId(Long ticketId) {
        this.ticketId = ticketId;
    }
    
    public String getMessage() {
        return message;
    }
    
    public void setMessage(String message) {
        this.message = message;
    }
    
    public String getRespondedBy() {
        return respondedBy;
    }
    
    public void setRespondedBy(String respondedBy) {
        this.respondedBy = respondedBy;
    }
    
    public String getRespondedByRole() {
        return respondedByRole;
    }
    
    public void setRespondedByRole(String respondedByRole) {
        this.respondedByRole = respondedByRole;
    }
    
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
} 