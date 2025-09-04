package com.school.service;

import com.school.dto.FeeStructureDTO;
import com.school.dto.StudentFeeDTO;
import com.school.dto.PaymentDTO;

import java.util.List;

public interface FeeService {

    // Fee Structure operations
    List<FeeStructureDTO> getAllFeeStructures(Long schoolId);

    FeeStructureDTO getFeeStructureById(Long id, Long schoolId);

    FeeStructureDTO createFeeStructure(FeeStructureDTO feeStructureDTO);

    FeeStructureDTO updateFeeStructure(FeeStructureDTO feeStructureDTO);

    void deleteFeeStructure(Long id);

    // Student Fee operations
    List<StudentFeeDTO> getAllStudentFees(Long schoolId);

    StudentFeeDTO getStudentFeeById(Long id, Long schoolId);

    StudentFeeDTO createStudentFee(StudentFeeDTO studentFeeDTO);

    StudentFeeDTO updateStudentFee(StudentFeeDTO studentFeeDTO);

    void deleteStudentFee(Long id);

    List<StudentFeeDTO> getFeesByStudentId(Long studentId, Long schoolId);

    // Payment operations
    List<PaymentDTO> getAllPayments(Long schoolId);

    PaymentDTO getPaymentById(Long id, Long schoolId);

    PaymentDTO createPayment(PaymentDTO paymentDTO);

    PaymentDTO updatePayment(PaymentDTO paymentDTO);

    void deletePayment(Long id);

    List<PaymentDTO> getPaymentsByStudentId(Long studentId, Long schoolId);

    PaymentDTO processPayment(PaymentDTO paymentDTO);
}
