import 'package:dio/dio.dart';
import '../models/fee_structure.dart';
import '../models/fee_payment.dart';

class FeeApiService {
  final Dio _dio;

  FeeApiService(this._dio);

  // Fee Structure operations
  Future<List<FeeStructure>> getAllFeeStructures(int schoolId) async {
    try {
      final response = await _dio.get('/api/fees/structures', queryParameters: {'schoolId': schoolId});
      if (response.statusCode == 200) {
        final List<dynamic> feesData = response.data;
        return feesData.map((json) => FeeStructure.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load fee structures: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load fee structures: $e');
    }
  }

  Future<FeeStructure> getFeeStructureById(int id, int schoolId) async {
    try {
      final response = await _dio.get('/api/fees/structures/$id', queryParameters: {'schoolId': schoolId});
      if (response.statusCode == 200) {
        return FeeStructure.fromJson(response.data);
      } else {
        throw Exception('Failed to load fee structure: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load fee structure: $e');
    }
  }

  Future<FeeStructure> createFeeStructure(Map<String, dynamic> feeData) async {
    try {
      final response = await _dio.post('/api/fees/structures', data: feeData);
      if (response.statusCode == 200) {
        return FeeStructure.fromJson(response.data);
      } else {
        throw Exception('Failed to create fee structure: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to create fee structure: $e');
    }
  }

  Future<FeeStructure> updateFeeStructure(int id, Map<String, dynamic> feeData) async {
    try {
      final response = await _dio.put('/api/fees/structures/$id', data: feeData);
      if (response.statusCode == 200) {
        return FeeStructure.fromJson(response.data);
      } else {
        throw Exception('Failed to update fee structure: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to update fee structure: $e');
    }
  }

  Future<void> deleteFeeStructure(int id) async {
    try {
      final response = await _dio.delete('/api/fees/structures/$id');
      if (response.statusCode != 204) {
        throw Exception('Failed to delete fee structure: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to delete fee structure: $e');
    }
  }

  // Student Fee operations
  Future<List<Map<String, dynamic>>> getAllStudentFees(int schoolId) async {
    try {
      final response = await _dio.get('/api/fees/student-fees', queryParameters: {'schoolId': schoolId});
      if (response.statusCode == 200) {
        final List<dynamic> feesData = response.data;
        return feesData.map((json) => Map<String, dynamic>.from(json)).toList();
      } else {
        throw Exception('Failed to load student fees: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load student fees: $e');
    }
  }

  Future<Map<String, dynamic>> getStudentFeeById(int id, int schoolId) async {
    try {
      final response = await _dio.get('/api/fees/student-fees/$id', queryParameters: {'schoolId': schoolId});
      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(response.data);
      } else {
        throw Exception('Failed to load student fee: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load student fee: $e');
    }
  }

  Future<Map<String, dynamic>> createStudentFee(Map<String, dynamic> feeData) async {
    try {
      final response = await _dio.post('/api/fees/student-fees', data: feeData);
      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(response.data);
      } else {
        throw Exception('Failed to create student fee: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to create student fee: $e');
    }
  }

  Future<Map<String, dynamic>> updateStudentFee(int id, Map<String, dynamic> feeData) async {
    try {
      final response = await _dio.put('/api/fees/student-fees/$id', data: feeData);
      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(response.data);
      } else {
        throw Exception('Failed to update student fee: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to update student fee: $e');
    }
  }

  Future<void> deleteStudentFee(int id) async {
    try {
      final response = await _dio.delete('/api/fees/student-fees/$id');
      if (response.statusCode != 204) {
        throw Exception('Failed to delete student fee: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to delete student fee: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getFeesByStudentId(int studentId, int schoolId) async {
    try {
      final response = await _dio.get('/api/fees/student-fees/student/$studentId', queryParameters: {'schoolId': schoolId});
      if (response.statusCode == 200) {
        final List<dynamic> feesData = response.data;
        return feesData.map((json) => Map<String, dynamic>.from(json)).toList();
      } else {
        throw Exception('Failed to load fees by student: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load fees by student: $e');
    }
  }

  // Payment operations
  Future<List<FeePayment>> getAllPayments(int schoolId) async {
    try {
      final response = await _dio.get('/api/fees/payments', queryParameters: {'schoolId': schoolId});
      if (response.statusCode == 200) {
        final List<dynamic> paymentsData = response.data;
        return paymentsData.map((json) => FeePayment.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load payments: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load payments: $e');
    }
  }

  Future<FeePayment> getPaymentById(int id, int schoolId) async {
    try {
      final response = await _dio.get('/api/fees/$id', queryParameters: {'schoolId': schoolId});
      if (response.statusCode == 200) {
        return FeePayment.fromJson(response.data);
      } else {
        throw Exception('Failed to load payment: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load payment: $e');
    }
  }

  Future<FeePayment> createPayment(Map<String, dynamic> paymentData) async {
    try {
      final response = await _dio.post('/api/fees/payments', data: paymentData);
      if (response.statusCode == 200) {
        return FeePayment.fromJson(response.data);
      } else {
        throw Exception('Failed to create payment: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to create payment: $e');
    }
  }

  Future<FeePayment> updatePayment(int id, Map<String, dynamic> paymentData) async {
    try {
      final response = await _dio.put('/api/fees/payments/$id', data: paymentData);
      if (response.statusCode == 200) {
        return FeePayment.fromJson(response.data);
      } else {
        throw Exception('Failed to update payment: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to update payment: $e');
    }
  }

  Future<void> deletePayment(int id) async {
    try {
      final response = await _dio.delete('/api/fees/payments/$id');
      if (response.statusCode != 204) {
        throw Exception('Failed to delete payment: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to delete payment: $e');
    }
  }

  Future<List<FeePayment>> getPaymentsByStudentId(int studentId, int schoolId) async {
    try {
      final response = await _dio.get('/api/fees/payments/student/$studentId', queryParameters: {'schoolId': schoolId});
      if (response.statusCode == 200) {
        final List<dynamic> paymentsData = response.data;
        return paymentsData.map((json) => FeePayment.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load payments by student: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load payments by student: $e');
    }
  }

  Future<FeePayment> processPayment(Map<String, dynamic> paymentData) async {
    try {
      final response = await _dio.post('/api/fees/process-payment', data: paymentData);
      if (response.statusCode == 200) {
        return FeePayment.fromJson(response.data);
      } else {
        throw Exception('Failed to process payment: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to process payment: $e');
    }
  }
}


