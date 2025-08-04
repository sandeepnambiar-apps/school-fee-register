package com.school.studentservice.controller;

import com.school.studentservice.dto.RazorpayOrderDTO;
import com.school.studentservice.dto.RazorpayPaymentDTO;
import com.school.studentservice.service.RazorpayService;
import com.school.studentservice.config.RazorpayConfig;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/razorpay")
@CrossOrigin(origins = "*")
public class RazorpayController {
    
    @Autowired
    private RazorpayService razorpayService;
    
    @Autowired
    private RazorpayConfig razorpayConfig;
    
    // Create order
    @PostMapping("/create-order")
    public ResponseEntity<Map<String, Object>> createOrder(@RequestBody RazorpayOrderDTO orderDTO) {
        try {
            RazorpayOrderDTO order = razorpayService.createOrder(orderDTO);
            
            Map<String, Object> response = new HashMap<>();
            response.put("orderId", order.getOrderId());
            response.put("amount", order.getAmount());
            response.put("currency", order.getCurrency());
            response.put("keyId", razorpayConfig.getKeyId());
            response.put("studentName", order.getStudentName());
            response.put("feeType", order.getFeeType());
            response.put("receipt", order.getReceipt());
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> error = new HashMap<>();
            error.put("error", "Failed to create order: " + e.getMessage());
            return ResponseEntity.badRequest().body(error);
        }
    }
    
    // Process payment
    @PostMapping("/process-payment")
    public ResponseEntity<Map<String, Object>> processPayment(@RequestBody RazorpayPaymentDTO paymentDTO) {
        try {
            RazorpayPaymentDTO payment = razorpayService.processPayment(paymentDTO);
            
            Map<String, Object> response = new HashMap<>();
            response.put("paymentId", payment.getPaymentId());
            response.put("orderId", payment.getOrderId());
            response.put("status", payment.getStatus());
            response.put("amount", payment.getAmount());
            response.put("method", payment.getMethod());
            response.put("message", "Payment processed successfully");
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> error = new HashMap<>();
            error.put("error", "Failed to process payment: " + e.getMessage());
            return ResponseEntity.badRequest().body(error);
        }
    }
    
    // Get payment status
    @GetMapping("/payment-status/{paymentId}")
    public ResponseEntity<Map<String, Object>> getPaymentStatus(@PathVariable String paymentId) {
        try {
            String status = razorpayService.getPaymentStatus(paymentId);
            
            Map<String, Object> response = new HashMap<>();
            response.put("paymentId", paymentId);
            response.put("status", status);
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> error = new HashMap<>();
            error.put("error", "Failed to get payment status: " + e.getMessage());
            return ResponseEntity.badRequest().body(error);
        }
    }
    
    // Refund payment
    @PostMapping("/refund")
    public ResponseEntity<Map<String, Object>> refundPayment(@RequestBody Map<String, Object> refundRequest) {
        try {
            String paymentId = (String) refundRequest.get("paymentId");
            Double amount = (Double) refundRequest.get("amount");
            String reason = (String) refundRequest.get("reason");
            
            boolean success = razorpayService.refundPayment(paymentId, 
                new java.math.BigDecimal(amount.toString()), reason);
            
            Map<String, Object> response = new HashMap<>();
            response.put("success", success);
            response.put("message", success ? "Refund processed successfully" : "Refund failed");
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> error = new HashMap<>();
            error.put("error", "Failed to process refund: " + e.getMessage());
            return ResponseEntity.badRequest().body(error);
        }
    }
    
    // Get Razorpay configuration for frontend
    @GetMapping("/config")
    public ResponseEntity<Map<String, Object>> getConfig() {
        Map<String, Object> config = new HashMap<>();
        config.put("keyId", razorpayConfig.getKeyId());
        config.put("currency", razorpayConfig.getCurrency());
        config.put("companyName", razorpayConfig.getCompanyName());
        config.put("companyDescription", razorpayConfig.getCompanyDescription());
        config.put("companyLogo", razorpayConfig.getCompanyLogo());
        config.put("companyColor", razorpayConfig.getCompanyColor());
        
        return ResponseEntity.ok(config);
    }
} 