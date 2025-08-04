package com.school.studentservice.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;

@Configuration
public class RazorpayConfig {
    
    @Value("${razorpay.key.id}")
    private String keyId;
    
    @Value("${razorpay.key.secret}")
    private String keySecret;
    
    @Value("${razorpay.currency}")
    private String currency;
    
    @Value("${razorpay.company.name}")
    private String companyName;
    
    @Value("${razorpay.company.description}")
    private String companyDescription;
    
    @Value("${razorpay.company.logo}")
    private String companyLogo;
    
    @Value("${razorpay.company.color}")
    private String companyColor;
    
    public String getKeyId() {
        return keyId;
    }
    
    public void setKeyId(String keyId) {
        this.keyId = keyId;
    }
    
    public String getKeySecret() {
        return keySecret;
    }
    
    public void setKeySecret(String keySecret) {
        this.keySecret = keySecret;
    }
    
    public String getCurrency() {
        return currency;
    }
    
    public void setCurrency(String currency) {
        this.currency = currency;
    }
    
    public String getCompanyName() {
        return companyName;
    }
    
    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }
    
    public String getCompanyDescription() {
        return companyDescription;
    }
    
    public void setCompanyDescription(String companyDescription) {
        this.companyDescription = companyDescription;
    }
    
    public String getCompanyLogo() {
        return companyLogo;
    }
    
    public void setCompanyLogo(String companyLogo) {
        this.companyLogo = companyLogo;
    }
    
    public String getCompanyColor() {
        return companyColor;
    }
    
    public void setCompanyColor(String companyColor) {
        this.companyColor = companyColor;
    }
} 