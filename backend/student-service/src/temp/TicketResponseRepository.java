package com.school.studentservice.repository;

import com.school.studentservice.model.TicketResponse;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface TicketResponseRepository extends JpaRepository<TicketResponse, Long> {
    
    // Find responses by ticket ID
    List<TicketResponse> findByTicketIdOrderByCreatedAtAsc(Long ticketId);
    
    // Count responses by ticket ID
    long countByTicketId(Long ticketId);
    
    // Find responses by responded by
    List<TicketResponse> findByRespondedBy(String respondedBy);
    
    // Find responses by responded by role
    List<TicketResponse> findByRespondedByRole(String respondedByRole);
} 