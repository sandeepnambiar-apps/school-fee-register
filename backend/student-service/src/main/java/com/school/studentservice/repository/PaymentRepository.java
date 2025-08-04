package com.school.studentservice.repository;

import com.school.studentservice.model.Payment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface PaymentRepository extends JpaRepository<Payment, Long> {
    
    // Dashboard methods
    @Query("SELECT COALESCE(SUM(p.amount), 0) FROM Payment p")
    double sumTotalAmount();
    
    @Query("SELECT COALESCE(SUM(p.amount), 0) FROM Payment p, StudentFee sf, Student s " +
           "WHERE p.studentFeeId = sf.id AND sf.studentId = s.id AND s.parentPhone = :parentPhone")
    double sumTotalAmountByParentPhone(@Param("parentPhone") String parentPhone);
} 