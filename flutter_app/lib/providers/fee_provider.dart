import 'package:flutter/material.dart';

class FeeProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _feeStructures = [];
  List<Map<String, dynamic>> _studentFees = [];
  List<Map<String, dynamic>> _payments = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Map<String, dynamic>> get feeStructures => _feeStructures;
  List<Map<String, dynamic>> get studentFees => _studentFees;
  List<Map<String, dynamic>> get payments => _payments;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Initialize with mock data
  FeeProvider() {
    _loadMockData();
  }

  void _loadMockData() {
    _feeStructures = [
      {
        'id': 1,
        'name': 'Tuition Fee',
        'description': 'Monthly tuition fee for all classes',
        'amount': 500.0,
        'frequency': 'Monthly',
        'class': 'All',
        'academicYear': '2023-2024',
        'status': 'Active',
      },
      {
        'id': 2,
        'name': 'Transportation Fee',
        'description': 'Monthly transportation fee for bus service',
        'amount': 200.0,
        'frequency': 'Monthly',
        'class': 'All',
        'academicYear': '2023-2024',
        'status': 'Active',
      },
      {
        'id': 3,
        'name': 'Library Fee',
        'description': 'Annual library membership fee',
        'amount': 100.0,
        'frequency': 'Annual',
        'class': 'All',
        'academicYear': '2023-2024',
        'status': 'Active',
      },
    ];

    _studentFees = [
      {
        'id': 1,
        'studentId': 1,
        'studentName': 'John Doe',
        'feeStructureId': 1,
        'feeName': 'Tuition Fee',
        'amount': 500.0,
        'dueDate': '2024-01-31',
        'status': 'Paid',
        'paidAmount': 500.0,
        'paidDate': '2024-01-15',
      },
      {
        'id': 2,
        'studentId': 1,
        'studentName': 'John Doe',
        'feeStructureId': 2,
        'feeName': 'Transportation Fee',
        'amount': 200.0,
        'dueDate': '2024-01-31',
        'status': 'Pending',
        'paidAmount': 0.0,
        'paidDate': null,
      },
      {
        'id': 3,
        'studentId': 2,
        'studentName': 'Sarah Smith',
        'feeStructureId': 1,
        'feeName': 'Tuition Fee',
        'amount': 500.0,
        'dueDate': '2024-01-31',
        'status': 'Paid',
        'paidAmount': 500.0,
        'paidDate': '2024-01-20',
      },
    ];

    _payments = [
      {
        'id': 1,
        'studentId': 1,
        'studentName': 'John Doe',
        'feeId': 1,
        'feeName': 'Tuition Fee',
        'amount': 500.0,
        'paymentDate': '2024-01-15',
        'paymentMethod': 'Online',
        'transactionId': 'TXN001',
        'status': 'Completed',
      },
      {
        'id': 2,
        'studentId': 2,
        'studentName': 'Sarah Smith',
        'feeId': 3,
        'feeName': 'Tuition Fee',
        'amount': 500.0,
        'paymentDate': '2024-01-20',
        'paymentMethod': 'Cash',
        'transactionId': 'TXN002',
        'status': 'Completed',
      },
    ];
  }

  // Load fee structures from API
  Future<void> loadFeeStructures() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));
      _loadMockData();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load student fees from API
  Future<void> loadStudentFees() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));
      _loadMockData();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load payments from API
  Future<void> loadPayments() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));
      _loadMockData();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add new fee structure
  Future<void> addFeeStructure(Map<String, dynamic> feeData) async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      final newFee = {
        ...feeData,
        'id': _feeStructures.length + 1,
        'status': 'Active',
      };
      
      _feeStructures.add(newFee);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add new student fee
  Future<void> addStudentFee(Map<String, dynamic> feeData) async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      final newFee = {
        ...feeData,
        'id': _studentFees.length + 1,
        'status': 'Pending',
        'paidAmount': 0.0,
        'paidDate': null,
      };
      
      _studentFees.add(newFee);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Record payment
  Future<void> recordPayment(Map<String, dynamic> paymentData) async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      final newPayment = {
        ...paymentData,
        'id': _payments.length + 1,
        'status': 'Completed',
      };
      
      _payments.add(newPayment);
      
      // Update student fee status
      final feeIndex = _studentFees.indexWhere((fee) => fee['id'] == paymentData['feeId']);
      if (feeIndex != -1) {
        _studentFees[feeIndex]['status'] = 'Paid';
        _studentFees[feeIndex]['paidAmount'] = paymentData['amount'];
        _studentFees[feeIndex]['paidDate'] = paymentData['paymentDate'];
      }
      
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get fee structure by ID
  Map<String, dynamic>? getFeeStructureById(int id) {
    try {
      return _feeStructures.firstWhere((fee) => fee['id'] == id);
    } catch (e) {
      return null;
    }
  }

  // Get student fees by student ID
  List<Map<String, dynamic>> getStudentFeesByStudentId(int studentId) {
    return _studentFees.where((fee) => fee['studentId'] == studentId).toList();
  }

  // Get payments by student ID
  List<Map<String, dynamic>> getPaymentsByStudentId(int studentId) {
    return _payments.where((payment) => payment['studentId'] == studentId).toList();
  }

  // Get pending fees
  List<Map<String, dynamic>> getPendingFees() {
    return _studentFees.where((fee) => fee['status'] == 'Pending').toList();
  }

  // Get paid fees
  List<Map<String, dynamic>> getPaidFees() {
    return _studentFees.where((fee) => fee['status'] == 'Paid').toList();
  }

  // Get total revenue
  double getTotalRevenue() {
    return _payments.fold(0.0, (sum, payment) => sum + (payment['amount'] as double));
  }

  // Get pending amount
  double getPendingAmount() {
    return _studentFees
        .where((fee) => fee['status'] == 'Pending')
        .fold(0.0, (sum, fee) => sum + (fee['amount'] as double));
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}


