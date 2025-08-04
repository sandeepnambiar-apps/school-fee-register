package com.school.studentservice.repository;

import com.school.studentservice.model.Fee;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface FeeRepository extends JpaRepository<Fee, Long> {
    
    // Find fees by student ID
    List<Fee> findByStudentId(Long studentId);
    
    // Find fees by class ID
    List<Fee> findByClassId(Long classId);
    
    // Find fees by fee type
    List<Fee> findByFeeType(Fee.FeeType feeType);
    
    // Find fees by status
    List<Fee> findByStatus(Fee.FeeStatus status);
    
    // Find fees by student and status
    List<Fee> findByStudentIdAndStatus(Long studentId, Fee.FeeStatus status);
    
    // Find fees by class and status
    List<Fee> findByClassIdAndStatus(Long classId, Fee.FeeStatus status);
    
    // Find overdue fees (due date before today)
    @Query("SELECT f FROM Fee f WHERE f.dueDate < CURRENT_DATE AND f.status != 'PAID'")
    List<Fee> findOverdueFees();
    
    // Find pending fees
    @Query("SELECT f FROM Fee f WHERE f.status = 'PENDING'")
    List<Fee> findPendingFees();
    
    // Custom query to find fees for students of a specific parent
    @Query("SELECT f FROM Fee f, Student s " +
           "WHERE f.studentId = s.id AND s.parentEmail = :parentEmail")
    List<Fee> findByParentEmail(@Param("parentEmail") String parentEmail);
    
    // Custom query to find fees with student and class details
    @Query("SELECT f FROM Fee f, Student s, Class c " +
           "WHERE f.studentId = s.id AND f.classId = c.id AND f.studentId = :studentId")
    List<Fee> findFeesWithDetailsByStudentId(@Param("studentId") Long studentId);
    
    // Custom query to find fees by date range
    @Query("SELECT f FROM Fee f " +
           "WHERE f.dueDate BETWEEN :startDate AND :endDate")
    List<Fee> findFeesByDateRange(@Param("startDate") String startDate, @Param("endDate") String endDate);
    
    // Custom query to find fees with partial payments
    @Query("SELECT f FROM Fee f " +
           "WHERE f.status = 'PARTIAL'")
    List<Fee> findPartialPaidFees();
    
    // Custom query to find total fees amount by student
    @Query("SELECT SUM(f.amount) FROM Fee f WHERE f.studentId = :studentId")
    Double getTotalFeesAmountByStudent(@Param("studentId") Long studentId);
    
    // Custom query to find total paid amount by student
    @Query("SELECT SUM(f.paidAmount) FROM Fee f WHERE f.studentId = :studentId")
    Double getTotalPaidAmountByStudent(@Param("studentId") Long studentId);
    
    // Dashboard methods
    long countByStatus(Fee.FeeStatus status);
    
    @Query("SELECT COUNT(f) FROM Fee f, Student s " +
           "WHERE f.studentId = s.id AND s.parentPhone = :parentPhone AND f.status = :status")
    long countByParentPhoneAndStatus(@Param("parentPhone") String parentPhone, @Param("status") Fee.FeeStatus status);
} 