package com.school.service.impl;

import com.school.dto.FeeStructureDTO;
import com.school.dto.StudentFeeDTO;
import com.school.dto.PaymentDTO;
import com.school.service.FeeService;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Collectors;

@Service
public class FeeServiceImpl implements FeeService {

    private final Map<Long, FeeStructureDTO> mockFeeStructures = new ConcurrentHashMap<>();
    private final Map<Long, StudentFeeDTO> mockStudentFees = new ConcurrentHashMap<>();
    private final Map<Long, PaymentDTO> mockPayments = new ConcurrentHashMap<>();

    private long nextFeeStructureId = 1;
    private long nextStudentFeeId = 1;
    private long nextPaymentId = 1;

    public FeeServiceImpl() {
        initializeMockData();
    }

    private void initializeMockData() {
        // Initialize fee structures
        createMockFeeStructure("Tuition Fee", "Class 10", new BigDecimal("500.00"), "monthly");
        createMockFeeStructure("Library Fee", "Class 10", new BigDecimal("50.00"), "yearly");
        createMockFeeStructure("Sports Fee", "Class 10", new BigDecimal("100.00"), "yearly");
        createMockFeeStructure("Tuition Fee", "Class 9", new BigDecimal("450.00"), "monthly");
        createMockFeeStructure("Tuition Fee", "Class 8", new BigDecimal("400.00"), "monthly");

        // Initialize student fees
        createMockStudentFee(1L, 1L, "John Doe", "Tuition Fee", "Class 10", new BigDecimal("500.00"));
        createMockStudentFee(2L, 1L, "Jane Smith", "Tuition Fee", "Class 10", new BigDecimal("500.00"));
        createMockStudentFee(3L, 4L, "Mike Johnson", "Tuition Fee", "Class 9", new BigDecimal("450.00"));

        // Initialize payments
        createMockPayment(1L, new BigDecimal("500.00"), "online", "TXN001", "RCPT001");
        createMockPayment(2L, new BigDecimal("500.00"), "cash", null, "RCPT002");
    }

    private void createMockFeeStructure(String feeName, String className, BigDecimal amount, String frequency) {
        FeeStructureDTO feeStructure = new FeeStructureDTO();
        feeStructure.setId(nextFeeStructureId++);
        feeStructure.setFeeName(feeName);
        feeStructure.setClassName(className);
        feeStructure.setAmount(amount);
        feeStructure.setDescription(feeName + " for " + className);
        feeStructure.setFrequency(frequency);
        feeStructure.setAcademicYear("2024-2025");
        feeStructure.setStatus("ACTIVE");
        feeStructure.setSchoolId(1L); // Demo school ID
        feeStructure.setCreatedAt(LocalDateTime.now());

        mockFeeStructures.put(feeStructure.getId(), feeStructure);
    }

    private void createMockStudentFee(Long studentId, Long feeStructureId, String studentName,
                                      String feeName, String className, BigDecimal amount) {
        StudentFeeDTO studentFee = new StudentFeeDTO();
        studentFee.setId(nextStudentFeeId++);
        studentFee.setStudentId(studentId);
        studentFee.setFeeStructureId(feeStructureId);
        studentFee.setStudentName(studentName);
        studentFee.setFeeName(feeName);
        studentFee.setClassName(className);
        studentFee.setAmount(amount);
        studentFee.setPaidAmount(BigDecimal.ZERO);
        studentFee.setPendingAmount(amount);
        studentFee.setDueDate(LocalDate.now().plusDays(15));
        studentFee.setStatus("PENDING");
        studentFee.setSchoolId(1L); // Demo school ID
        studentFee.setCreatedAt(LocalDateTime.now());

        mockStudentFees.put(studentFee.getId(), studentFee);
    }

