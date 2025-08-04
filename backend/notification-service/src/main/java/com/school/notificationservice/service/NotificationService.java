package com.school.notificationservice.service;

import com.school.notificationservice.dto.NotificationDTO;
import com.school.notificationservice.model.Notification;
import com.school.notificationservice.model.NotificationDelivery;
import com.school.notificationservice.repository.NotificationDeliveryRepository;
import com.school.notificationservice.repository.NotificationRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.time.LocalDateTime;
import java.util.*;
import java.util.concurrent.CompletableFuture;
import java.util.stream.Collectors;

@Service
public class NotificationService {
    
    private static final Logger logger = LoggerFactory.getLogger(NotificationService.class);
    
    @Autowired
    private NotificationRepository notificationRepository;
    
    @Autowired
    private NotificationDeliveryRepository deliveryRepository;
    
    @Autowired
    private RestTemplate restTemplate;
    
    @Autowired
    private SMSService smsService;
    
    @Autowired
    private WhatsAppService whatsappService;
    
    // Student service URL (would be configured via properties)
    private static final String STUDENT_SERVICE_URL = "http://student-service/api/students";
    
    /**
     * Create and send notification to all parents with SMS support
     */
    public NotificationDTO sendNotificationToAllParents(NotificationDTO notificationDTO) {
        logger.info("Creating notification to send to all parents: {}", notificationDTO.getTitle());
        
        // Set target audience to ALL_PARENTS
        notificationDTO.setTargetAudience(Notification.TargetAudience.ALL_PARENTS);
        
        // Create notification
        Notification notification = notificationDTO.toEntity();
        notification.setStatus(Notification.Status.SCHEDULED);
        notification.setCreatedAt(LocalDateTime.now());
        notification.setUpdatedAt(LocalDateTime.now());
        
        // Save notification
        notification = notificationRepository.save(notification);
        
        // Create a final copy for the lambda
        final Notification finalNotification = notification;
        
        // Send notification immediately
        CompletableFuture.runAsync(() -> {
            try {
                sendNotificationToAllParentsAsync(finalNotification, notificationDTO.getDeliveryMethods());
            } catch (Exception e) {
                logger.error("Error sending notification to all parents: {}", e.getMessage(), e);
                finalNotification.setStatus(Notification.Status.FAILED);
                notificationRepository.save(finalNotification);
            }
        });
        
        return new NotificationDTO(notification);
    }
    
    /**
     * Send holiday notification to all parents with SMS
     */
    public NotificationDTO sendHolidayNotification(String title, String message, LocalDateTime holidayDate, 
                                                  List<String> deliveryMethods) {
        logger.info("Sending holiday notification: {}", title);
        
        NotificationDTO notificationDTO = new NotificationDTO();
        notificationDTO.setTitle(title);
        notificationDTO.setMessage(message);
        notificationDTO.setType(Notification.NotificationType.HOLIDAY);
        notificationDTO.setPriority(Notification.Priority.HIGH);
        notificationDTO.setTargetAudience(Notification.TargetAudience.ALL_PARENTS);
        notificationDTO.setScheduledAt(holidayDate);
        notificationDTO.setDeliveryMethods(deliveryMethods);
        
        return sendNotificationToAllParents(notificationDTO);
    }
    
    /**
     * Send circular notification to all parents with SMS
     */
    public NotificationDTO sendCircularNotification(String title, String message, List<String> deliveryMethods) {
        logger.info("Sending circular notification: {}", title);
        
        NotificationDTO notificationDTO = new NotificationDTO();
        notificationDTO.setTitle(title);
        notificationDTO.setMessage(message);
        notificationDTO.setType(Notification.NotificationType.CIRCULAR);
        notificationDTO.setPriority(Notification.Priority.NORMAL);
        notificationDTO.setTargetAudience(Notification.TargetAudience.ALL_PARENTS);
        notificationDTO.setDeliveryMethods(deliveryMethods);
        
        return sendNotificationToAllParents(notificationDTO);
    }
    
