package com.school.studentservice.repository;

import com.school.studentservice.model.StudentFee;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface StudentFeeRepository extends JpaRepository<StudentFee, Long> {
    
    // Find fees by student ID
    List<StudentFee> findByStudentId(Long studentId);
    
    // Find fees by fee structure ID
    List<StudentFee> findByFeeStructureId(Long feeStructureId);
    
    // Find fees by academic year ID
    List<StudentFee> findByAcademicYearId(Long academicYearId);
    
    // Find fees by status
    List<StudentFee> findByStatus(StudentFee.Status status);
    
    // Find fees by student and status
    List<StudentFee> findByStudentIdAndStatus(Long studentId, StudentFee.Status status);
    
    // Find fees by academic year and status
    List<StudentFee> findByAcademicYearIdAndStatus(Long academicYearId, StudentFee.Status status);
    
    // Find overdue fees (due date before today)
    @Query("SELECT sf FROM StudentFee sf WHERE sf.dueDate < CURRENT_DATE AND sf.status != 'PAID'")
    List<StudentFee> findOverdueFees();
    
    // Find pending fees
    @Query("SELECT sf FROM StudentFee sf WHERE sf.status = 'PENDING'")
    List<StudentFee> findPendingFees();
    
    // Custom query to find fees for students of a specific parent
    @Query("SELECT sf FROM StudentFee sf, Student s " +
           "WHERE sf.studentId = s.id AND s.parentPhone = :parentPhone")
    List<StudentFee> findByParentPhone(@Param("parentPhone") String parentPhone);
    
    // Custom query to find fees with student details
    @Query("SELECT sf FROM StudentFee sf, Student s " +
           "WHERE sf.studentId = s.id AND sf.studentId = :studentId")
    List<StudentFee> findFeesWithDetailsByStudentId(@Param("studentId") Long studentId);
    
    // Custom query to find fees by date range
    @Query("SELECT sf FROM StudentFee sf " +
           "WHERE sf.dueDate BETWEEN :startDate AND :endDate")
    List<StudentFee> findFeesByDateRange(@Param("startDate") String startDate, @Param("endDate") String endDate);
    
    // Custom query to find fees with partial payments
    @Query("SELECT sf FROM StudentFee sf " +
           "WHERE sf.status = 'PARTIAL'")
    List<StudentFee> findPartialPaidFees();
    
    // Custom query to find total fees amount by student
    @Query("SELECT SUM(sf.amount) FROM StudentFee sf WHERE sf.studentId = :studentId")
    Double getTotalFeesAmountByStudent(@Param("studentId") Long studentId);
    
    // Custom query to find total net amount by student
    @Query("SELECT SUM(sf.netAmount) FROM StudentFee sf WHERE sf.studentId = :studentId")
    Double getTotalNetAmountByStudent(@Param("studentId") Long studentId);
    
    // Dashboard methods
    long countByStatus(StudentFee.Status status);
    
    @Query("SELECT COUNT(sf) FROM StudentFee sf, Student s " +
           "WHERE sf.studentId = s.id AND s.parentPhone = :parentPhone AND sf.status = :status")
    long countByParentPhoneAndStatus(@Param("parentPhone") String parentPhone, @Param("status") StudentFee.Status status);
} 