    private void createMockPayment(Long studentFeeId, BigDecimal amount, String paymentMethod,
                                   String transactionId, String receiptNumber) {
        PaymentDTO payment = new PaymentDTO();
        payment.setId(nextPaymentId++);
        payment.setStudentFeeId(studentFeeId);
        payment.setAmount(amount);
        payment.setPaymentMethod(paymentMethod);
        payment.setTransactionId(transactionId);
        payment.setReceiptNumber(receiptNumber);
        payment.setStatus("COMPLETED");
        payment.setPaymentDate(LocalDateTime.now());
        payment.setSchoolId(1L); // Demo school ID
        payment.setCreatedAt(LocalDateTime.now());

        mockPayments.put(payment.getId(), payment);

        // Update student fee
        StudentFeeDTO studentFee = mockStudentFees.get(studentFeeId);
        if (studentFee != null) {
            studentFee.setPaidAmount(studentFee.getPaidAmount().add(amount));
            studentFee.setPendingAmount(studentFee.getAmount().subtract(studentFee.getPaidAmount()));
            if (studentFee.getPendingAmount().compareTo(BigDecimal.ZERO) <= 0) {
                studentFee.setStatus("PAID");
            }
        }
    }

    // Fee Structure implementations
    @Override
    public List<FeeStructureDTO> getAllFeeStructures(Long schoolId) {
        if (schoolId == null) {
            return new ArrayList<>();
        }
        return mockFeeStructures.values().stream()
                .filter(fee -> schoolId.equals(fee.getSchoolId()))
                .collect(Collectors.toList());
    }

    @Override
    public FeeStructureDTO getFeeStructureById(Long id, Long schoolId) {
        FeeStructureDTO feeStructure = mockFeeStructures.get(id);
        if (feeStructure == null || !schoolId.equals(feeStructure.getSchoolId())) {
            throw new RuntimeException("Fee structure not found with ID: " + id);
        }
        return feeStructure;
    }

    @Override
    public FeeStructureDTO createFeeStructure(FeeStructureDTO feeStructureDTO) {
        feeStructureDTO.setId(nextFeeStructureId++);
        feeStructureDTO.setCreatedAt(LocalDateTime.now());
        mockFeeStructures.put(feeStructureDTO.getId(), feeStructureDTO);
        return feeStructureDTO;
    }

    @Override
    public FeeStructureDTO updateFeeStructure(FeeStructureDTO feeStructureDTO) {
        FeeStructureDTO existing = mockFeeStructures.get(feeStructureDTO.getId());
        if (existing == null) {
            throw new RuntimeException("Fee structure not found with ID: " + feeStructureDTO.getId());
        }

        existing.setFeeName(feeStructureDTO.getFeeName());
        existing.setClassName(feeStructureDTO.getClassName());
        existing.setAmount(feeStructureDTO.getAmount());
        existing.setDescription(feeStructureDTO.getDescription());
        existing.setFrequency(feeStructureDTO.getFrequency());
        existing.setAcademicYear(feeStructureDTO.getAcademicYear());
        existing.setStatus(feeStructureDTO.getStatus());
        existing.setUpdatedAt(LocalDateTime.now());

        return existing;
    }

    @Override
    public void deleteFeeStructure(Long id) {
        FeeStructureDTO feeStructure = mockFeeStructures.remove(id);
        if (feeStructure == null) {
            throw new RuntimeException("Fee structure not found with ID: " + id);
        }
    }

    // Student Fee implementations
    @Override
    public List<StudentFeeDTO> getAllStudentFees(Long schoolId) {
        if (schoolId == null) {
            return new ArrayList<>();
        }
        return mockStudentFees.values().stream()
                .filter(fee -> schoolId.equals(fee.getSchoolId()))
                .collect(Collectors.toList());
    }

    @Override
    public StudentFeeDTO getStudentFeeById(Long id, Long schoolId) {
        StudentFeeDTO studentFee = mockStudentFees.get(id);
        if (studentFee == null || !schoolId.equals(studentFee.getSchoolId())) {
            throw new RuntimeException("Student fee not found with ID: " + id);
        }
        return studentFee;
    }

    @Override
    public StudentFeeDTO createStudentFee(StudentFeeDTO studentFeeDTO) {
        studentFeeDTO.setId(nextStudentFeeId++);
        studentFeeDTO.setCreatedAt(LocalDateTime.now());
        mockStudentFees.put(studentFeeDTO.getId(), studentFeeDTO);
        return studentFeeDTO;
    }

    @Override
    public StudentFeeDTO updateStudentFee(StudentFeeDTO studentFeeDTO) {
        StudentFeeDTO existing = mockStudentFees.get(studentFeeDTO.getId());
        if (existing == null) {
            throw new RuntimeException("Student fee not found with ID: " + studentFeeDTO.getId());
        }

        existing.setAmount(studentFeeDTO.getAmount());
        existing.setPaidAmount(studentFeeDTO.getPaidAmount());
        existing.setPendingAmount(studentFeeDTO.getPendingAmount());
        existing.setDueDate(studentFeeDTO.getDueDate());
        existing.setStatus(studentFeeDTO.getStatus());
        existing.setUpdatedAt(LocalDateTime.now());

        return existing;
    }