    /**
     * Send emergency notification to all parents with SMS
     */
    public NotificationDTO sendEmergencyNotification(String title, String message, List<String> deliveryMethods) {
        logger.info("Sending emergency notification: {}", title);
        
        NotificationDTO notificationDTO = new NotificationDTO();
        notificationDTO.setTitle(title);
        notificationDTO.setMessage(message);
        notificationDTO.setType(Notification.NotificationType.EMERGENCY);
        notificationDTO.setPriority(Notification.Priority.URGENT);
        notificationDTO.setTargetAudience(Notification.TargetAudience.ALL_PARENTS);
        notificationDTO.setDeliveryMethods(deliveryMethods);
        
        return sendNotificationToAllParents(notificationDTO);
    }
    
    /**
     * Send notification to specific class parents with SMS
     */
    public NotificationDTO sendNotificationToClass(Long classId, NotificationDTO notificationDTO) {
        logger.info("Sending notification to class {}: {}", classId, notificationDTO.getTitle());
        
        notificationDTO.setTargetAudience(Notification.TargetAudience.SPECIFIC_CLASS);
        notificationDTO.setClassId(classId);
        
        Notification notification = notificationDTO.toEntity();
        notification.setStatus(Notification.Status.SCHEDULED);
        notification.setCreatedAt(LocalDateTime.now());
        notification.setUpdatedAt(LocalDateTime.now());
        
        notification = notificationRepository.save(notification);
        
        // Create a final copy for the lambda
        final Notification finalNotification = notification;
        
        CompletableFuture.runAsync(() -> {
            try {
                sendNotificationToClassAsync(finalNotification, classId, notificationDTO.getDeliveryMethods());
            } catch (Exception e) {
                logger.error("Error sending notification to class {}: {}", classId, e.getMessage(), e);
                finalNotification.setStatus(Notification.Status.FAILED);
                notificationRepository.save(finalNotification);
            }
        });
        
        return new NotificationDTO(notification);
    }
    
    /**
     * Send notification to specific class and section parents with SMS
     */
    public NotificationDTO sendNotificationToClassSection(Long classId, String section, NotificationDTO notificationDTO) {
        logger.info("Sending notification to class {} section {}: {}", classId, section, notificationDTO.getTitle());
        notificationDTO.setTargetAudience(Notification.TargetAudience.SPECIFIC_CLASS);
        notificationDTO.setClassId(classId);
        notificationDTO.setSection(section);
        Notification notification = notificationDTO.toEntity();
        notification.setStatus(Notification.Status.SCHEDULED);
        notification.setCreatedAt(LocalDateTime.now());
        notification.setUpdatedAt(LocalDateTime.now());
        notification = notificationRepository.save(notification);
        
        // Create a final copy for the lambda
        final Notification finalNotification = notification;
        
        CompletableFuture.runAsync(() -> {
            try {
                sendNotificationToClassSectionAsync(finalNotification, classId, section, notificationDTO.getDeliveryMethods());
            } catch (Exception e) {
                logger.error("Error sending notification to class {} section {}: {}", classId, section, e.getMessage(), e);
                finalNotification.setStatus(Notification.Status.FAILED);
                notificationRepository.save(finalNotification);
            }
        });
        return new NotificationDTO(notification);
    }
    
    /**
     * Schedule notification for future delivery
     */
    public NotificationDTO scheduleNotification(NotificationDTO notificationDTO) {
        logger.info("Scheduling notification: {}", notificationDTO.getTitle());
        
        Notification notification = notificationDTO.toEntity();
        notification.setStatus(Notification.Status.SCHEDULED);
        notification.setCreatedAt(LocalDateTime.now());
        notification.setUpdatedAt(LocalDateTime.now());
        
        notification = notificationRepository.save(notification);
        return new NotificationDTO(notification);
    }
    
    /**
     * Get notifications by type
     */
    public List<NotificationDTO> getNotificationsByType(Notification.NotificationType type) {
        List<Notification> notifications = notificationRepository.findByType(type);
        return notifications.stream()
                .map(NotificationDTO::new)
                .collect(Collectors.toList());
    }
    
