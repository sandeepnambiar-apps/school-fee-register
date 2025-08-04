package com.school.feeservice.repository;

import com.school.feeservice.model.StudentFee;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface StudentFeeRepository extends JpaRepository<StudentFee, Long> {
    
    List<StudentFee> findByStudentId(Long studentId);
    
    List<StudentFee> findByAcademicYearId(Long academicYearId);
    
    List<StudentFee> findByStatus(StudentFee.Status status);
    
    @Query("SELECT sf FROM StudentFee sf WHERE sf.studentId = :studentId AND sf.academicYearId = :academicYearId")
    List<StudentFee> findByStudentIdAndAcademicYearId(@Param("studentId") Long studentId, 
                                                     @Param("academicYearId") Long academicYearId);
    
    @Query("SELECT sf FROM StudentFee sf WHERE sf.dueDate <= :dueDate AND sf.status = 'PENDING'")
    List<StudentFee> findOverdueFees(@Param("dueDate") LocalDate dueDate);
    
    @Query("SELECT sf FROM StudentFee sf WHERE sf.studentId = :studentId AND sf.status = 'PENDING'")
    List<StudentFee> findPendingFeesByStudent(@Param("studentId") Long studentId);
    
    @Query("SELECT sf FROM StudentFee sf WHERE sf.studentId = :studentId AND sf.status = 'OVERDUE'")
    List<StudentFee> findOverdueFeesByStudent(@Param("studentId") Long studentId);
} 