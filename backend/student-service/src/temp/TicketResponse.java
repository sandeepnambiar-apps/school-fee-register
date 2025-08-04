package com.school.studentservice.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "ticket_responses")
public class TicketResponse {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "ticket_id", nullable = false)
    private Long ticketId;
    
    @Column(name = "message", nullable = false, columnDefinition = "TEXT")
    private String message;
    
    @Column(name = "responded_by", nullable = false, length = 100)
    private String respondedBy;
    
    @Column(name = "responded_by_role", nullable = false, length = 50)
    private String respondedByRole;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    // Constructors
    public TicketResponse() {}
    
    public TicketResponse(Long ticketId, String message, String respondedBy, String respondedByRole) {
        this.ticketId = ticketId;
        this.message = message;
        this.respondedBy = respondedBy;
        this.respondedByRole = respondedByRole;
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
    
    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }
} 