    /**
     * Get notifications by status
     */
    public List<NotificationDTO> getNotificationsByStatus(Notification.Status status) {
        List<Notification> notifications = notificationRepository.findByStatus(status);
        return notifications.stream()
                .map(NotificationDTO::new)
                .collect(Collectors.toList());
    }
    
    /**
     * Get notification by ID
     */
    public NotificationDTO getNotificationById(Long id) {
        Notification notification = notificationRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Notification not found with id: " + id));
        return new NotificationDTO(notification);
    }
    
    /**
     * Get delivery statistics for a notification
     */
    public Map<String, Object> getDeliveryStatistics(Long notificationId) {
        Map<String, Object> stats = new HashMap<>();
        
        long totalDeliveries = deliveryRepository.countByNotificationId(notificationId);
        long successfulDeliveries = deliveryRepository.countSuccessfulDeliveriesByNotificationId(notificationId);
        long failedDeliveries = deliveryRepository.countByNotificationIdAndStatus(notificationId, NotificationDelivery.DeliveryStatus.FAILED);
        long pendingDeliveries = deliveryRepository.countByNotificationIdAndStatus(notificationId, NotificationDelivery.DeliveryStatus.PENDING);
        
        stats.put("totalDeliveries", totalDeliveries);
        stats.put("successfulDeliveries", successfulDeliveries);
        stats.put("failedDeliveries", failedDeliveries);
        stats.put("pendingDeliveries", pendingDeliveries);
        stats.put("successRate", totalDeliveries > 0 ? (double) successfulDeliveries / totalDeliveries * 100 : 0);
        
        return stats;
    }
    
    /**
     * Mark notification as read by recipient
     */
    public void markAsRead(Long notificationId, Long recipientId) {
        List<NotificationDelivery> deliveries = deliveryRepository.findByNotificationIdAndStatus(
                notificationId, NotificationDelivery.DeliveryStatus.DELIVERED);
        
        deliveries.stream()
                .filter(delivery -> delivery.getRecipientId().equals(recipientId))
                .forEach(delivery -> {
                    delivery.setStatus(NotificationDelivery.DeliveryStatus.READ);
                    delivery.setReadAt(LocalDateTime.now());
                    deliveryRepository.save(delivery);
                });
    }
    
    /**
     * Get unread notifications for a recipient
     */
    public List<NotificationDelivery> getUnreadNotifications(Long recipientId) {
        return deliveryRepository.findUnreadDeliveriesByRecipient(recipientId);
    }
    
    /**
     * Retry failed deliveries
     */
    @Scheduled(fixedRate = 300000) // Every 5 minutes
    public void retryFailedDeliveries() {
        logger.info("Retrying failed deliveries...");
        
        List<NotificationDelivery> failedDeliveries = deliveryRepository.findDeliveriesNeedingRetry();
        
        for (NotificationDelivery delivery : failedDeliveries) {
            try {
                retryDelivery(delivery);
            } catch (Exception e) {
                logger.error("Error retrying delivery {}: {}", delivery.getId(), e.getMessage());
                delivery.setRetryCount(delivery.getRetryCount() + 1);
                deliveryRepository.save(delivery);
            }
        }
    }
    
    /**
     * Process scheduled notifications
     */
    @Scheduled(fixedRate = 60000) // Every minute
    public void processScheduledNotifications() {
        logger.info("Processing scheduled notifications...");
        
        List<Notification> scheduledNotifications = notificationRepository.findScheduledNotificationsToSend(LocalDateTime.now());
        
        for (Notification notification : scheduledNotifications) {
            try {
                processNotification(notification);
            } catch (Exception e) {
                logger.error("Error processing scheduled notification {}: {}", notification.getId(), e.getMessage());
                notification.setStatus(Notification.Status.FAILED);
                notificationRepository.save(notification);
            }
        }
    }
    
