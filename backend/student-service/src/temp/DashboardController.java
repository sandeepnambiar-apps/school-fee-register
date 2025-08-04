package com.school.studentservice.controller;

import com.school.studentservice.service.DashboardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/dashboard")
@CrossOrigin(origins = "*")
public class DashboardController {

    @Autowired
    private DashboardService dashboardService;

    @GetMapping("/admin")
    public ResponseEntity<?> getAdminDashboard() {
        try {
            Map<String, Object> dashboardData = dashboardService.getAdminDashboardData();
            return ResponseEntity.ok(dashboardData);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    @GetMapping("/parent")
    public ResponseEntity<?> getParentDashboard(@RequestParam(required = false) String parentPhone) {
        try {
            Map<String, Object> dashboardData = dashboardService.getParentDashboardData(parentPhone);
            return ResponseEntity.ok(dashboardData);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    @GetMapping("/teacher")
    public ResponseEntity<?> getTeacherDashboard(@RequestParam(required = false) String teacherId) {
        try {
            Map<String, Object> dashboardData = dashboardService.getTeacherDashboardData(teacherId);
            return ResponseEntity.ok(dashboardData);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    @GetMapping("/stats")
    public ResponseEntity<?> getRealTimeStats() {
        try {
            Map<String, Object> stats = dashboardService.getRealTimeStats();
            return ResponseEntity.ok(stats);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }
} 