package com.school.notificationservice.repository;

import com.school.notificationservice.model.NotificationDelivery;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface NotificationDeliveryRepository extends JpaRepository<NotificationDelivery, Long> {
    
    // Find deliveries by notification ID
    List<NotificationDelivery> findByNotificationId(Long notificationId);
    
    // Find deliveries by recipient ID
    List<NotificationDelivery> findByRecipientId(Long recipientId);
    
    // Find deliveries by recipient type
    List<NotificationDelivery> findByRecipientType(NotificationDelivery.RecipientType recipientType);
    
    // Find deliveries by delivery method
    List<NotificationDelivery> findByDeliveryMethod(NotificationDelivery.DeliveryMethod deliveryMethod);
    
    // Find deliveries by status
    List<NotificationDelivery> findByStatus(NotificationDelivery.DeliveryStatus status);
    
    // Find deliveries by notification ID and status
    List<NotificationDelivery> findByNotificationIdAndStatus(Long notificationId, NotificationDelivery.DeliveryStatus status);
    
    // Find deliveries by recipient ID and status
    List<NotificationDelivery> findByRecipientIdAndStatus(Long recipientId, NotificationDelivery.DeliveryStatus status);
    
    // Find unread deliveries for a recipient
    @Query("SELECT nd FROM NotificationDelivery nd WHERE nd.recipientId = :recipientId AND nd.status = 'DELIVERED' AND nd.readAt IS NULL")
    List<NotificationDelivery> findUnreadDeliveriesByRecipient(@Param("recipientId") Long recipientId);
    
    // Find deliveries created within a date range
    @Query("SELECT nd FROM NotificationDelivery nd WHERE nd.createdAt BETWEEN :startDate AND :endDate")
    List<NotificationDelivery> findByCreatedAtBetween(@Param("startDate") LocalDateTime startDate, 
                                                     @Param("endDate") LocalDateTime endDate);
    
    // Find deliveries that need retry (failed with retry count < max)
    @Query("SELECT nd FROM NotificationDelivery nd WHERE nd.status = 'FAILED' AND nd.retryCount < 3")
    List<NotificationDelivery> findDeliveriesNeedingRetry();
    
    // Count deliveries by status for a notification
    @Query("SELECT COUNT(nd) FROM NotificationDelivery nd WHERE nd.notificationId = :notificationId AND nd.status = :status")
    Long countByNotificationIdAndStatus(@Param("notificationId") Long notificationId, 
                                       @Param("status") NotificationDelivery.DeliveryStatus status);
    
    // Count successful deliveries for a notification
    @Query("SELECT COUNT(nd) FROM NotificationDelivery nd WHERE nd.notificationId = :notificationId AND nd.status IN ('DELIVERED', 'READ')")
    Long countSuccessfulDeliveriesByNotificationId(@Param("notificationId") Long notificationId);
    
    // Find recent deliveries for a recipient
    @Query("SELECT nd FROM NotificationDelivery nd WHERE nd.recipientId = :recipientId ORDER BY nd.createdAt DESC")
    List<NotificationDelivery> findRecentDeliveriesByRecipient(@Param("recipientId") Long recipientId);
    
    // Find deliveries by multiple recipient IDs
    @Query("SELECT nd FROM NotificationDelivery nd WHERE nd.recipientId IN :recipientIds")
    List<NotificationDelivery> findByRecipientIdIn(@Param("recipientIds") List<Long> recipientIds);
    
    // Find deliveries by notification ID and delivery method
    List<NotificationDelivery> findByNotificationIdAndDeliveryMethod(Long notificationId, 
                                                                    NotificationDelivery.DeliveryMethod deliveryMethod);
    
    // Find pending deliveries that need to be sent
    @Query("SELECT nd FROM NotificationDelivery nd WHERE nd.status = 'PENDING' AND nd.createdAt <= :cutoffTime")
    List<NotificationDelivery> findPendingDeliveriesToSend(@Param("cutoffTime") LocalDateTime cutoffTime);
    
    // Find read deliveries for a recipient
    @Query("SELECT nd FROM NotificationDelivery nd WHERE nd.recipientId = :recipientId AND nd.readAt IS NOT NULL ORDER BY nd.readAt DESC")
    List<NotificationDelivery> findReadDeliveriesByRecipient(@Param("recipientId") Long recipientId);
    
    // Count deliveries by notification ID
    Long countByNotificationId(Long notificationId);
} 