    // Private helper methods
    
    private void sendNotificationToAllParentsAsync(Notification notification, List<String> deliveryMethods) {
        logger.info("Sending notification to all parents: {}", notification.getTitle());
        
        List<Map<String, Object>> students = getAllStudents();
        List<NotificationDelivery> deliveries = new ArrayList<>();
        Map<String, String> smsRecipients = new HashMap<>();
        Map<String, String> whatsappRecipients = new HashMap<>();
        
        for (Map<String, Object> student : students) {
            Long studentId = Long.valueOf(student.get("id").toString());
            String parentPhone = (String) student.get("parentPhone");
            String studentName = (String) student.get("name");
            
            if (deliveryMethods != null) {
                for (String method : deliveryMethods) {
                    NotificationDelivery.DeliveryMethod deliveryMethod = 
                            NotificationDelivery.DeliveryMethod.valueOf(method.toUpperCase());
                    NotificationDelivery delivery = new NotificationDelivery(
                            notification.getId(), 
                            studentId, 
                            NotificationDelivery.RecipientType.STUDENT, 
                            deliveryMethod
                    );
                    deliveries.add(delivery);
                    // SMS logic
                    if (deliveryMethod == NotificationDelivery.DeliveryMethod.SMS && parentPhone != null) {
                        String formattedPhone = smsService.formatPhoneNumber(parentPhone);
                        if (smsService.isValidPhoneNumber(formattedPhone)) {
                            String smsMessage = createSMSMessage(notification, studentName);
                            smsRecipients.put(formattedPhone, smsMessage);
                        }
                    }
                    // WhatsApp logic
                    if (deliveryMethod == NotificationDelivery.DeliveryMethod.WHATSAPP && parentPhone != null) {
                        String formattedPhone = whatsappService.formatPhoneForWhatsApp(parentPhone);
                        if (whatsappService.isValidWhatsAppNumber(formattedPhone)) {
                            String waMessage = createWhatsAppMessage(notification, studentName);
                            whatsappRecipients.put(formattedPhone, waMessage);
                        }
                    }
                }
            } else {
                NotificationDelivery delivery = new NotificationDelivery(
                        notification.getId(), 
                        studentId, 
                        NotificationDelivery.RecipientType.STUDENT, 
                        NotificationDelivery.DeliveryMethod.IN_APP
                );
                deliveries.add(delivery);
            }
        }
        deliveryRepository.saveAll(deliveries);
        // Send SMS if requested
        if (!smsRecipients.isEmpty()) {
            try {
                Map<String, Boolean> smsResults = smsService.sendBulkSMS(smsRecipients);
                updateSMSDeliveryStatus(notification.getId(), smsResults);
            } catch (Exception e) {
                logger.error("Error sending SMS notifications: {}", e.getMessage(), e);
            }
        }
        // Send WhatsApp if requested
        if (!whatsappRecipients.isEmpty()) {
            try {
                Map<String, Boolean> waResults = whatsappService.sendBulkWhatsApp(whatsappRecipients);
                updateWhatsAppDeliveryStatus(notification.getId(), waResults);
            } catch (Exception e) {
                logger.error("Error sending WhatsApp notifications: {}", e.getMessage(), e);
            }
        }
        notification.setStatus(Notification.Status.SENT);
        notification.setSentAt(LocalDateTime.now());
        notificationRepository.save(notification);
        logger.info("Notification sent to {} parents via {} methods", students.size(), 
                   deliveryMethods != null ? deliveryMethods.size() : 1);
    }
    
