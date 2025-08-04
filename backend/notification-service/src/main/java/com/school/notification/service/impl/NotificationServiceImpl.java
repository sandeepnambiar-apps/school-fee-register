package com.school.notification.service.impl;

import com.school.notification.dto.StudentContactDTO;
import com.school.notification.service.NotificationService;
import com.school.notification.service.StudentContactService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Slf4j
public class NotificationServiceImpl implements NotificationService {
    private static final Logger log = LoggerFactory.getLogger(NotificationServiceImpl.class);
    
    private final JavaMailSender mailSender;
    private final RestTemplate restTemplate = new RestTemplate();
    private final StudentContactService studentContactService;
    
    @Value("${whatsapp.api.url:https://graph.facebook.com/v17.0}")
    private String whatsappApiUrl;
    
    @Value("${whatsapp.phone.number.id:}")
    private String whatsappPhoneNumberId;
    
    @Value("${whatsapp.access.token:}")
    private String whatsappAccessToken;

    @Override
    public void sendEmail(String to, String subject, String body) {
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setTo(to);
            message.setSubject(subject);
            message.setText(body);
            mailSender.send(message);
            log.info("Email sent to {} with subject: {}", to, subject);
        } catch (Exception e) {
            log.error("Failed to send email to {}: {}", to, e.getMessage(), e);
        }
    }
    
    @Override
    public void sendWhatsApp(String phoneNumber, String message) {
        try {
            String url = whatsappApiUrl + "/" + whatsappPhoneNumberId + "/messages";
            
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            headers.setBearerAuth(whatsappAccessToken);
            
            Map<String, Object> requestBody = new HashMap<>();
            requestBody.put("messaging_product", "whatsapp");
            requestBody.put("to", phoneNumber);
            requestBody.put("type", "text");
            
            Map<String, String> text = new HashMap<>();
            text.put("body", message);
            requestBody.put("text", text);
            
            HttpEntity<Map<String, Object>> request = new HttpEntity<>(requestBody, headers);
            
            ResponseEntity<String> response = restTemplate.postForEntity(url, request, String.class);
            
            if (response.getStatusCode().is2xxSuccessful()) {
                log.info("WhatsApp message sent to {} successfully", phoneNumber);
            } else {
                log.error("Failed to send WhatsApp message to {}: {}", phoneNumber, response.getBody());
            }
        } catch (Exception e) {
            log.error("Failed to send WhatsApp message to {}: {}", phoneNumber, e.getMessage(), e);
        }
    }
    
    @Override
    public void sendWhatsAppTemplate(String phoneNumber, String templateName, String language, Object... parameters) {
        try {
            String url = whatsappApiUrl + "/" + whatsappPhoneNumberId + "/messages";
            
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            headers.setBearerAuth(whatsappAccessToken);
            
            Map<String, Object> requestBody = new HashMap<>();
            requestBody.put("messaging_product", "whatsapp");
            requestBody.put("to", phoneNumber);
            requestBody.put("type", "template");
            
            Map<String, Object> template = new HashMap<>();
            template.put("name", templateName);
            template.put("language", Map.of("code", language));
            
            if (parameters.length > 0) {
                Map<String, Object>[] components = new Map[1];
                Map<String, Object> component = new HashMap<>();
                component.put("type", "body");
                
                Map<String, Object>[] parametersArray = new Map[parameters.length];
                for (int i = 0; i < parameters.length; i++) {
                    Map<String, Object> param = new HashMap<>();
                    param.put("type", "text");
                    param.put("text", parameters[i].toString());
                    parametersArray[i] = param;
                }
                component.put("parameters", parametersArray);
                components[0] = component;
                template.put("components", components);
            }
            
            requestBody.put("template", template);
            
            HttpEntity<Map<String, Object>> request = new HttpEntity<>(requestBody, headers);
            
            ResponseEntity<String> response = restTemplate.postForEntity(url, request, String.class);
            
            if (response.getStatusCode().is2xxSuccessful()) {
                log.info("WhatsApp template message sent to {} successfully", phoneNumber);
            } else {
                log.error("Failed to send WhatsApp template message to {}: {}", phoneNumber, response.getBody());
            }
        } catch (Exception e) {
            log.error("Failed to send WhatsApp template message to {}: {}", phoneNumber, e.getMessage(), e);
        }
    }
    
    @Override
    public void sendBulkWhatsApp(String[] phoneNumbers, String message) {
        for (String phoneNumber : phoneNumbers) {
            sendWhatsApp(phoneNumber, message);
            // Add delay to avoid rate limiting
            try {
                Thread.sleep(1000);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                break;
            }
        }
    }
    
    @Override
    public void sendWhatsAppWithMedia(String phoneNumber, String message, String mediaUrl, String mediaType) {
        try {
            String url = whatsappApiUrl + "/" + whatsappPhoneNumberId + "/messages";
            
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            headers.setBearerAuth(whatsappAccessToken);
            
            Map<String, Object> requestBody = new HashMap<>();
            requestBody.put("messaging_product", "whatsapp");
            requestBody.put("to", phoneNumber);
            requestBody.put("type", "image"); // or "document", "audio", "video" based on mediaType
            
            Map<String, Object> media = new HashMap<>();
            media.put("link", mediaUrl);
            media.put("caption", message);
            requestBody.put("image", media);
            
            HttpEntity<Map<String, Object>> request = new HttpEntity<>(requestBody, headers);
            
            ResponseEntity<String> response = restTemplate.postForEntity(url, request, String.class);
            
            if (response.getStatusCode().is2xxSuccessful()) {
                log.info("WhatsApp media message sent to {} successfully", phoneNumber);
            } else {
                log.error("Failed to send WhatsApp media message to {}: {}", phoneNumber, response.getBody());
            }
        } catch (Exception e) {
            log.error("Failed to send WhatsApp media message to {}: {}", phoneNumber, e.getMessage(), e);
        }
    }
    
    // Parent notification methods
    @Override
    public void sendNotificationToParent(Long studentId, String title, String message, String channels) {
        StudentContactDTO student = studentContactService.getStudentContact(studentId);
        if (student == null) {
            log.error("Student not found with ID: {}", studentId);
            return;
        }
        
        sendNotificationToParent(student, title, message, channels);
    }
    
    @Override
    public void sendNotificationToParents(List<Long> studentIds, String title, String message, String channels) {
        List<StudentContactDTO> students = studentContactService.getStudentsByIds(studentIds);
        sendNotificationToParentsList(students, title, message, channels);
    }
    
    @Override
    public void sendNotificationToClassParents(Long classId, String title, String message, String channels) {
        List<StudentContactDTO> students = studentContactService.getStudentsByClass(classId);
        sendNotificationToParentsList(students, title, message, channels);
    }
    
    @Override
    public void sendFeeReminderToParent(Long studentId, String amount, String dueDate) {
        StudentContactDTO student = studentContactService.getStudentContact(studentId);
        if (student == null) {
            log.error("Student not found with ID: {}", studentId);
            return;
        }
        
        String message = String.format("Dear %s, this is a reminder that the school fees for %s amounting to %s is due by %s. Please make the payment to avoid any late fees.", 
                student.getParentName(), student.getStudentName(), amount, dueDate);
        
        sendNotificationToParent(student, "Fee Payment Reminder", message, "both");
    }
    
    @Override
    public void sendFeeReminderToClassParents(Long classId, String amount, String dueDate) {
        List<StudentContactDTO> students = studentContactService.getStudentsByClass(classId);
        
        for (StudentContactDTO student : students) {
            String message = String.format("Dear %s, this is a reminder that the school fees for %s amounting to %s is due by %s. Please make the payment to avoid any late fees.", 
                    student.getParentName(), student.getStudentName(), amount, dueDate);
            
            sendNotificationToParent(student, "Fee Payment Reminder", message, "both");
        }
    }
    
    // Helper methods
    private void sendNotificationToParent(StudentContactDTO student, String title, String message, String channels) {
        try {
            if (channels.contains("email") || channels.equals("both")) {
                // Send email to parent
                if (student.getParentEmail() != null && !student.getParentEmail().trim().isEmpty()) {
                    sendEmail(student.getParentEmail(), title, message);
                }
            }
            
            if (channels.contains("whatsapp") || channels.equals("both")) {
                // Send WhatsApp to parent
                if (student.getParentPhone() != null && !student.getParentPhone().trim().isEmpty()) {
                    sendWhatsApp(student.getParentPhone(), message);
                }
            }
            
            log.info("Notification sent to parent of student {} via channels: {}", student.getStudentName(), channels);
        } catch (Exception e) {
            log.error("Failed to send notification to parent of student {}: {}", student.getStudentName(), e.getMessage());
        }
    }
    
    private void sendNotificationToParentsList(List<StudentContactDTO> students, String title, String message, String channels) {
        try {
            if (channels.contains("email") || channels.equals("both")) {
                List<String> emails = studentContactService.getParentEmailAddresses(students);
                for (String email : emails) {
                    sendEmail(email, title, message);
                }
            }
            
            if (channels.contains("whatsapp") || channels.equals("both")) {
                List<String> phones = studentContactService.getParentPhoneNumbers(students);
                sendBulkWhatsApp(phones.toArray(new String[0]), message);
            }
            
            log.info("Bulk notification sent to {} parents via channels: {}", students.size(), channels);
        } catch (Exception e) {
            log.error("Failed to send bulk notification to parents: {}", e.getMessage());
        }
    }
} 