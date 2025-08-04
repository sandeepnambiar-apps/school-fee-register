package com.school.studentservice.service;

import com.razorpay.Order;
import com.razorpay.Payment;
import com.razorpay.RazorpayClient;
import com.razorpay.RazorpayException;
import com.school.studentservice.config.RazorpayConfig;
import com.school.studentservice.dto.RazorpayOrderDTO;
import com.school.studentservice.dto.RazorpayPaymentDTO;
import com.school.studentservice.dto.FeeDTO;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;

@Service
public class RazorpayService {
    
    @Autowired
    private RazorpayConfig razorpayConfig;
    
    @Autowired
    private FeeService feeService;
    
    private RazorpayClient razorpayClient;
    
    // Initialize Razorpay client
    private RazorpayClient getRazorpayClient() throws RazorpayException {
        if (razorpayClient == null) {
            razorpayClient = new RazorpayClient(razorpayConfig.getKeyId(), razorpayConfig.getKeySecret());
        }
        return razorpayClient;
    }
    
    // Create order
    public RazorpayOrderDTO createOrder(RazorpayOrderDTO orderDTO) throws RazorpayException {
        try {
            JSONObject orderRequest = new JSONObject();
            orderRequest.put("amount", orderDTO.getAmount().multiply(new BigDecimal("100")).intValue()); // Convert to paise
            orderRequest.put("currency", orderDTO.getCurrency());
            orderRequest.put("receipt", orderDTO.getReceipt());
            orderRequest.put("notes", orderDTO.getNotes());
            
            Order order = getRazorpayClient().orders.create(orderRequest);
            
            RazorpayOrderDTO response = new RazorpayOrderDTO();
            response.setOrderId(order.get("id").toString());
            response.setAmount(orderDTO.getAmount());
            response.setCurrency(orderDTO.getCurrency());
            response.setReceipt(orderDTO.getReceipt());
            response.setNotes(orderDTO.getNotes());
            response.setStudentName(orderDTO.getStudentName());
            response.setFeeType(orderDTO.getFeeType());
            response.setStudentId(orderDTO.getStudentId());
            response.setFeeId(orderDTO.getFeeId());
            response.setParentId(orderDTO.getParentId());
            
            return response;
        } catch (RazorpayException e) {
            throw new RuntimeException("Failed to create Razorpay order: " + e.getMessage());
        }
    }
    
    // Verify payment signature
    public boolean verifyPaymentSignature(String orderId, String paymentId, String signature) {
        try {
            String data = orderId + "|" + paymentId;
            String expectedSignature = org.apache.commons.codec.digest.HmacUtils.hmacSha256Hex(razorpayConfig.getKeySecret(), data);
            return expectedSignature.equals(signature);
        } catch (Exception e) {
            return false;
        }
    }
    
    // Process payment
    public RazorpayPaymentDTO processPayment(RazorpayPaymentDTO paymentDTO) throws RazorpayException {
        try {
            // Verify payment signature
            if (!verifyPaymentSignature(paymentDTO.getOrderId(), paymentDTO.getPaymentId(), paymentDTO.getSignature())) {
                throw new RuntimeException("Invalid payment signature");
            }
            
            // Fetch payment details from Razorpay
            Payment payment = getRazorpayClient().payments.fetch(paymentDTO.getPaymentId());
            
            // Update payment DTO with details from Razorpay
            paymentDTO.setAmount(new BigDecimal(payment.get("amount").toString()).divide(new BigDecimal("100")));
            paymentDTO.setCurrency(payment.get("currency").toString());
            paymentDTO.setStatus(payment.get("status").toString());
            paymentDTO.setMethod(payment.get("method").toString());
            paymentDTO.setDescription(payment.get("description").toString());
            paymentDTO.setEmail(payment.get("email").toString());
            paymentDTO.setContact(payment.get("contact").toString());
            paymentDTO.setName(payment.get("name").toString());
            paymentDTO.setCreatedAt(LocalDateTime.now());
            
            // Update fee status if payment is successful
            if ("captured".equals(paymentDTO.getStatus())) {
                updateFeeStatus(paymentDTO);
            }
            
            return paymentDTO;
        } catch (RazorpayException e) {
            throw new RuntimeException("Failed to process payment: " + e.getMessage());
        }
    }
    
    // Update fee status after successful payment
    private void updateFeeStatus(RazorpayPaymentDTO paymentDTO) {
        try {
            Long feeId = Long.parseLong(paymentDTO.getFeeId());
            FeeDTO fee = feeService.getFeeById(feeId);
            
            // Update paid amount
            BigDecimal currentPaidAmount = fee.getPaidAmount() != null ? fee.getPaidAmount() : BigDecimal.ZERO;
            BigDecimal newPaidAmount = currentPaidAmount.add(paymentDTO.getAmount());
            fee.setPaidAmount(newPaidAmount);
            
            // Update status based on paid amount
            if (newPaidAmount.compareTo(fee.getAmount()) >= 0) {
                fee.setStatus(com.school.studentservice.model.Fee.FeeStatus.PAID);
            } else {
                fee.setStatus(com.school.studentservice.model.Fee.FeeStatus.PARTIAL);
            }
            
            feeService.updateFee(feeId, fee);
        } catch (Exception e) {
            throw new RuntimeException("Failed to update fee status: " + e.getMessage());
        }
    }
    
    // Generate receipt number
    public String generateReceiptNumber() {
        return "RCPT-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
    }
    
    // Get payment status
    public String getPaymentStatus(String paymentId) throws RazorpayException {
        try {
            Payment payment = getRazorpayClient().payments.fetch(paymentId);
            return payment.get("status").toString();
        } catch (RazorpayException e) {
            throw new RuntimeException("Failed to get payment status: " + e.getMessage());
        }
    }
    
    // Refund payment
    public boolean refundPayment(String paymentId, BigDecimal amount, String reason) throws RazorpayException {
        try {
            JSONObject refundRequest = new JSONObject();
            refundRequest.put("amount", amount.multiply(new BigDecimal("100")).intValue()); // Convert to paise
            refundRequest.put("speed", "normal");
            refundRequest.put("notes", reason);
            
            getRazorpayClient().payments.refund(paymentId, refundRequest);
            return true;
        } catch (RazorpayException e) {
            throw new RuntimeException("Failed to refund payment: " + e.getMessage());
        }
    }
} 