    private void sendNotificationToClassAsync(Notification notification, Long classId, List<String> deliveryMethods) {
        logger.info("Sending notification to class {}: {}", classId, notification.getTitle());
        
        // Get students from specific class
        List<Map<String, Object>> students = getStudentsByClass(classId);
        
        // Create delivery records
        List<NotificationDelivery> deliveries = new ArrayList<>();
        Map<String, String> smsRecipients = new HashMap<>();
        Map<String, String> whatsappRecipients = new HashMap<>();
        
        for (Map<String, Object> student : students) {
            Long studentId = Long.valueOf(student.get("id").toString());
            String parentPhone = (String) student.get("parentPhone");
            String studentName = (String) student.get("name");
            
            if (deliveryMethods != null) {
                for (String method : deliveryMethods) {
                    NotificationDelivery.DeliveryMethod deliveryMethod = 
                            NotificationDelivery.DeliveryMethod.valueOf(method.toUpperCase());
                    
                    NotificationDelivery delivery = new NotificationDelivery(
                            notification.getId(), 
                            studentId, 
                            NotificationDelivery.RecipientType.STUDENT, 
                            deliveryMethod
                    );
                    deliveries.add(delivery);
                    
                    if (deliveryMethod == NotificationDelivery.DeliveryMethod.SMS && parentPhone != null) {
                        String formattedPhone = smsService.formatPhoneNumber(parentPhone);
                        if (smsService.isValidPhoneNumber(formattedPhone)) {
                            String smsMessage = createSMSMessage(notification, studentName);
                            smsRecipients.put(formattedPhone, smsMessage);
                        }
                    }
                    if (deliveryMethod == NotificationDelivery.DeliveryMethod.WHATSAPP && parentPhone != null) {
                        String formattedPhone = whatsappService.formatPhoneForWhatsApp(parentPhone);
                        if (whatsappService.isValidWhatsAppNumber(formattedPhone)) {
                            String waMessage = createWhatsAppMessage(notification, studentName);
                            whatsappRecipients.put(formattedPhone, waMessage);
                        }
                    }
                }
            } else {
                NotificationDelivery delivery = new NotificationDelivery(
                        notification.getId(), 
                        studentId, 
                        NotificationDelivery.RecipientType.STUDENT, 
                        NotificationDelivery.DeliveryMethod.IN_APP
                );
                deliveries.add(delivery);
            }
        }
        
        deliveryRepository.saveAll(deliveries);
        
        // Send SMS if requested
        if (!smsRecipients.isEmpty()) {
            try {
                Map<String, Boolean> smsResults = smsService.sendBulkSMS(smsRecipients);
                updateSMSDeliveryStatus(notification.getId(), smsResults);
            } catch (Exception e) {
                logger.error("Error sending SMS notifications to class {}: {}", classId, e.getMessage(), e);
            }
        }
        
        // Send WhatsApp if requested
        if (!whatsappRecipients.isEmpty()) {
            try {
                Map<String, Boolean> waResults = whatsappService.sendBulkWhatsApp(whatsappRecipients);
                updateWhatsAppDeliveryStatus(notification.getId(), waResults);
            } catch (Exception e) {
                logger.error("Error sending WhatsApp notifications to class {}: {}", classId, e.getMessage(), e);
            }
        }
        
        notification.setStatus(Notification.Status.SENT);
        notification.setSentAt(LocalDateTime.now());
        notificationRepository.save(notification);
        
        logger.info("Notification sent to {} students in class {} via {} methods", students.size(), classId,
                   deliveryMethods != null ? deliveryMethods.size() : 1);
    }
    
