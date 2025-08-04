package com.school.feeservice.repository;

import com.school.feeservice.model.Payment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface PaymentRepository extends JpaRepository<Payment, Long> {
    
    List<Payment> findByStudentId(Long studentId);
    
    List<Payment> findByStudentIdAndStatus(Long studentId, Payment.PaymentStatus status);
    
    List<Payment> findByStatus(Payment.PaymentStatus status);
    
    Optional<Payment> findByTransactionId(String transactionId);
    
    Optional<Payment> findByReceiptNumber(String receiptNumber);
    
    @Query("SELECT p FROM Payment p WHERE p.studentId = :studentId AND p.paymentDate BETWEEN :startDate AND :endDate")
    List<Payment> findByStudentIdAndDateRange(@Param("studentId") Long studentId, 
                                             @Param("startDate") LocalDateTime startDate, 
                                             @Param("endDate") LocalDateTime endDate);
    
    @Query("SELECT p FROM Payment p WHERE p.paymentDate BETWEEN :startDate AND :endDate")
    List<Payment> findByDateRange(@Param("startDate") LocalDateTime startDate, 
                                 @Param("endDate") LocalDateTime endDate);
    
    @Query("SELECT p FROM Payment p WHERE p.dueDate < :currentDate AND p.status = 'PENDING'")
    List<Payment> findOverduePayments(@Param("currentDate") LocalDateTime currentDate);
    
    @Query("SELECT COUNT(p) FROM Payment p WHERE p.studentId = :studentId AND p.status = 'COMPLETED'")
    Long countCompletedPaymentsByStudent(@Param("studentId") Long studentId);
    
    @Query("SELECT SUM(p.amount) FROM Payment p WHERE p.studentId = :studentId AND p.status = 'COMPLETED'")
    Double getTotalPaidAmountByStudent(@Param("studentId") Long studentId);
} 