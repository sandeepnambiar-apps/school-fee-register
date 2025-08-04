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
public class WhatsAppService {
    
    private static final Logger logger = LoggerFactory.getLogger(WhatsAppService.class);
    
    @Value("${whatsapp.api.url:https://graph.facebook.com/v17.0}")
    private String whatsappApiUrl;
    
    @Value("${whatsapp.phone.number.id}")
    private String phoneNumberId;
    
    @Value("${whatsapp.access.token}")
    private String accessToken;
    
    @Value("${whatsapp.business.account.id}")
    private String businessAccountId;
    
    @Value("${whatsapp.from.number}")
    private String fromNumber;
    
    private final RestTemplate restTemplate;
    
    public WhatsAppService(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }
    
    /**
     * Send WhatsApp message to a single phone number
     */
    public boolean sendWhatsApp(String toPhoneNumber, String message) {
        try {
            logger.info("Sending WhatsApp to: {}", toPhoneNumber);
            
            // Validate configuration
            if (accessToken == null || accessToken.isEmpty() || accessToken.equals("test_access_token")) {
                logger.error("WhatsApp access token is not configured properly");
                return false;
            }
            
            if (phoneNumberId == null || phoneNumberId.isEmpty() || phoneNumberId.equals("test_phone_number_id")) {
                logger.error("WhatsApp phone number ID is not configured properly");
                return false;
            }
            
            // Format phone number for WhatsApp
            String formattedPhone = formatPhoneForWhatsApp(toPhoneNumber);
            logger.debug("Formatted phone number: {}", formattedPhone);
            
            // Prepare WhatsApp payload
            Map<String, Object> whatsappPayload = new HashMap<>();
            whatsappPayload.put("messaging_product", "whatsapp");
            whatsappPayload.put("to", formattedPhone);
            whatsappPayload.put("type", "text");
            
            Map<String, String> textContent = new HashMap<>();
            textContent.put("body", message);
            whatsappPayload.put("text", textContent);
            
            logger.debug("WhatsApp payload: {}", whatsappPayload);
            
            // Set headers for WhatsApp Business API
            HttpHeaders headers = new HttpHeaders();
            headers.set("Authorization", "Bearer " + accessToken);
            headers.set("Content-Type", "application/json");
            
            // Make API call to WhatsApp Business API
            String url = whatsappApiUrl + "/" + phoneNumberId + "/messages";
            logger.debug("WhatsApp API URL: {}", url);
            
            HttpEntity<Map<String, Object>> request = new HttpEntity<>(whatsappPayload, headers);
            
            ResponseEntity<Map> response = restTemplate.exchange(
                    url,
                    HttpMethod.POST,
                    request,
                    Map.class
            );
            
            logger.debug("WhatsApp API response status: {}", response.getStatusCode());
            logger.debug("WhatsApp API response body: {}", response.getBody());
            
            if (response.getStatusCode().is2xxSuccessful()) {
                logger.info("WhatsApp sent successfully to: {}", toPhoneNumber);
                return true;
            } else {
                logger.error("Failed to send WhatsApp to: {}. Status: {}", toPhoneNumber, response.getStatusCode());
                logger.error("Response body: {}", response.getBody());
                return false;
            }
            
        } catch (Exception e) {
            logger.error("Error sending WhatsApp to {}: {}", toPhoneNumber, e.getMessage(), e);
            return false;
        }
    }
    
