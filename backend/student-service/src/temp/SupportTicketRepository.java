package com.school.studentservice.repository;

import com.school.studentservice.model.SupportTicket;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface SupportTicketRepository extends JpaRepository<SupportTicket, Long> {
    
    // Find tickets by status
    List<SupportTicket> findByStatus(SupportTicket.Status status);
    
    // Find tickets by priority
    List<SupportTicket> findByPriority(SupportTicket.Priority priority);
    
    // Find tickets by category
    List<SupportTicket> findByCategory(String category);
    
    // Find tickets by created by phone (for parents)
    List<SupportTicket> findByCreatedByPhone(String createdByPhone);
    
    // Find tickets by assigned to (for admins)
    List<SupportTicket> findByAssignedTo(String assignedTo);
    
    // Find tickets by status and priority
    List<SupportTicket> findByStatusAndPriority(SupportTicket.Status status, SupportTicket.Priority priority);
    
    // Count tickets by status
    long countByStatus(SupportTicket.Status status);
    
    // Count tickets by priority
    long countByPriority(SupportTicket.Priority priority);
    
    // Count tickets by category
    long countByCategory(String category);
    
    // Find tickets created in last 30 days
    @Query("SELECT t FROM SupportTicket t WHERE t.createdAt >= :startDate")
    List<SupportTicket> findRecentTickets(@Param("startDate") java.time.LocalDateTime startDate);
    
    // Find tickets with no responses
    @Query("SELECT t FROM SupportTicket t WHERE t.id NOT IN (SELECT DISTINCT tr.ticketId FROM TicketResponse tr)")
    List<SupportTicket> findTicketsWithoutResponses();
    
    // Find tickets by multiple statuses
    @Query("SELECT t FROM SupportTicket t WHERE t.status IN :statuses ORDER BY t.createdAt DESC")
    List<SupportTicket> findByStatusIn(@Param("statuses") List<SupportTicket.Status> statuses);
} 