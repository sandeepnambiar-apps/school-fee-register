package com.school.notificationservice.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "notification_deliveries")
public class NotificationDelivery {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "notification_id")
    private Long notificationId;
    
    @Column(name = "recipient_id")
    private Long recipientId; // Student ID or User ID
    
    @Column(name = "recipient_type")
    @Enumerated(EnumType.STRING)
    private RecipientType recipientType;
    
    @Column(name = "delivery_method")
    @Enumerated(EnumType.STRING)
    private DeliveryMethod deliveryMethod;
    
    @Column(name = "delivery_status")
    @Enumerated(EnumType.STRING)
    private DeliveryStatus status = DeliveryStatus.PENDING;
    
    @Column(name = "sent_at")
    private LocalDateTime sentAt;
    
    @Column(name = "delivered_at")
    private LocalDateTime deliveredAt;
    
    @Column(name = "read_at")
    private LocalDateTime readAt;
    
    @Column(name = "error_message")
    private String errorMessage;
    
    @Column(name = "retry_count")
    private Integer retryCount = 0;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    public enum RecipientType {
        STUDENT, PARENT, STAFF, ADMIN
    }
    
    public enum DeliveryMethod {
        IN_APP, EMAIL, SMS, PUSH_NOTIFICATION, WHATSAPP
    }
    
    public enum DeliveryStatus {
        PENDING, SENT, DELIVERED, READ, FAILED, CANCELLED
    }
    
    // Constructors
    public NotificationDelivery() {}
    
    public NotificationDelivery(Long notificationId, Long recipientId, RecipientType recipientType, DeliveryMethod deliveryMethod) {
        this.notificationId = notificationId;
        this.recipientId = recipientId;
        this.recipientType = recipientType;
        this.deliveryMethod = deliveryMethod;
        this.createdAt = LocalDateTime.now();
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public Long getNotificationId() {
        return notificationId;
    }
    
    public void setNotificationId(Long notificationId) {
        this.notificationId = notificationId;
    }
    
    public Long getRecipientId() {
        return recipientId;
    }
    
    public void setRecipientId(Long recipientId) {
        this.recipientId = recipientId;
    }
    
    public RecipientType getRecipientType() {
        return recipientType;
    }
    
    public void setRecipientType(RecipientType recipientType) {
        this.recipientType = recipientType;
    }
    
    public DeliveryMethod getDeliveryMethod() {
        return deliveryMethod;
    }
    
    public void setDeliveryMethod(DeliveryMethod deliveryMethod) {
        this.deliveryMethod = deliveryMethod;
    }
    
    public DeliveryStatus getStatus() {
        return status;
    }
    
    public void setStatus(DeliveryStatus status) {
        this.status = status;
    }
    
    public LocalDateTime getSentAt() {
        return sentAt;
    }
    
    public void setSentAt(LocalDateTime sentAt) {
        this.sentAt = sentAt;
    }
    
    public LocalDateTime getDeliveredAt() {
        return deliveredAt;
    }
    
    public void setDeliveredAt(LocalDateTime deliveredAt) {
        this.deliveredAt = deliveredAt;
    }
    
    public LocalDateTime getReadAt() {
        return readAt;
    }
    
    public void setReadAt(LocalDateTime readAt) {
        this.readAt = readAt;
    }
    
    public String getErrorMessage() {
        return errorMessage;
    }
    
    public void setErrorMessage(String errorMessage) {
        this.errorMessage = errorMessage;
    }
    
    public Integer getRetryCount() {
        return retryCount;
    }
    
    public void setRetryCount(Integer retryCount) {
        this.retryCount = retryCount;
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