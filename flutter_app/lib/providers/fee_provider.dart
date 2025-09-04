import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../models/fee_structure.dart';
import '../models/fee_payment.dart';
import 'multi_school_provider.dart';
import '../services/api_service.dart';
import '../services/fee_api_service.dart';
class FeeProvider extends ChangeNotifier {
  List<FeeStructure> _feeStructures = [];
  List<FeePayment> _payments = [];
  bool _isLoading = false;
  String? _error;

  // Storage keys
  static const String _feeStructuresKey = 'fee_structures_data';
  static const String _studentFeesKey = 'student_fees_data';
  static const String _paymentsKey = 'payments_data';
  
  late final ApiService _apiService;
  late final FeeApiService _feeApiService;

  // Get current school ID - simplified approach
  String get _getCurrentSchoolId {
    return '1'; // Default school ID
  }

  // Getters
  List<FeeStructure> get feeStructures => _feeStructures;
  List<FeePayment> get payments => _payments;
  List<FeePayment> get studentFees => _payments; // Alias for payments
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Initialize with persistent storage
  FeeProvider() {
    _initializeServices();
    _loadData();
  }

  void _initializeServices() {
    _apiService = ApiService();
    _apiService.initialize();
    _feeApiService = FeeApiService(_apiService.dio);
  }

  // Load data from API or persistent storage
  Future<void> _loadData() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Get current school ID from MultiSchoolProvider
      // Note: We'll need to access this through context or a different method
      // For now, we'll use a default school ID and load from local storage
      final prefs = await SharedPreferences.getInstance();
      
