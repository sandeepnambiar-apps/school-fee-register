package com.school.notificationservice.controller;

import com.school.notificationservice.dto.NotificationDTO;
import com.school.notificationservice.model.Notification;
import com.school.notificationservice.model.NotificationDelivery;
import com.school.notificationservice.service.NotificationService;
import com.school.notificationservice.service.WhatsAppService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import jakarta.validation.Valid;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/notifications")
@CrossOrigin(origins = "*")
public class NotificationController {
    
    @Autowired
    private NotificationService notificationService;
    
    @Autowired
    private WhatsAppService whatsappService;
    
    /**
     * Send notification to all parents
     */
    @PostMapping("/send-to-all-parents")
    public ResponseEntity<NotificationDTO> sendNotificationToAllParents(@Valid @RequestBody NotificationDTO notificationDTO) {
        try {
            NotificationDTO result = notificationService.sendNotificationToAllParents(notificationDTO);
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
    /**
     * Send holiday notification to all parents
     */
    @PostMapping("/holiday")
    public ResponseEntity<NotificationDTO> sendHolidayNotification(
            @RequestParam String title,
            @RequestParam String message,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime holidayDate,
            @RequestParam(required = false) List<String> deliveryMethods) {
        
        try {
            NotificationDTO result = notificationService.sendHolidayNotification(title, message, holidayDate, deliveryMethods);
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
    /**
     * Send circular notification to all parents
     */
    @PostMapping("/circular")
    public ResponseEntity<NotificationDTO> sendCircularNotification(
            @RequestParam String title,
            @RequestParam String message,
            @RequestParam(required = false) List<String> deliveryMethods) {
        
        try {
            NotificationDTO result = notificationService.sendCircularNotification(title, message, deliveryMethods);
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
    /**
     * Send emergency notification to all parents
     */
    @PostMapping("/emergency")
    public ResponseEntity<NotificationDTO> sendEmergencyNotification(
            @RequestParam String title,
            @RequestParam String message,
            @RequestParam(required = false) List<String> deliveryMethods) {
        
        try {
            NotificationDTO result = notificationService.sendEmergencyNotification(title, message, deliveryMethods);
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
    /**
     * Send notification to specific class
     */
    @PostMapping("/class/{classId}")
    public ResponseEntity<NotificationDTO> sendNotificationToClass(
            @PathVariable Long classId,
            @Valid @RequestBody NotificationDTO notificationDTO) {
        
        try {
            NotificationDTO result = notificationService.sendNotificationToClass(classId, notificationDTO);
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
    /**
     * Send notification to specific class and section
     */
    @PostMapping("/class/{classId}/section/{section}")
    public ResponseEntity<NotificationDTO> sendNotificationToClassSection(
            @PathVariable Long classId,
            @PathVariable String section,
            @Valid @RequestBody NotificationDTO notificationDTO) {
        try {
            NotificationDTO result = notificationService.sendNotificationToClassSection(classId, section, notificationDTO);
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
    /**
     * Schedule notification for future delivery
     */
    @PostMapping("/schedule")
    public ResponseEntity<NotificationDTO> scheduleNotification(@Valid @RequestBody NotificationDTO notificationDTO) {
        try {
            NotificationDTO result = notificationService.scheduleNotification(notificationDTO);
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
    /**
     * Get all notifications
     */
    @GetMapping
    public ResponseEntity<List<NotificationDTO>> getAllNotifications() {
        try {
            // This would need to be implemented in the service
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
    /**
     * Get notification by ID
     */
    @GetMapping("/{id}")
    public ResponseEntity<NotificationDTO> getNotificationById(@PathVariable Long id) {
        try {
            NotificationDTO result = notificationService.getNotificationById(id);
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            return ResponseEntity.notFound().build();
        }
    }
    
    /**
     * Get notifications by type
     */
    @GetMapping("/type/{type}")
    public ResponseEntity<List<NotificationDTO>> getNotificationsByType(@PathVariable String type) {
        try {
            Notification.NotificationType notificationType = Notification.NotificationType.valueOf(type.toUpperCase());
            List<NotificationDTO> result = notificationService.getNotificationsByType(notificationType);
            return ResponseEntity.ok(result);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().build();
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
    /**
     * Get notifications by status
     */
    @GetMapping("/status/{status}")
    public ResponseEntity<List<NotificationDTO>> getNotificationsByStatus(@PathVariable String status) {
        try {
            Notification.Status notificationStatus = Notification.Status.valueOf(status.toUpperCase());
            List<NotificationDTO> result = notificationService.getNotificationsByStatus(notificationStatus);
            return ResponseEntity.ok(result);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().build();
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
    /**
     * Get delivery statistics for a notification
     */
    @GetMapping("/{id}/statistics")
    public ResponseEntity<Map<String, Object>> getDeliveryStatistics(@PathVariable Long id) {
        try {
            Map<String, Object> result = notificationService.getDeliveryStatistics(id);
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
    /**
     * Mark notification as read by recipient
     */
    @PutMapping("/{notificationId}/read/{recipientId}")
    public ResponseEntity<Void> markAsRead(@PathVariable Long notificationId, @PathVariable Long recipientId) {
        try {
            notificationService.markAsRead(notificationId, recipientId);
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
    /**
     * Get unread notifications for a recipient
     */
    @GetMapping("/unread/{recipientId}")
    public ResponseEntity<List<NotificationDelivery>> getUnreadNotifications(@PathVariable Long recipientId) {
        try {
            List<NotificationDelivery> result = notificationService.getUnreadNotifications(recipientId);
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
    /**
     * Delete notification
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteNotification(@PathVariable Long id) {
        try {
            // This would need to be implemented in the service
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
    /**
     * Cancel scheduled notification
     */
    @PutMapping("/{id}/cancel")
    public ResponseEntity<Void> cancelNotification(@PathVariable Long id) {
        try {
            // This would need to be implemented in the service
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
    
    /**
     * Get notification types
     */
    @GetMapping("/types")
    public ResponseEntity<Notification.NotificationType[]> getNotificationTypes() {
        return ResponseEntity.ok(Notification.NotificationType.values());
    }
    
    /**
     * Get delivery methods
     */
    @GetMapping("/delivery-methods")
    public ResponseEntity<NotificationDelivery.DeliveryMethod[]> getDeliveryMethods() {
        return ResponseEntity.ok(NotificationDelivery.DeliveryMethod.values());
    }
    
    /**
     * Get target audiences
     */
    @GetMapping("/target-audiences")
    public ResponseEntity<Notification.TargetAudience[]> getTargetAudiences() {
        return ResponseEntity.ok(Notification.TargetAudience.values());
    }
    
    /**
     * Send WhatsApp message directly
     */
    @PostMapping("/whatsapp")
    public ResponseEntity<Map<String, Object>> sendWhatsApp(@RequestBody Map<String, String> request) {
        try {
            String phoneNumber = request.get("phoneNumber");
            String message = request.get("message");
            
            if (phoneNumber == null || message == null) {
                return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "error", "phoneNumber and message are required"
                ));
            }
            
            boolean success = whatsappService.sendWhatsApp(phoneNumber, message);
            
            if (success) {
                return ResponseEntity.ok(Map.of(
                    "success", true,
                    "message", "WhatsApp message sent successfully"
                ));
            } else {
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Map.of(
                    "success", false,
                    "error", "Failed to send WhatsApp message"
                ));
            }
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Map.of(
                "success", false,
                "error", "Error sending WhatsApp message: " + e.getMessage()
            ));
        }
    }
    
    /**
     * Send WhatsApp template message
     */
    @PostMapping("/whatsapp/template")
    public ResponseEntity<Map<String, Object>> sendWhatsAppTemplate(@RequestBody Map<String, Object> request) {
        try {
            String phoneNumber = (String) request.get("phoneNumber");
            String templateName = (String) request.get("templateName");
            String language = (String) request.getOrDefault("language", "en");
            @SuppressWarnings("unchecked")
            Map<String, String> variables = (Map<String, String>) request.get("variables");
            
            if (phoneNumber == null || templateName == null) {
                return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "error", "phoneNumber and templateName are required"
                ));
            }
            
            boolean success = whatsappService.sendTemplateWhatsApp(phoneNumber, templateName, variables);
            
            if (success) {
                return ResponseEntity.ok(Map.of(
                    "success", true,
                    "message", "WhatsApp template message sent successfully"
                ));
            } else {
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Map.of(
                    "success", false,
                    "error", "Failed to send WhatsApp template message"
                ));
            }
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Map.of(
                "success", false,
                "error", "Error sending WhatsApp template message: " + e.getMessage()
            ));
        }
    }
    
    /**
     * Send bulk WhatsApp messages
     */
    @PostMapping("/whatsapp/bulk")
    public ResponseEntity<Map<String, Object>> sendBulkWhatsApp(@RequestBody Map<String, Object> request) {
        try {
            @SuppressWarnings("unchecked")
            List<String> phoneNumbers = (List<String>) request.get("phoneNumbers");
            String message = (String) request.get("message");
            
            if (phoneNumbers == null || phoneNumbers.isEmpty() || message == null) {
                return ResponseEntity.badRequest().body(Map.of(
                    "success", false,
                    "error", "phoneNumbers and message are required"
                ));
            }
            
            Map<String, String> phoneNumberToMessage = new java.util.HashMap<>();
            for (String phoneNumber : phoneNumbers) {
                phoneNumberToMessage.put(phoneNumber, message);
            }
            
            Map<String, Boolean> results = whatsappService.sendBulkWhatsApp(phoneNumberToMessage);
            
            return ResponseEntity.ok(Map.of(
                "success", true,
                "message", "Bulk WhatsApp messages sent",
                "results", results
            ));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Map.of(
                "success", false,
                "error", "Error sending bulk WhatsApp messages: " + e.getMessage()
            ));
        }
    }
} 