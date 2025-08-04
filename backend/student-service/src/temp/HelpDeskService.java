package com.school.studentservice.service;

import com.school.studentservice.dto.SupportTicketDTO;
import com.school.studentservice.dto.TicketResponseDTO;
import com.school.studentservice.model.SupportTicket;
import com.school.studentservice.model.TicketResponse;
import com.school.studentservice.repository.SupportTicketRepository;
import com.school.studentservice.repository.TicketResponseRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@Transactional
public class HelpDeskService {
    
    @Autowired
    private SupportTicketRepository supportTicketRepository;
    
    @Autowired
    private TicketResponseRepository ticketResponseRepository;
    
    // Create a new support ticket
    public SupportTicketDTO createTicket(SupportTicketDTO ticketDTO) {
        SupportTicket ticket = new SupportTicket(
            ticketDTO.getTitle(),
            ticketDTO.getDescription(),
            ticketDTO.getCategory(),
            ticketDTO.getPriority(),
            ticketDTO.getCreatedBy(),
            ticketDTO.getCreatedByPhone()
        );
        
        SupportTicket savedTicket = supportTicketRepository.save(ticket);
        return new SupportTicketDTO(savedTicket);
    }
    
    // Get all tickets (for admin)
    public List<SupportTicketDTO> getAllTickets() {
        return supportTicketRepository.findAll().stream()
            .map(this::convertToDTOWithResponses)
            .collect(Collectors.toList());
    }
    
    // Get tickets by user phone (for parents)
    public List<SupportTicketDTO> getTicketsByUserPhone(String userPhone) {
        return supportTicketRepository.findByCreatedByPhone(userPhone).stream()
            .map(this::convertToDTOWithResponses)
            .collect(Collectors.toList());
    }
    
    // Get ticket by ID
    public Optional<SupportTicketDTO> getTicketById(Long ticketId) {
        return supportTicketRepository.findById(ticketId)
            .map(this::convertToDTOWithResponses);
    }
    
    // Update ticket status
    public SupportTicketDTO updateTicketStatus(Long ticketId, SupportTicket.Status status) {
        Optional<SupportTicket> ticketOpt = supportTicketRepository.findById(ticketId);
        if (ticketOpt.isPresent()) {
            SupportTicket ticket = ticketOpt.get();
            ticket.setStatus(status);
            SupportTicket updatedTicket = supportTicketRepository.save(ticket);
            return convertToDTOWithResponses(updatedTicket);
        }
        throw new RuntimeException("Ticket not found with ID: " + ticketId);
    }
    
    // Assign ticket to admin
    public SupportTicketDTO assignTicket(Long ticketId, String assignedTo) {
        Optional<SupportTicket> ticketOpt = supportTicketRepository.findById(ticketId);
        if (ticketOpt.isPresent()) {
            SupportTicket ticket = ticketOpt.get();
            ticket.setAssignedTo(assignedTo);
            ticket.setStatus(SupportTicket.Status.IN_PROGRESS);
            SupportTicket updatedTicket = supportTicketRepository.save(ticket);
            return convertToDTOWithResponses(updatedTicket);
        }
        throw new RuntimeException("Ticket not found with ID: " + ticketId);
    }
    
    // Add response to ticket
    public TicketResponseDTO addResponse(Long ticketId, TicketResponseDTO responseDTO) {
        // Verify ticket exists
        if (!supportTicketRepository.existsById(ticketId)) {
            throw new RuntimeException("Ticket not found with ID: " + ticketId);
        }
        
        TicketResponse response = new TicketResponse(
            ticketId,
            responseDTO.getMessage(),
            responseDTO.getRespondedBy(),
            responseDTO.getRespondedByRole()
        );
        
        TicketResponse savedResponse = ticketResponseRepository.save(response);
        
        // Update ticket status if admin is responding
        if ("ADMIN".equals(responseDTO.getRespondedByRole())) {
            updateTicketStatus(ticketId, SupportTicket.Status.IN_PROGRESS);
        }
        
        return new TicketResponseDTO(savedResponse);
    }
    
    // Get responses for a ticket
    public List<TicketResponseDTO> getTicketResponses(Long ticketId) {
        return ticketResponseRepository.findByTicketIdOrderByCreatedAtAsc(ticketId).stream()
            .map(TicketResponseDTO::new)
            .collect(Collectors.toList());
    }
    
