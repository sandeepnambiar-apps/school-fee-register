package com.school.notificationservice.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.HashMap;
import java.util.Map;

@Service
public class SMSService {
    
    private static final Logger logger = LoggerFactory.getLogger(SMSService.class);
    
    @Value("${sms.api.url:https://api.twilio.com/2010-04-01/Accounts}")
    private String smsApiUrl;
    
    @Value("${sms.account.sid}")
    private String accountSid;
    
    @Value("${sms.auth.token}")
    private String authToken;
    
    @Value("${sms.from.number}")
    private String fromNumber;
    
    private final RestTemplate restTemplate;
    
    public SMSService(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }
    
    /**
     * Send SMS to a single phone number
     */
    public boolean sendSMS(String toPhoneNumber, String message) {
        try {
            logger.info("Sending SMS to: {}", toPhoneNumber);
            
            // Prepare SMS payload
            Map<String, String> smsPayload = new HashMap<>();
            smsPayload.put("To", toPhoneNumber);
            smsPayload.put("From", fromNumber);
            smsPayload.put("Body", message);
            
            // Set headers for Twilio API
            HttpHeaders headers = new HttpHeaders();
            headers.setBasicAuth(accountSid, authToken);
            headers.set("Content-Type", "application/x-www-form-urlencoded");
            
            // Make API call to Twilio
            String url = smsApiUrl + "/" + accountSid + "/Messages.json";
            HttpEntity<Map<String, String>> request = new HttpEntity<>(smsPayload, headers);
            
            ResponseEntity<Map> response = restTemplate.exchange(
                    url,
                    HttpMethod.POST,
                    request,
                    Map.class
            );
            
            if (response.getStatusCode().is2xxSuccessful()) {
                logger.info("SMS sent successfully to: {}", toPhoneNumber);
                return true;
            } else {
                logger.error("Failed to send SMS to: {}. Status: {}", toPhoneNumber, response.getStatusCode());
                return false;
            }
            
        } catch (Exception e) {
            logger.error("Error sending SMS to {}: {}", toPhoneNumber, e.getMessage(), e);
            return false;
        }
    }
    
    /**
     * Send bulk SMS to multiple phone numbers
     */
    public Map<String, Boolean> sendBulkSMS(Map<String, String> phoneNumberToMessage) {
        Map<String, Boolean> results = new HashMap<>();
        
        for (Map.Entry<String, String> entry : phoneNumberToMessage.entrySet()) {
            String phoneNumber = entry.getKey();
            String message = entry.getValue();
            
            boolean success = sendSMS(phoneNumber, message);
            results.put(phoneNumber, success);
            
            // Add delay to avoid rate limiting
            try {
                Thread.sleep(100);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                break;
            }
        }
        
        return results;
    }
    
    /**
     * Send SMS with template (for standardized messages)
     */
    public boolean sendTemplateSMS(String toPhoneNumber, String templateName, Map<String, String> variables) {
        String message = getTemplateMessage(templateName, variables);
        return sendSMS(toPhoneNumber, message);
    }
    
    /**
     * Get template message with variables replaced
     */
    public String getTemplateMessage(String templateName, Map<String, String> variables) {
        String template = getSMSTemplate(templateName);
        
        if (template != null && variables != null) {
            for (Map.Entry<String, String> entry : variables.entrySet()) {
                template = template.replace("{{" + entry.getKey() + "}}", entry.getValue());
            }
        }
        
        return template;
    }
    
    /**
     * Get SMS template by name
     */
    private String getSMSTemplate(String templateName) {
        switch (templateName.toLowerCase()) {
            case "holiday":
                return "Dear Parent, {{school_name}} will be closed on {{date}} for {{reason}}. Classes will resume on {{resume_date}}. Thank you.";
            case "circular":
                return "Dear Parent, {{title}}: {{message}}. For more details, please check the school app. - {{school_name}}";
            case "emergency":
                return "URGENT: {{message}}. Please take necessary action. - {{school_name}}";
            case "fee_reminder":
                return "Dear Parent, fee payment of {{amount}} for {{student_name}} is due on {{due_date}}. Please pay online or contact school office.";
            case "exam_schedule":
                return "Dear Parent, {{exam_name}} for {{student_name}} is scheduled on {{date}} at {{time}}. Please ensure your child is prepared.";
            default:
                return "{{message}}";
        }
    }
    
    /**
     * Validate phone number format
     */
    public boolean isValidPhoneNumber(String phoneNumber) {
        if (phoneNumber == null || phoneNumber.trim().isEmpty()) {
            return false;
        }
        
        // Remove all non-digit characters
        String digitsOnly = phoneNumber.replaceAll("[^0-9]", "");
        
        // Check if it's a valid length (10-15 digits)
        return digitsOnly.length() >= 10 && digitsOnly.length() <= 15;
    }
    
    /**
     * Format phone number to international format
     */
    public String formatPhoneNumber(String phoneNumber) {
        if (phoneNumber == null) {
            return null;
        }
        
        // Remove all non-digit characters
        String digitsOnly = phoneNumber.replaceAll("[^0-9]", "");
        
        // If it starts with 0, replace with country code (assuming +91 for India)
        if (digitsOnly.startsWith("0")) {
            digitsOnly = "91" + digitsOnly.substring(1);
        }
        
        // If it doesn't start with country code, add +91
        if (!digitsOnly.startsWith("91")) {
            digitsOnly = "91" + digitsOnly;
        }
        
        return "+" + digitsOnly;
    }
} 