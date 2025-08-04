package com.school.notification.service;

import java.util.List;

public interface NotificationService {
    void sendEmail(String to, String subject, String body);
    
    // WhatsApp notification methods
    void sendWhatsApp(String phoneNumber, String message);
    void sendWhatsAppTemplate(String phoneNumber, String templateName, String language, Object... parameters);
    void sendBulkWhatsApp(String[] phoneNumbers, String message);
    void sendWhatsAppWithMedia(String phoneNumber, String message, String mediaUrl, String mediaType);
    
    // Parent notification methods (focusing only on parents)
    void sendNotificationToParent(Long studentId, String title, String message, String channels);
    void sendNotificationToParents(List<Long> studentIds, String title, String message, String channels);
    void sendNotificationToClassParents(Long classId, String title, String message, String channels);
    void sendFeeReminderToParent(Long studentId, String amount, String dueDate);
    void sendFeeReminderToClassParents(Long classId, String amount, String dueDate);
} 