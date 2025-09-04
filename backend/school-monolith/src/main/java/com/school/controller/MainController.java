package com.school.controller;

import com.school.dto.LoginResponseDTO;
import com.school.service.AuthService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api")
@CrossOrigin(origins = "*")
@RequiredArgsConstructor
public class MainController {

    private final AuthService authService;

    /**
     * Main entry point for the app - returns dashboard data and navigation
     */
    @GetMapping("/dashboard")
    public ResponseEntity<Map<String, Object>> getDashboard(@RequestHeader(value = "Authorization", required = false) String authHeader) {
        Map<String, Object> dashboard = new HashMap<>();
        
        try {
            if (authHeader != null && authHeader.startsWith("Bearer ")) {
                String token = authHeader.substring(7);
                if (authService.validateToken(token)) {
                    // User is authenticated, return full dashboard
                    dashboard.put("authenticated", true);
                    dashboard.put("message", "Welcome to Kidsy School Management System");
                    dashboard.put("status", "success");
                    
                    // Navigation endpoints
                    Map<String, String> endpoints = new HashMap<>();
                    endpoints.put("students", "/api/students");
                    endpoints.put("fees", "/api/fees/structures");
                    endpoints.put("homework", "/api/homework/assignments");
                    endpoints.put("notifications", "/api/notifications");
                    endpoints.put("reports", "/api/reports");
                    endpoints.put("profile", "/api/auth/profile");
                    endpoints.put("logout", "/api/auth/logout");
                    
                    dashboard.put("endpoints", endpoints);
                    
                    // Quick stats
                    Map<String, Object> stats = new HashMap<>();
                    stats.put("totalStudents", 5);
                    stats.put("totalFees", 3);
                    stats.put("totalHomework", 4);
                    stats.put("pendingPayments", 2);
                    
                    dashboard.put("stats", stats);
                    
                } else {
                    dashboard.put("authenticated", false);
                    dashboard.put("message", "Invalid or expired token");
                    dashboard.put("status", "error");
                    dashboard.put("loginEndpoint", "/api/auth/login");
                }
            } else {
                dashboard.put("authenticated", false);
                dashboard.put("message", "Authentication required");
                dashboard.put("status", "error");
                dashboard.put("loginEndpoint", "/api/auth/login");
            }
            
        } catch (Exception e) {
            dashboard.put("authenticated", false);
            dashboard.put("message", "Error: " + e.getMessage());
            dashboard.put("status", "error");
            dashboard.put("loginEndpoint", "/api/auth/login");
        }
        
        return ResponseEntity.ok(dashboard);
    }

    /**
     * App info and status
     */
    @GetMapping("/info")
    public ResponseEntity<Map<String, Object>> getAppInfo() {
        Map<String, Object> info = new HashMap<>();
        info.put("appName", "Kidsy School Management System");
        info.put("version", "1.0.0");
        info.put("description", "Consolidated School Management System");
        info.put("mainEndpoint", "/api/dashboard");
        info.put("status", "running");
        
        return ResponseEntity.ok(info);
    }

    /**
     * Health check for the app
     */
    @GetMapping("/health")
    public ResponseEntity<Map<String, Object>> getHealth() {
        Map<String, Object> health = new HashMap<>();
        health.put("status", "UP");
        health.put("service", "Kidsy School Management System");
        health.put("timestamp", System.currentTimeMillis());
        
        return ResponseEntity.ok(health);
    }
}