    private void sendNotificationToClassSectionAsync(Notification notification, Long classId, String section, List<String> deliveryMethods) {
        logger.info("Sending notification to class {} section {}: {}", classId, section, notification.getTitle());
        List<Map<String, Object>> students = getStudentsByClassSection(classId, section);
        List<NotificationDelivery> deliveries = new ArrayList<>();
        Map<String, String> smsRecipients = new HashMap<>();
        Map<String, String> whatsappRecipients = new HashMap<>();
        for (Map<String, Object> student : students) {
            Long studentId = Long.valueOf(student.get("id").toString());
            String parentPhone = (String) student.get("parentPhone");
            String studentName = (String) student.get("name");
            if (deliveryMethods != null) {
                for (String method : deliveryMethods) {
                    NotificationDelivery.DeliveryMethod deliveryMethod = NotificationDelivery.DeliveryMethod.valueOf(method.toUpperCase());
                    NotificationDelivery delivery = new NotificationDelivery(
                        notification.getId(),
                        studentId,
                        NotificationDelivery.RecipientType.STUDENT,
                        deliveryMethod
                    );
                    deliveries.add(delivery);
                    if (deliveryMethod == NotificationDelivery.DeliveryMethod.SMS && parentPhone != null) {
                        String formattedPhone = smsService.formatPhoneNumber(parentPhone);
                        if (smsService.isValidPhoneNumber(formattedPhone)) {
                            String smsMessage = createSMSMessage(notification, studentName);
                            smsRecipients.put(formattedPhone, smsMessage);
                        }
                    }
                    if (deliveryMethod == NotificationDelivery.DeliveryMethod.WHATSAPP && parentPhone != null) {
                        String formattedPhone = whatsappService.formatPhoneForWhatsApp(parentPhone);
                        if (whatsappService.isValidWhatsAppNumber(formattedPhone)) {
                            String waMessage = createWhatsAppMessage(notification, studentName);
                            whatsappRecipients.put(formattedPhone, waMessage);
                        }
                    }
                }
            } else {
                NotificationDelivery delivery = new NotificationDelivery(
                    notification.getId(),
                    studentId,
                    NotificationDelivery.RecipientType.STUDENT,
                    NotificationDelivery.DeliveryMethod.IN_APP
                );
                deliveries.add(delivery);
            }
        }
        deliveryRepository.saveAll(deliveries);
        if (!smsRecipients.isEmpty()) {
            try {
                Map<String, Boolean> smsResults = smsService.sendBulkSMS(smsRecipients);
                updateSMSDeliveryStatus(notification.getId(), smsResults);
            } catch (Exception e) {
                logger.error("Error sending SMS notifications to class {} section {}: {}", classId, section, e.getMessage(), e);
            }
        }
        if (!whatsappRecipients.isEmpty()) {
            try {
                Map<String, Boolean> waResults = whatsappService.sendBulkWhatsApp(whatsappRecipients);
                updateWhatsAppDeliveryStatus(notification.getId(), waResults);
            } catch (Exception e) {
                logger.error("Error sending WhatsApp notifications to class {} section {}: {}", classId, section, e.getMessage(), e);
            }
        }
        notification.setStatus(Notification.Status.SENT);
        notification.setSentAt(LocalDateTime.now());
        notificationRepository.save(notification);
        logger.info("Notification sent to {} students in class {} section {} via {} methods", students.size(), classId, section, deliveryMethods != null ? deliveryMethods.size() : 1);
    }
    
    private void processNotification(Notification notification) {
        switch (notification.getTargetAudience()) {
            case ALL_PARENTS:
                sendNotificationToAllParentsAsync(notification, Arrays.asList("IN_APP"));
                break;
            case SPECIFIC_CLASS:
                sendNotificationToClassAsync(notification, notification.getClassId(), Arrays.asList("IN_APP"));
                break;
            default:
                logger.warn("Unsupported target audience: {}", notification.getTargetAudience());
        }
    }
    
    private void retryDelivery(NotificationDelivery delivery) {
        // Implement retry logic based on delivery method
        switch (delivery.getDeliveryMethod()) {
            case IN_APP:
                // For in-app, just mark as delivered
                delivery.setStatus(NotificationDelivery.DeliveryStatus.DELIVERED);
                delivery.setDeliveredAt(LocalDateTime.now());
                break;
            case SMS:
                // Retry SMS delivery
                try {
                    // Get student info to get phone number
                    List<Map<String, Object>> students = getAllStudents();
                    String parentPhone = students.stream()
                            .filter(s -> s.get("id").toString().equals(delivery.getRecipientId().toString()))
                            .findFirst()
                            .map(s -> (String) s.get("parentPhone"))
                            .orElse(null);
                    
                    if (parentPhone != null) {
                        String formattedPhone = smsService.formatPhoneNumber(parentPhone);
                        boolean success = smsService.sendSMS(formattedPhone, "Retry: " + getNotificationMessage(delivery.getNotificationId()));
                        
                        if (success) {
                            delivery.setStatus(NotificationDelivery.DeliveryStatus.DELIVERED);
                            delivery.setDeliveredAt(LocalDateTime.now());
                        }
                    }
                } catch (Exception e) {
                    logger.error("Error retrying SMS delivery: {}", e.getMessage());
                }
                break;
            case EMAIL:
                // Implement email retry logic
                break;
            case PUSH_NOTIFICATION:
                // Implement push notification retry logic
                break;
        }
        
        deliveryRepository.save(delivery);
    }
    