    /**
     * Send WhatsApp template message (for first-time messages)
     */
    public boolean sendTemplateWhatsApp(String toPhoneNumber, String templateName, Map<String, String> variables) {
        try {
            logger.info("Sending WhatsApp template to: {}", toPhoneNumber);
            
            String formattedPhone = formatPhoneForWhatsApp(toPhoneNumber);
            
            // Prepare template payload
            Map<String, Object> templatePayload = new HashMap<>();
            templatePayload.put("messaging_product", "whatsapp");
            templatePayload.put("to", formattedPhone);
            templatePayload.put("type", "template");
            
            Map<String, Object> template = new HashMap<>();
            template.put("name", templateName);
            template.put("language", new HashMap<String, String>() {{
                put("code", "en");
            }});
            
            // Add template variables if provided
            if (variables != null && !variables.isEmpty()) {
                Map<String, Object> components = new HashMap<>();
                components.put("type", "body");
                
                Map<String, Object> parameters = new HashMap<>();
                parameters.put("type", "text");
                parameters.put("text", variables.get("message"));
                
                components.put("parameters", new Object[]{parameters});
                template.put("components", new Object[]{components});
            }
            
            templatePayload.put("template", template);
            
            // Set headers
            HttpHeaders headers = new HttpHeaders();
            headers.set("Authorization", "Bearer " + accessToken);
            headers.set("Content-Type", "application/json");
            
            // Make API call
            String url = whatsappApiUrl + "/" + phoneNumberId + "/messages";
            HttpEntity<Map<String, Object>> request = new HttpEntity<>(templatePayload, headers);
            
            ResponseEntity<Map> response = restTemplate.exchange(
                    url,
                    HttpMethod.POST,
                    request,
                    Map.class
            );
            
            if (response.getStatusCode().is2xxSuccessful()) {
                logger.info("WhatsApp template sent successfully to: {}", toPhoneNumber);
                return true;
            } else {
                logger.error("Failed to send WhatsApp template to: {}. Status: {}", toPhoneNumber, response.getStatusCode());
                return false;
            }
            
        } catch (Exception e) {
            logger.error("Error sending WhatsApp template to {}: {}", toPhoneNumber, e.getMessage(), e);
            return false;
        }
    }
    
    /**
     * Send bulk WhatsApp to multiple phone numbers
     */
    public Map<String, Boolean> sendBulkWhatsApp(Map<String, String> phoneNumberToMessage) {
        Map<String, Boolean> results = new HashMap<>();
        
        for (Map.Entry<String, String> entry : phoneNumberToMessage.entrySet()) {
            String phoneNumber = entry.getKey();
            String message = entry.getValue();
            
            boolean success = sendWhatsApp(phoneNumber, message);
            results.put(phoneNumber, success);
            
            // Add delay to avoid rate limiting
            try {
                Thread.sleep(200); // WhatsApp has stricter rate limits
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                break;
            }
        }
        
        return results;
    }
    
    /**
     * Send WhatsApp with rich media (image, document)
     */
    public boolean sendWhatsAppWithMedia(String toPhoneNumber, String mediaUrl, String mediaType, String caption) {
        try {
            logger.info("Sending WhatsApp media to: {}", toPhoneNumber);
            
            String formattedPhone = formatPhoneForWhatsApp(toPhoneNumber);
            
            // Prepare media payload
            Map<String, Object> mediaPayload = new HashMap<>();
            mediaPayload.put("messaging_product", "whatsapp");
            mediaPayload.put("to", formattedPhone);
            mediaPayload.put("type", mediaType); // image, document, audio, video
            
            Map<String, Object> media = new HashMap<>();
            media.put("link", mediaUrl);
            if (caption != null && !caption.isEmpty()) {
                media.put("caption", caption);
            }
            mediaPayload.put(mediaType, media);
            
            // Set headers
            HttpHeaders headers = new HttpHeaders();
            headers.set("Authorization", "Bearer " + accessToken);
            headers.set("Content-Type", "application/json");
            
            // Make API call
            String url = whatsappApiUrl + "/" + phoneNumberId + "/messages";
            HttpEntity<Map<String, Object>> request = new HttpEntity<>(mediaPayload, headers);
            
            ResponseEntity<Map> response = restTemplate.exchange(
                    url,
                    HttpMethod.POST,
                    request,
                    Map.class
            );
            
            if (response.getStatusCode().is2xxSuccessful()) {
                logger.info("WhatsApp media sent successfully to: {}", toPhoneNumber);
                return true;
            } else {
                logger.error("Failed to send WhatsApp media to: {}. Status: {}", toPhoneNumber, response.getStatusCode());
                return false;
            }
            
        } catch (Exception e) {
            logger.error("Error sending WhatsApp media to {}: {}", toPhoneNumber, e.getMessage(), e);
            return false;
        }
    }
    
