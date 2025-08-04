package com.school.studentservice.service;

import com.school.studentservice.repository.StudentRepository;
import com.school.studentservice.repository.StudentFeeRepository;
import com.school.studentservice.repository.FeeRepository;
import com.school.studentservice.repository.PaymentRepository;
import com.school.studentservice.repository.FeeStructureRepository;
import com.school.studentservice.model.StudentFee;
import com.school.studentservice.model.Fee;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

@Service
public class DashboardService {

    @Autowired
    private StudentRepository studentRepository;

        @Autowired
    private StudentFeeRepository studentFeeRepository;
    
    @Autowired
    private FeeRepository feeRepository;
    
    @Autowired
    private PaymentRepository paymentRepository;

    @Autowired
    private FeeStructureRepository feeStructureRepository;

    public Map<String, Object> getAdminDashboardData() {
        Map<String, Object> dashboardData = new HashMap<>();
        
        try {
            // Get real statistics from database
            long totalStudents = studentRepository.countByIsActive(true);
            double totalFeesCollected = paymentRepository.sumTotalAmount();
            long pendingPayments = feeRepository.countByStatus(Fee.FeeStatus.PENDING);
            long activeFeeStructures = feeStructureRepository.countByIsActive(true);

            // Create stats object
            Map<String, Object> stats = new HashMap<>();
            stats.put("totalStudents", totalStudents);
            stats.put("totalFeesCollected", totalFeesCollected);
            stats.put("pendingPayments", pendingPayments);
            stats.put("activeFeeStructures", activeFeeStructures);

            // Create recent activities
            List<Map<String, Object>> recentActivities = getRecentActivities();

            dashboardData.put("stats", stats);
            dashboardData.put("recentActivities", recentActivities);

        } catch (Exception e) {
            // Fallback to default data if database query fails
            Map<String, Object> stats = new HashMap<>();
            stats.put("totalStudents", 0);
            stats.put("totalFeesCollected", 0.0);
            stats.put("pendingPayments", 0);
            stats.put("activeFeeStructures", 0);

            List<Map<String, Object>> recentActivities = getDefaultActivities();

            dashboardData.put("stats", stats);
            dashboardData.put("recentActivities", recentActivities);
        }

        return dashboardData;
    }

    public Map<String, Object> getParentDashboardData(String parentPhone) {
        Map<String, Object> dashboardData = new HashMap<>();
        
        try {
            // Get parent-specific data
            long myChildren = studentRepository.countByParentPhone(parentPhone);
            double totalFeesPaid = paymentRepository.sumTotalAmountByParentPhone(parentPhone);
            long pendingPayments = feeRepository.countByParentPhoneAndStatus(parentPhone, Fee.FeeStatus.PENDING);
            long recentNotifications = 3; // Placeholder for notifications

            // Create stats object
            Map<String, Object> stats = new HashMap<>();
            stats.put("myChildren", myChildren);
            stats.put("totalFeesPaid", totalFeesPaid);
            stats.put("pendingPayments", pendingPayments);
            stats.put("recentNotifications", recentNotifications);

            // Create recent activities for parent
            List<Map<String, Object>> recentActivities = getParentActivities(parentPhone);

            dashboardData.put("stats", stats);
            dashboardData.put("recentActivities", recentActivities);

        } catch (Exception e) {
            // Fallback to default data
            Map<String, Object> stats = new HashMap<>();
            stats.put("myChildren", 0);
            stats.put("totalFeesPaid", 0.0);
            stats.put("pendingPayments", 0);
            stats.put("recentNotifications", 0);

            List<Map<String, Object>> recentActivities = getDefaultParentActivities();

            dashboardData.put("stats", stats);
            dashboardData.put("recentActivities", recentActivities);
        }

        return dashboardData;
    }