    // Get tickets by status
    public List<SupportTicketDTO> getTicketsByStatus(SupportTicket.Status status) {
        return supportTicketRepository.findByStatus(status).stream()
            .map(this::convertToDTOWithResponses)
            .collect(Collectors.toList());
    }
    
    // Get tickets by priority
    public List<SupportTicketDTO> getTicketsByPriority(SupportTicket.Priority priority) {
        return supportTicketRepository.findByPriority(priority).stream()
            .map(this::convertToDTOWithResponses)
            .collect(Collectors.toList());
    }
    
    // Get tickets by category
    public List<SupportTicketDTO> getTicketsByCategory(String category) {
        return supportTicketRepository.findByCategory(category).stream()
            .map(this::convertToDTOWithResponses)
            .collect(Collectors.toList());
    }
    
    // Get recent tickets (last 30 days)
    public List<SupportTicketDTO> getRecentTickets() {
        LocalDateTime startDate = LocalDateTime.now().minusDays(30);
        return supportTicketRepository.findRecentTickets(startDate).stream()
            .map(this::convertToDTOWithResponses)
            .collect(Collectors.toList());
    }
    
    // Get tickets without responses
    public List<SupportTicketDTO> getTicketsWithoutResponses() {
        return supportTicketRepository.findTicketsWithoutResponses().stream()
            .map(this::convertToDTOWithResponses)
            .collect(Collectors.toList());
    }
    
    // Get ticket statistics
    public TicketStatistics getTicketStatistics() {
        TicketStatistics stats = new TicketStatistics();
        stats.setTotalTickets(supportTicketRepository.count());
        stats.setOpenTickets(supportTicketRepository.countByStatus(SupportTicket.Status.OPEN));
        stats.setInProgressTickets(supportTicketRepository.countByStatus(SupportTicket.Status.IN_PROGRESS));
        stats.setResolvedTickets(supportTicketRepository.countByStatus(SupportTicket.Status.RESOLVED));
        stats.setClosedTickets(supportTicketRepository.countByStatus(SupportTicket.Status.CLOSED));
        stats.setUrgentTickets(supportTicketRepository.countByPriority(SupportTicket.Priority.URGENT));
        stats.setHighPriorityTickets(supportTicketRepository.countByPriority(SupportTicket.Priority.HIGH));
        return stats;
    }
    
    // Helper method to convert entity to DTO with responses
    private SupportTicketDTO convertToDTOWithResponses(SupportTicket ticket) {
        SupportTicketDTO dto = new SupportTicketDTO(ticket);
        List<TicketResponseDTO> responses = getTicketResponses(ticket.getId());
        dto.setResponses(responses);
        return dto;
    }
    
    // Inner class for statistics
    public static class TicketStatistics {
        private long totalTickets;
        private long openTickets;
        private long inProgressTickets;
        private long resolvedTickets;
        private long closedTickets;
        private long urgentTickets;
        private long highPriorityTickets;
        
        // Getters and Setters
        public long getTotalTickets() { return totalTickets; }
        public void setTotalTickets(long totalTickets) { this.totalTickets = totalTickets; }
        
        public long getOpenTickets() { return openTickets; }
        public void setOpenTickets(long openTickets) { this.openTickets = openTickets; }
        
        public long getInProgressTickets() { return inProgressTickets; }
        public void setInProgressTickets(long inProgressTickets) { this.inProgressTickets = inProgressTickets; }
        
        public long getResolvedTickets() { return resolvedTickets; }
        public void setResolvedTickets(long resolvedTickets) { this.resolvedTickets = resolvedTickets; }
        
        public long getClosedTickets() { return closedTickets; }
        public void setClosedTickets(long closedTickets) { this.closedTickets = closedTickets; }
        
        public long getUrgentTickets() { return urgentTickets; }
        public void setUrgentTickets(long urgentTickets) { this.urgentTickets = urgentTickets; }
        
        public long getHighPriorityTickets() { return highPriorityTickets; }
        public void setHighPriorityTickets(long highPriorityTickets) { this.highPriorityTickets = highPriorityTickets; }
    }
} 