      // Try to load from API first (when school context is available)
      try {
        // TODO: Get school ID from context when available
        final schoolId = 1; // Default school ID
        final feeStructures = await _feeApiService.getAllFeeStructures(schoolId);
        _feeStructures = feeStructures;
        
        final payments = await _feeApiService.getAllPayments(schoolId);
        _payments = payments;
        
        await _saveData(); // Save to local storage for offline access
      } catch (e) {
        // If API fails, load from local storage
        final feeStructuresJson = prefs.getString(_feeStructuresKey);
        if (feeStructuresJson != null) {
          final List<dynamic> decoded = json.decode(feeStructuresJson);
          _feeStructures = decoded.map((json) => FeeStructure.fromJson(json)).toList();
        } else {
          _loadMockData();
        }
        
        final paymentsJson = prefs.getString(_paymentsKey);
        if (paymentsJson != null) {
          final List<dynamic> decoded = json.decode(paymentsJson);
          _payments = decoded.map((json) => FeePayment.fromJson(json)).toList();
        }
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load fee data: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Save data to persistent storage
  Future<void> _saveData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Save fee structures
      final feeStructuresJson = json.encode(_feeStructures.map((fs) => fs.toJson()).toList());
      await prefs.setString(_feeStructuresKey, feeStructuresJson);
      print('Saved ${_feeStructures.length} fee structures to storage');
      
      // Save payments
      final paymentsJson = json.encode(_payments.map((p) => p.toJson()).toList());
      await prefs.setString(_paymentsKey, paymentsJson);
      print('Saved ${_payments.length} payments to storage');
      
    } catch (e) {
      print('Error saving data to storage: $e');
      _error = 'Failed to save data: $e';
      notifyListeners();
    }
  }

  // Refresh fee data from API
  Future<void> refreshFeeData() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final currentSchoolId = _getCurrentSchoolId;
      final feeStructures = await _feeApiService.getAllFeeStructures(int.parse(currentSchoolId));
      _feeStructures = feeStructures;
      
      final payments = await _feeApiService.getAllPayments(int.parse(currentSchoolId));
      _payments = payments;
      
      await _saveData(); // Save to local storage for offline access
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to refresh fee data: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  void _loadMockData() {
    _feeStructures = [
      FeeStructure(
        id: '1',
        feeType: 'Tuition Fee',
        description: 'Monthly tuition fee for all classes',
        amount: 500.0,
        frequency: 'monthly',
        className: 'All',
        dueDate: DateTime.now().add(const Duration(days: 30)),
        isActive: true,
        schoolId: '1',
        createdAt: DateTime.now(),
      ),
      FeeStructure(
        id: '2',
        feeType: 'Transportation Fee',
        description: 'Monthly transportation fee for bus service',
        amount: 200.0,
        frequency: 'monthly',
        className: 'All',
        dueDate: DateTime.now().add(const Duration(days: 30)),
        isActive: true,
        schoolId: '1',
        createdAt: DateTime.now(),
      ),
      FeeStructure(
        id: '3',
        feeType: 'Library Fee',
        description: 'Annual library membership fee',
        amount: 100.0,
        frequency: 'yearly',
        className: 'All',
        dueDate: DateTime.now().add(const Duration(days: 365)),
        isActive: true,
        schoolId: '1',
        createdAt: DateTime.now(),
      ),
    ];



    _payments = [
      FeePayment(
        id: '1',
        studentId: '1',
        studentName: 'John Doe',
        feeStructureId: '1',
        feeType: 'Tuition Fee',
        amount: 500.0,
        paidAmount: 500.0,
        dueDate: DateTime.parse('2024-01-31'),
        paidDate: DateTime.parse('2024-01-15'),
        status: 'Paid',
        paymentMethod: 'Online',
        transactionId: 'TXN001',
        receiptNumber: 'R001',
        schoolId: '1',
        createdAt: DateTime.now(),
      ),
      FeePayment(
        id: '2',
        studentId: '2',
        studentName: 'Sarah Smith',
        feeStructureId: '1',
        feeType: 'Tuition Fee',
        amount: 500.0,
        paidAmount: 500.0,
        dueDate: DateTime.parse('2024-01-31'),
        paidDate: DateTime.parse('2024-01-20'),
        status: 'Paid',
        paymentMethod: 'Cash',
        transactionId: 'TXN002',
        receiptNumber: 'R002',
        schoolId: '1',
        createdAt: DateTime.now(),
      ),
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
  Future<void> addFeeStructure(Map<String, dynamic> feeData, BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Get current school context
      final multiSchoolProvider = context.read<MultiSchoolProvider>();
      final currentSchoolId = multiSchoolProvider.currentSchoolId;
      
      if (currentSchoolId == null) {
        throw Exception('No school context available');
      }
      
             final newFee = FeeStructure(
         id: DateTime.now().millisecondsSinceEpoch.toString(),
         feeType: feeData['name'] ?? feeData['feeType'] ?? '',
         description: feeData['description'] ?? '',
         amount: (feeData['amount'] ?? 0.0).toDouble(),
         frequency: (feeData['frequency'] ?? 'Monthly').toLowerCase(),
         className: feeData['className'] ?? feeData['class'] ?? 'All',
         dueDate: DateTime.tryParse(feeData['dueDate'] ?? '') ?? DateTime.now().add(const Duration(days: 30)),
         isActive: true,
         schoolId: currentSchoolId,
         createdAt: DateTime.now(),
       );
      
      _feeStructures.add(newFee);
      await _saveData(); // Save to persistent storage
      
      // Verify the data was saved
             print('Fee structure added: ${newFee.feeType} with ID: ${newFee.id}');
      print('Total fee structures: ${_feeStructures.length}');
      
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      print('Error adding fee structure: $e');
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }



  // Record payment
  Future<void> recordPayment(Map<String, dynamic> paymentData, BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Get current school context
      final multiSchoolProvider = context.read<MultiSchoolProvider>();
      final currentSchoolId = multiSchoolProvider.currentSchoolId;
      
      if (currentSchoolId == null) {
        throw Exception('No school context available');
      }
      
      final newPayment = FeePayment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        studentId: paymentData['studentId']?.toString() ?? '',
        studentName: paymentData['studentName'] ?? '',
        feeStructureId: paymentData['feeStructureId']?.toString() ?? '',
        feeType: paymentData['feeType'] ?? '',
        amount: (paymentData['amount'] ?? 0.0).toDouble(),
        paidAmount: (paymentData['paidAmount'] ?? 0.0).toDouble(),
        dueDate: DateTime.tryParse(paymentData['dueDate'] ?? '') ?? DateTime.now(),
        paidDate: paymentData['paidDate'] != null ? DateTime.tryParse(paymentData['paidDate']!) : null,
        status: 'Completed',
        paymentMethod: paymentData['paymentMethod'] ?? 'Cash',
        transactionId: paymentData['transactionId'],
        receiptNumber: paymentData['receiptNumber'],
        notes: paymentData['notes'],
        schoolId: currentSchoolId,
        createdAt: DateTime.now(),
      );
      
      _payments.add(newPayment);
      await _saveData(); // Save to persistent storage
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
  FeeStructure? getFeeStructureById(String id) {
    try {
      return _feeStructures.firstWhere((fee) => fee.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get payments by student ID
  List<FeePayment> getPaymentsByStudentId(String studentId) {
    return _payments.where((payment) => payment.studentId == studentId).toList();
  }

  // Get pending payments
  List<FeePayment> getPendingPayments() {
    return _payments.where((payment) => payment.status == 'Pending').toList();
  }

  // Get paid payments
  List<FeePayment> getPaidPayments() {
    return _payments.where((payment) => payment.status == 'Paid').toList();
  }

  // Get total revenue
  double getTotalRevenue() {
    return _payments.fold(0.0, (sum, payment) => sum + payment.amount);
  }

  // Get pending amount
  double getPendingAmount() {
    return _payments
        .where((payment) => payment.status == 'Pending')
        .fold(0.0, (sum, payment) => sum + payment.amount);
  }

  // Clear all data (for testing/reset)
  Future<void> clearAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_feeStructuresKey);
      await prefs.remove(_paymentsKey);
      
      _feeStructures.clear();
      _payments.clear();
      
      // Reload mock data
      _loadMockData();
      await _saveData();
      
      print('Data cleared and reset to mock data');
      notifyListeners();
    } catch (e) {
      print('Error clearing data: $e');
      _error = 'Failed to clear data: $e';
      notifyListeners();
    }
  }

  // Reset to mock data
  Future<void> resetToMockData() async {
    _loadMockData();
    await _saveData();
    print('Reset to mock data');
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Filter by school context
  void filterBySchoolContext(String? schoolId) {
    if (schoolId == null) {
      // Show all data if no school context
      notifyListeners();
      return;
    }
    
    // Filter fee structures and payments by school
    final filteredFeeStructures = _feeStructures.where((fs) => fs.schoolId == schoolId).toList();
    final filteredPayments = _payments.where((p) => p.schoolId == schoolId).toList();
    
    // Update the filtered lists (you might want to add separate filtered lists)
    notifyListeners();
  }

  // Get fee structures for current school
  List<FeeStructure> getFeeStructuresForCurrentSchool(String? schoolId) {
    if (schoolId == null) return [];
    return _feeStructures.where((fs) => fs.schoolId == schoolId).toList();
  }

  // Add student fee (creates a new payment record)
  Future<void> addStudentFee(Map<String, dynamic> studentFeeData, BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Get current school context
      final multiSchoolProvider = context.read<MultiSchoolProvider>();
      final currentSchoolId = multiSchoolProvider.currentSchoolId;
      
      if (currentSchoolId == null) {
        throw Exception('No school context available');
      }
      
      final newPayment = FeePayment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        studentId: studentFeeData['studentId']?.toString() ?? '',
        studentName: studentFeeData['studentName'] ?? '',
        feeStructureId: studentFeeData['feeStructureId']?.toString() ?? '',
        feeType: studentFeeData['feeType'] ?? '',
        amount: (studentFeeData['amount'] ?? 0.0).toDouble(),
        paidAmount: 0.0, // Initially unpaid
        dueDate: DateTime.tryParse(studentFeeData['dueDate'] ?? '') ?? DateTime.now().add(const Duration(days: 30)),
        paidDate: null, // Not paid yet
        status: 'Pending',
        paymentMethod: 'N/A',
        transactionId: null,
        receiptNumber: null,
        notes: studentFeeData['notes'],
        schoolId: currentSchoolId,
        createdAt: DateTime.now(),
      );
      
      _payments.add(newPayment);
      await _saveData(); // Save to persistent storage
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get payments for current school
  List<FeePayment> getPaymentsForCurrentSchool(String? schoolId) {
    if (schoolId == null) return [];
    return _payments.where((p) => p.schoolId == schoolId).toList();
  }
}