    private String createSMSMessage(Notification notification, String studentName) {
        Map<String, String> variables = new HashMap<>();
        variables.put("school_name", "School Name"); // Should come from configuration
        variables.put("student_name", studentName);
        variables.put("title", notification.getTitle());
        variables.put("message", notification.getMessage());
        
        return smsService.getTemplateMessage(notification.getType().name().toLowerCase(), variables);
    }
    
    private String createWhatsAppMessage(Notification notification, String studentName) {
        Map<String, String> variables = new HashMap<>();
        variables.put("school_name", "School Name"); // Should come from configuration
        variables.put("student_name", studentName);
        variables.put("title", notification.getTitle());
        variables.put("message", notification.getMessage());
        return "*" + notification.getTitle() + "*\n" + notification.getMessage(); // Simple formatting, can use template
    }
    
    private String getNotificationMessage(Long notificationId) {
        Notification notification = notificationRepository.findById(notificationId).orElse(null);
        return notification != null ? notification.getMessage() : "Notification message";
    }
    
    private void updateSMSDeliveryStatus(Long notificationId, Map<String, Boolean> smsResults) {
        // Update delivery status based on SMS results
        for (Map.Entry<String, Boolean> result : smsResults.entrySet()) {
            // Find corresponding delivery record and update status
            // This is a simplified implementation
            logger.info("SMS delivery to {}: {}", result.getKey(), result.getValue() ? "SUCCESS" : "FAILED");
        }
    }
    
    private void updateWhatsAppDeliveryStatus(Long notificationId, Map<String, Boolean> waResults) {
        for (Map.Entry<String, Boolean> result : waResults.entrySet()) {
            logger.info("WhatsApp delivery to {}: {}", result.getKey(), result.getValue() ? "SUCCESS" : "FAILED");
        }
    }
    
    private List<Map<String, Object>> getAllStudents() {
        try {
            ResponseEntity<List> response = restTemplate.exchange(
                    STUDENT_SERVICE_URL,
                    HttpMethod.GET,
                    new HttpEntity<>(new HttpHeaders()),
                    List.class
            );
            return response.getBody();
        } catch (Exception e) {
            logger.error("Error fetching all students: {}", e.getMessage());
            return new ArrayList<>();
        }
    }
    
    private List<Map<String, Object>> getStudentsByClass(Long classId) {
        try {
            ResponseEntity<List> response = restTemplate.exchange(
                    STUDENT_SERVICE_URL + "/class/" + classId,
                    HttpMethod.GET,
                    new HttpEntity<>(new HttpHeaders()),
                    List.class
            );
            return response.getBody();
        } catch (Exception e) {
            logger.error("Error fetching students for class {}: {}", classId, e.getMessage());
            return new ArrayList<>();
        }
    }
    
    private List<Map<String, Object>> getStudentsByClassSection(Long classId, String section) {
        try {
            ResponseEntity<List> response = restTemplate.exchange(
                STUDENT_SERVICE_URL + "/class/" + classId + "/section/" + section,
                HttpMethod.GET,
                new HttpEntity<>(new HttpHeaders()),
                List.class
            );
            return response.getBody();
        } catch (Exception e) {
            logger.error("Error fetching students for class {} section {}: {}", classId, section, e.getMessage());
            return new ArrayList<>();
        }
    }
} 