package com.school.notificationservice.repository;

import com.school.notificationservice.model.Notification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface NotificationRepository extends JpaRepository<Notification, Long> {
    
    // Find notifications by type
    List<Notification> findByType(Notification.NotificationType type);
    
    // Find notifications by status
    List<Notification> findByStatus(Notification.Status status);
    
    // Find notifications by target audience
    List<Notification> findByTargetAudience(Notification.TargetAudience targetAudience);
    
    // Find notifications by class
    List<Notification> findByClassId(Long classId);
    
    // Find notifications by academic year
    List<Notification> findByAcademicYearId(Long academicYearId);
    
    // Find notifications by priority
    List<Notification> findByPriority(Notification.Priority priority);
    
    // Find notifications by creator
    List<Notification> findByCreatedBy(String createdBy);
    
    // Find scheduled notifications that need to be sent
    @Query("SELECT n FROM Notification n WHERE n.status = 'SCHEDULED' AND n.scheduledAt <= :now")
    List<Notification> findScheduledNotificationsToSend(@Param("now") LocalDateTime now);
    
    // Find notifications by type and status
    List<Notification> findByTypeAndStatus(Notification.NotificationType type, Notification.Status status);
    
    // Find notifications by target audience and status
    List<Notification> findByTargetAudienceAndStatus(Notification.TargetAudience targetAudience, Notification.Status status);
    
    // Find notifications created within a date range
    @Query("SELECT n FROM Notification n WHERE n.createdAt BETWEEN :startDate AND :endDate")
    List<Notification> findByCreatedAtBetween(@Param("startDate") LocalDateTime startDate, 
                                            @Param("endDate") LocalDateTime endDate);
    
    // Find notifications by multiple types
    @Query("SELECT n FROM Notification n WHERE n.type IN :types")
    List<Notification> findByTypeIn(@Param("types") List<Notification.NotificationType> types);
    
    // Find urgent notifications
    @Query("SELECT n FROM Notification n WHERE n.priority = 'URGENT' AND n.status IN ('DRAFT', 'SCHEDULED')")
    List<Notification> findUrgentNotifications();
    
    // Find notifications for specific class and type
    List<Notification> findByClassIdAndType(Long classId, Notification.NotificationType type);
    
    // Find recent notifications (last 30 days)
    @Query("SELECT n FROM Notification n WHERE n.createdAt >= :thirtyDaysAgo ORDER BY n.createdAt DESC")
    List<Notification> findRecentNotifications(@Param("thirtyDaysAgo") LocalDateTime thirtyDaysAgo);
    
    // Count notifications by status
    @Query("SELECT COUNT(n) FROM Notification n WHERE n.status = :status")
    Long countByStatus(@Param("status") Notification.Status status);
    
    // Count notifications by type
    @Query("SELECT COUNT(n) FROM Notification n WHERE n.type = :type")
    Long countByType(@Param("type") Notification.NotificationType type);
} 