    /**
     * Send interactive WhatsApp message with buttons
     */
    public boolean sendInteractiveWhatsApp(String toPhoneNumber, String headerText, String bodyText, String footerText, 
                                          Map<String, String> buttons) {
        try {
            logger.info("Sending interactive WhatsApp to: {}", toPhoneNumber);
            
            String formattedPhone = formatPhoneForWhatsApp(toPhoneNumber);
            
            // Prepare interactive payload
            Map<String, Object> interactivePayload = new HashMap<>();
            interactivePayload.put("messaging_product", "whatsapp");
            interactivePayload.put("to", formattedPhone);
            interactivePayload.put("type", "interactive");
            
            Map<String, Object> interactive = new HashMap<>();
            interactive.put("type", "button");
            
            // Header
            if (headerText != null) {
                Map<String, Object> header = new HashMap<>();
                header.put("type", "text");
                header.put("text", headerText);
                interactive.put("header", header);
            }
            
            // Body
            Map<String, Object> body = new HashMap<>();
            body.put("text", bodyText);
            interactive.put("body", body);
            
            // Footer
            if (footerText != null) {
                Map<String, Object> footer = new HashMap<>();
                footer.put("text", footerText);
                interactive.put("footer", footer);
            }
            
            // Action (buttons)
            Map<String, Object> action = new HashMap<>();
            action.put("buttons", createButtons(buttons));
            interactive.put("action", action);
            
            interactivePayload.put("interactive", interactive);
            
            // Set headers
            HttpHeaders headers = new HttpHeaders();
            headers.set("Authorization", "Bearer " + accessToken);
            headers.set("Content-Type", "application/json");
            
            // Make API call
            String url = whatsappApiUrl + "/" + phoneNumberId + "/messages";
            HttpEntity<Map<String, Object>> request = new HttpEntity<>(interactivePayload, headers);
            
            ResponseEntity<Map> response = restTemplate.exchange(
                    url,
                    HttpMethod.POST,
                    request,
                    Map.class
            );
            
            if (response.getStatusCode().is2xxSuccessful()) {
                logger.info("Interactive WhatsApp sent successfully to: {}", toPhoneNumber);
                return true;
            } else {
                logger.error("Failed to send interactive WhatsApp to: {}. Status: {}", toPhoneNumber, response.getStatusCode());
                return false;
            }
            
        } catch (Exception e) {
            logger.error("Error sending interactive WhatsApp to {}: {}", toPhoneNumber, e.getMessage(), e);
            return false;
        }
    }
    
    /**
     * Create buttons for interactive messages
     */
    private Object[] createButtons(Map<String, String> buttons) {
        Object[] buttonArray = new Object[buttons.size()];
        int index = 0;
        
        for (Map.Entry<String, String> entry : buttons.entrySet()) {
            Map<String, Object> button = new HashMap<>();
            button.put("type", "reply");
            button.put("reply", new HashMap<String, String>() {{
                put("id", entry.getKey());
                put("title", entry.getValue());
            }});
            buttonArray[index++] = button;
        }
        
        return buttonArray;
    }
    
    /**
     * Get WhatsApp template by name
     */
    private String getWhatsAppTemplate(String templateName) {
        switch (templateName.toLowerCase()) {
            case "holiday":
                return "🎉 *Holiday Announcement*\n\nDear Parent, {{school_name}} will be closed on {{date}} for {{reason}}. Classes will resume on {{resume_date}}. Thank you! 📚";
            case "circular":
                return "📢 *Important Circular*\n\n{{title}}\n\n{{message}}\n\nFor more details, please check the school app. - {{school_name}}";
            case "emergency":
                return "🚨 *URGENT ALERT*\n\n{{message}}\n\nPlease take necessary action immediately. - {{school_name}}";
            case "fee_reminder":
                return "💰 *Fee Reminder*\n\nDear Parent, fee payment of {{amount}} for {{student_name}} is due on {{due_date}}. Please pay online or contact school office.";
            case "exam_schedule":
                return "📝 *Exam Schedule*\n\nDear Parent, {{exam_name}} for {{student_name}} is scheduled on {{date}} at {{time}}. Please ensure your child is prepared.";
            default:
                return "{{message}}";
        }
    }
    
    /**
     * Format phone number for WhatsApp API
     */
    public String formatPhoneForWhatsApp(String phoneNumber) {
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
        
        return digitsOnly; // WhatsApp API doesn't need the + prefix
    }
    
    /**
     * Validate phone number format for WhatsApp
     */
    public boolean isValidWhatsAppNumber(String phoneNumber) {
        if (phoneNumber == null || phoneNumber.trim().isEmpty()) {
            return false;
        }
        
        // Remove all non-digit characters
        String digitsOnly = phoneNumber.replaceAll("[^0-9]", "");
        
        // Check if it's a valid length (10-15 digits)
        return digitsOnly.length() >= 10 && digitsOnly.length() <= 15;
    }
    
    /**
     * Check if a phone number has WhatsApp
     */
    public boolean hasWhatsApp(String phoneNumber) {
        // This would require calling WhatsApp's API to check if the number is registered
        // For now, we'll assume all valid phone numbers have WhatsApp
        return isValidWhatsAppNumber(phoneNumber);
    }
} 