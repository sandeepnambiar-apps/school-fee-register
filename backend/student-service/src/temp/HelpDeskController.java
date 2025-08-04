package com.school.studentservice.controller;

import com.school.studentservice.dto.SupportTicketDTO;
import com.school.studentservice.dto.TicketResponseDTO;
import com.school.studentservice.model.SupportTicket;
import com.school.studentservice.service.HelpDeskService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/help-desk")
@CrossOrigin(origins = "*")
public class HelpDeskController {
    
    @Autowired
    private HelpDeskService helpDeskService;
    
    // Create a new support ticket
    @PostMapping("/tickets")
    public ResponseEntity<SupportTicketDTO> createTicket(@RequestBody SupportTicketDTO ticketDTO) {
        try {
            SupportTicketDTO createdTicket = helpDeskService.createTicket(ticketDTO);
            return ResponseEntity.ok(createdTicket);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }
    
    // Get all tickets (for admin)
    @GetMapping("/tickets")
    public ResponseEntity<List<SupportTicketDTO>> getAllTickets() {
        try {
            List<SupportTicketDTO> tickets = helpDeskService.getAllTickets();
            return ResponseEntity.ok(tickets);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    // Get tickets by user phone (for parents)
    @GetMapping("/tickets/user/{userPhone}")
    public ResponseEntity<List<SupportTicketDTO>> getTicketsByUserPhone(@PathVariable String userPhone) {
        try {
            List<SupportTicketDTO> tickets = helpDeskService.getTicketsByUserPhone(userPhone);
            return ResponseEntity.ok(tickets);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    // Get ticket by ID
    @GetMapping("/tickets/{ticketId}")
    public ResponseEntity<SupportTicketDTO> getTicketById(@PathVariable Long ticketId) {
        try {
            return helpDeskService.getTicketById(ticketId)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    // Update ticket status
    @PutMapping("/tickets/{ticketId}/status")
    public ResponseEntity<SupportTicketDTO> updateTicketStatus(
            @PathVariable Long ticketId,
            @RequestBody Map<String, String> request) {
        try {
            String statusStr = request.get("status");
            SupportTicket.Status status = SupportTicket.Status.valueOf(statusStr);
            SupportTicketDTO updatedTicket = helpDeskService.updateTicketStatus(ticketId, status);
            return ResponseEntity.ok(updatedTicket);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }
    
    // Assign ticket to admin
    @PutMapping("/tickets/{ticketId}/assign")
    public ResponseEntity<SupportTicketDTO> assignTicket(
            @PathVariable Long ticketId,
            @RequestBody Map<String, String> request) {
        try {
            String assignedTo = request.get("assignedTo");
            SupportTicketDTO updatedTicket = helpDeskService.assignTicket(ticketId, assignedTo);
            return ResponseEntity.ok(updatedTicket);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }
    
    // Add response to ticket
    @PostMapping("/tickets/{ticketId}/responses")
    public ResponseEntity<TicketResponseDTO> addResponse(
            @PathVariable Long ticketId,
            @RequestBody TicketResponseDTO responseDTO) {
        try {
            TicketResponseDTO createdResponse = helpDeskService.addResponse(ticketId, responseDTO);
            return ResponseEntity.ok(createdResponse);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }
    
    // Get responses for a ticket
    @GetMapping("/tickets/{ticketId}/responses")
    public ResponseEntity<List<TicketResponseDTO>> getTicketResponses(@PathVariable Long ticketId) {
        try {
            List<TicketResponseDTO> responses = helpDeskService.getTicketResponses(ticketId);
            return ResponseEntity.ok(responses);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    // Get tickets by status
    @GetMapping("/tickets/status/{status}")
    public ResponseEntity<List<SupportTicketDTO>> getTicketsByStatus(@PathVariable String status) {
        try {
            SupportTicket.Status ticketStatus = SupportTicket.Status.valueOf(status.toUpperCase());
            List<SupportTicketDTO> tickets = helpDeskService.getTicketsByStatus(ticketStatus);
            return ResponseEntity.ok(tickets);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }
    
    // Get tickets by priority
    @GetMapping("/tickets/priority/{priority}")
    public ResponseEntity<List<SupportTicketDTO>> getTicketsByPriority(@PathVariable String priority) {
        try {
            SupportTicket.Priority ticketPriority = SupportTicket.Priority.valueOf(priority.toUpperCase());
            List<SupportTicketDTO> tickets = helpDeskService.getTicketsByPriority(ticketPriority);
            return ResponseEntity.ok(tickets);
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }
    
    // Get tickets by category
    @GetMapping("/tickets/category/{category}")
    public ResponseEntity<List<SupportTicketDTO>> getTicketsByCategory(@PathVariable String category) {
        try {
            List<SupportTicketDTO> tickets = helpDeskService.getTicketsByCategory(category);
            return ResponseEntity.ok(tickets);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    // Get recent tickets
    @GetMapping("/tickets/recent")
    public ResponseEntity<List<SupportTicketDTO>> getRecentTickets() {
        try {
            List<SupportTicketDTO> tickets = helpDeskService.getRecentTickets();
            return ResponseEntity.ok(tickets);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    // Get tickets without responses
    @GetMapping("/tickets/unresponded")
    public ResponseEntity<List<SupportTicketDTO>> getTicketsWithoutResponses() {
        try {
            List<SupportTicketDTO> tickets = helpDeskService.getTicketsWithoutResponses();
            return ResponseEntity.ok(tickets);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    // Get ticket statistics
    @GetMapping("/statistics")
    public ResponseEntity<HelpDeskService.TicketStatistics> getTicketStatistics() {
        try {
            HelpDeskService.TicketStatistics stats = helpDeskService.getTicketStatistics();
            return ResponseEntity.ok(stats);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
    
    // Get available categories
    @GetMapping("/categories")
    public ResponseEntity<List<String>> getCategories() {
        List<String> categories = List.of(
            "Fee Related",
            "Academic",
            "Technical",
            "Transport",
            "General",
            "Complaint",
            "Suggestion"
        );
        return ResponseEntity.ok(categories);
    }
    
    // Get available priorities
    @GetMapping("/priorities")
    public ResponseEntity<List<String>> getPriorities() {
        List<String> priorities = List.of("LOW", "MEDIUM", "HIGH", "URGENT");
        return ResponseEntity.ok(priorities);
    }
    
    // Get available statuses
    @GetMapping("/statuses")
    public ResponseEntity<List<String>> getStatuses() {
        List<String> statuses = List.of("OPEN", "IN_PROGRESS", "RESOLVED", "CLOSED");
        return ResponseEntity.ok(statuses);
    }
} 