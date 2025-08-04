package com.school.notification.controller;

import com.school.notification.service.NotificationService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/notifications")
@RequiredArgsConstructor
public class NotificationController {
    private final NotificationService notificationService;

    @PostMapping("/email")
    public ResponseEntity<String> sendEmail(@RequestParam String to,
                                            @RequestParam String subject,
                                            @RequestParam String body) {
        notificationService.sendEmail(to, subject, body);
        return ResponseEntity.ok("Email sent (if configuration is correct)");
    }
    
    // WhatsApp notification endpoints
    @PostMapping("/whatsapp")
    public ResponseEntity<String> sendWhatsApp(@RequestParam String phoneNumber,
                                              @RequestParam String message) {
        notificationService.sendWhatsApp(phoneNumber, message);
        return ResponseEntity.ok("WhatsApp message sent");
    }
    
    @PostMapping("/whatsapp/template")
    public ResponseEntity<String> sendWhatsAppTemplate(@RequestParam String phoneNumber,
                                                      @RequestParam String templateName,
                                                      @RequestParam(defaultValue = "en") String language,
                                                      @RequestParam(required = false) List<String> parameters) {
        if (parameters != null && !parameters.isEmpty()) {
            notificationService.sendWhatsAppTemplate(phoneNumber, templateName, language, parameters.toArray());
        } else {
            notificationService.sendWhatsAppTemplate(phoneNumber, templateName, language);
        }
        return ResponseEntity.ok("WhatsApp template message sent");
    }
    
    @PostMapping("/whatsapp/bulk")
    public ResponseEntity<String> sendBulkWhatsApp(@RequestParam List<String> phoneNumbers,
                                                  @RequestParam String message) {
        notificationService.sendBulkWhatsApp(phoneNumbers.toArray(new String[0]), message);
        return ResponseEntity.ok("Bulk WhatsApp messages sent");
    }
    
    @PostMapping("/whatsapp/media")
    public ResponseEntity<String> sendWhatsAppWithMedia(@RequestParam String phoneNumber,
                                                       @RequestParam String message,
                                                       @RequestParam String mediaUrl,
                                                       @RequestParam(defaultValue = "image") String mediaType) {
        notificationService.sendWhatsAppWithMedia(phoneNumber, message, mediaUrl, mediaType);
        return ResponseEntity.ok("WhatsApp media message sent");
    }
    
    // Parent notification endpoints
    @PostMapping("/parent/{studentId}")
    public ResponseEntity<String> sendNotificationToParent(@PathVariable Long studentId,
                                                          @RequestParam String title,
                                                          @RequestParam String message,
                                                          @RequestParam(defaultValue = "both") String channels) {
        try {
            notificationService.sendNotificationToParent(studentId, title, message, channels);
            return ResponseEntity.ok("Notification sent to parent successfully");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Failed to send notification: " + e.getMessage());
        }
    }
    
    @PostMapping("/parents")
    public ResponseEntity<String> sendNotificationToParents(@RequestParam List<Long> studentIds,
                                                           @RequestParam String title,
                                                           @RequestParam String message,
                                                           @RequestParam(defaultValue = "both") String channels) {
        try {
            notificationService.sendNotificationToParents(studentIds, title, message, channels);
            return ResponseEntity.ok("Notifications sent to parents successfully");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Failed to send notifications: " + e.getMessage());
        }
    }
    
    @PostMapping("/class/{classId}/parents")
    public ResponseEntity<String> sendNotificationToClassParents(@PathVariable Long classId,
                                                                @RequestParam String title,
                                                                @RequestParam String message,
                                                                @RequestParam(defaultValue = "both") String channels) {
        try {
            notificationService.sendNotificationToClassParents(classId, title, message, channels);
            return ResponseEntity.ok("Notifications sent to class parents successfully");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Failed to send notifications: " + e.getMessage());
        }
    }
    
    // Fee reminder endpoints
    @PostMapping("/fee-reminder/parent/{studentId}")
    public ResponseEntity<String> sendFeeReminderToParent(@PathVariable Long studentId,
                                                         @RequestParam String amount,
                                                         @RequestParam String dueDate) {
        try {
            notificationService.sendFeeReminderToParent(studentId, amount, dueDate);
            return ResponseEntity.ok("Fee reminder sent to parent successfully");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Failed to send fee reminder: " + e.getMessage());
        }
    }
    
    @PostMapping("/fee-reminder/class/{classId}/parents")
    public ResponseEntity<String> sendFeeReminderToClassParents(@PathVariable Long classId,
                                                               @RequestParam String amount,
                                                               @RequestParam String dueDate) {
        try {
            notificationService.sendFeeReminderToClassParents(classId, amount, dueDate);
            return ResponseEntity.ok("Fee reminders sent to class parents successfully");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Failed to send fee reminders: " + e.getMessage());
        }
    }
    
    // Combined notification endpoint
    @PostMapping("/send")
    public ResponseEntity<String> sendNotification(@RequestParam String title,
                                                  @RequestParam String message,
                                                  @RequestParam(required = false) String email,
                                                  @RequestParam(required = false) String phoneNumber,
                                                  @RequestParam(defaultValue = "both") String channels) {
        try {
            if (channels.contains("email") && email != null) {
                notificationService.sendEmail(email, title, message);
            }
            
            if (channels.contains("whatsapp") && phoneNumber != null) {
                notificationService.sendWhatsApp(phoneNumber, message);
            }
            
            return ResponseEntity.ok("Notification sent successfully");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Failed to send notification: " + e.getMessage());
        }
    }

    @GetMapping("/health")
    public ResponseEntity<String> health() {
        return ResponseEntity.ok("Notification Service is running!");
    }
} 