    @Override
    public void deleteStudentFee(Long id) {
        StudentFeeDTO studentFee = mockStudentFees.remove(id);
        if (studentFee == null) {
            throw new RuntimeException("Student fee not found with ID: " + id);
        }
    }

    @Override
    public List<StudentFeeDTO> getFeesByStudentId(Long studentId, Long schoolId) {
        if (schoolId == null) {
            return new ArrayList<>();
        }
        return mockStudentFees.values().stream()
                .filter(fee -> fee.getStudentId().equals(studentId) && schoolId.equals(fee.getSchoolId()))
                .collect(Collectors.toList());
    }

    // Payment implementations
    @Override
    public List<PaymentDTO> getAllPayments(Long schoolId) {
        if (schoolId == null) {
            return new ArrayList<>();
        }
        return mockPayments.values().stream()
                .filter(payment -> schoolId.equals(payment.getSchoolId()))
                .collect(Collectors.toList());
    }

    @Override
    public PaymentDTO getPaymentById(Long id, Long schoolId) {
        PaymentDTO payment = mockPayments.get(id);
        if (payment == null || !schoolId.equals(payment.getSchoolId())) {
            throw new RuntimeException("Payment not found with ID: " + id);
        }
        return payment;
    }

    @Override
    public PaymentDTO createPayment(PaymentDTO paymentDTO) {
        paymentDTO.setId(nextPaymentId++);
        paymentDTO.setCreatedAt(LocalDateTime.now());
        mockPayments.put(paymentDTO.getId(), paymentDTO);
        return paymentDTO;
    }

    @Override
    public PaymentDTO updatePayment(PaymentDTO paymentDTO) {
        PaymentDTO existing = mockPayments.get(paymentDTO.getId());
        if (existing == null) {
            throw new RuntimeException("Payment not found with ID: " + paymentDTO.getId());
        }

        existing.setAmount(paymentDTO.getAmount());
        existing.setPaymentMethod(paymentDTO.getPaymentMethod());
        existing.setTransactionId(paymentDTO.getTransactionId());
        existing.setReceiptNumber(paymentDTO.getReceiptNumber());
        existing.setStatus(paymentDTO.getStatus());
        existing.setRemarks(paymentDTO.getRemarks());
        existing.setUpdatedAt(LocalDateTime.now());

        return existing;
    }

    @Override
    public void deletePayment(Long id) {
        PaymentDTO payment = mockPayments.remove(id);
        if (payment == null) {
            throw new RuntimeException("Payment not found with ID: " + id);
        }
    }

    @Override
    public List<PaymentDTO> getPaymentsByStudentId(Long studentId, Long schoolId) {
        if (schoolId == null) {
            return new ArrayList<>();
        }
        return mockStudentFees.values().stream()
                .filter(fee -> fee.getStudentId().equals(studentId) && schoolId.equals(fee.getSchoolId()))
                .flatMap(fee -> mockPayments.values().stream()
                        .filter(payment -> payment.getStudentFeeId().equals(fee.getId()) && schoolId.equals(payment.getSchoolId())))
                .collect(Collectors.toList());
    }

    @Override
    public PaymentDTO processPayment(PaymentDTO paymentDTO) {
        // Create the payment
        PaymentDTO createdPayment = createPayment(paymentDTO);

        // Update student fee status
        StudentFeeDTO studentFee = mockStudentFees.get(paymentDTO.getStudentFeeId());
        if (studentFee != null) {
            studentFee.setPaidAmount(studentFee.getPaidAmount().add(paymentDTO.getAmount()));
            studentFee.setPendingAmount(studentFee.getAmount().subtract(studentFee.getPaidAmount()));

            if (studentFee.getPendingAmount().compareTo(BigDecimal.ZERO) <= 0) {
                studentFee.setStatus("PAID");
            } else {
                studentFee.setStatus("PARTIALLY_PAID");
            }

            studentFee.setUpdatedAt(LocalDateTime.now());
        }

        return createdPayment;
    }
}