    public Map<String, Object> getTeacherDashboardData(String teacherId) {
        Map<String, Object> dashboardData = new HashMap<>();
        
        try {
            // Get teacher-specific data (placeholder for now)
            long myStudents = 45; // Placeholder
            long activeHomework = 8; // Placeholder
            long pendingAssignments = 12; // Placeholder
            long recentNotifications = 5; // Placeholder

            // Create stats object
            Map<String, Object> stats = new HashMap<>();
            stats.put("myStudents", myStudents);
            stats.put("activeHomework", activeHomework);
            stats.put("pendingAssignments", pendingAssignments);
            stats.put("recentNotifications", recentNotifications);

            // Create recent activities for teacher
            List<Map<String, Object>> recentActivities = getTeacherActivities();

            dashboardData.put("stats", stats);
            dashboardData.put("recentActivities", recentActivities);

        } catch (Exception e) {
            // Fallback to default data
            Map<String, Object> stats = new HashMap<>();
            stats.put("myStudents", 0);
            stats.put("activeHomework", 0);
            stats.put("pendingAssignments", 0);
            stats.put("recentNotifications", 0);

            List<Map<String, Object>> recentActivities = getDefaultTeacherActivities();

            dashboardData.put("stats", stats);
            dashboardData.put("recentActivities", recentActivities);
        }

        return dashboardData;
    }

    public Map<String, Object> getRealTimeStats() {
        Map<String, Object> stats = new HashMap<>();
        
        try {
            long totalStudents = studentRepository.countByIsActive(true);
            double totalFeesCollected = paymentRepository.sumTotalAmount();
            long pendingPayments = feeRepository.countByStatus(Fee.FeeStatus.PENDING);
            long activeFeeStructures = feeStructureRepository.countByIsActive(true);

            stats.put("totalStudents", totalStudents);
            stats.put("totalFeesCollected", totalFeesCollected);
            stats.put("pendingPayments", pendingPayments);
            stats.put("activeFeeStructures", activeFeeStructures);
            stats.put("lastUpdated", LocalDateTime.now().format(DateTimeFormatter.ISO_LOCAL_DATE_TIME));

        } catch (Exception e) {
            stats.put("error", "Failed to fetch real-time stats");
        }

        return stats;
    }

    private List<Map<String, Object>> getRecentActivities() {
        List<Map<String, Object>> activities = new ArrayList<>();
        
        // Add some sample activities based on recent data
        Map<String, Object> activity1 = new HashMap<>();
        activity1.put("id", "1");
        activity1.put("text", "New student registration: John Doe");
        activity1.put("time", "2 minutes ago");
        activity1.put("type", "registration");
        activities.add(activity1);

        Map<String, Object> activity2 = new HashMap<>();
        activity2.put("id", "2");
        activity2.put("text", "Payment received: $500 from Student ID 123");
        activity2.put("time", "5 minutes ago");
        activity2.put("type", "payment");
        activities.add(activity2);

        Map<String, Object> activity3 = new HashMap<>();
        activity3.put("id", "3");
        activity3.put("text", "Fee structure updated for Class 10");
        activity3.put("time", "10 minutes ago");
        activity3.put("type", "notification");
        activities.add(activity3);

        return activities;
    }

    private List<Map<String, Object>> getParentActivities(String parentPhone) {
        List<Map<String, Object>> activities = new ArrayList<>();
        
        Map<String, Object> activity1 = new HashMap<>();
        activity1.put("id", "1");
        activity1.put("text", "New homework assigned: Mathematics Chapter 5");
        activity1.put("time", "2 hours ago");
        activity1.put("type", "homework");
        activities.add(activity1);

        Map<String, Object> activity2 = new HashMap<>();
        activity2.put("id", "2");
        activity2.put("text", "Fee payment received: $500 for March 2024");
        activity2.put("time", "1 day ago");
        activity2.put("type", "payment");
        activities.add(activity2);

        return activities;
    }

    private List<Map<String, Object>> getTeacherActivities() {
        List<Map<String, Object>> activities = new ArrayList<>();
        
        Map<String, Object> activity1 = new HashMap<>();
        activity1.put("id", "1");
        activity1.put("text", "Homework submitted by: John Doe");
        activity1.put("time", "30 minutes ago");
        activity1.put("type", "homework");
        activities.add(activity1);

        Map<String, Object> activity2 = new HashMap<>();
        activity2.put("id", "2");
        activity2.put("text", "New student assigned to your class");
        activity2.put("time", "2 hours ago");
        activity2.put("type", "registration");
        activities.add(activity2);

        return activities;
    }

    private List<Map<String, Object>> getDefaultActivities() {
        return getRecentActivities();
    }

    private List<Map<String, Object>> getDefaultParentActivities() {
        return getParentActivities(null);
    }

    private List<Map<String, Object>> getDefaultTeacherActivities() {
        return getTeacherActivities();
    }
} 