import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import '../services/api_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final _storage = const FlutterSecureStorage();
  final _apiService = ApiService();

  // Unified login method for all user types
  Future<Map<String, dynamic>> login(String mobileNumber, String password) async {
    try {
      print('Attempting login for mobile: $mobileNumber');
      
      // Call unified login endpoint
      final response = await _apiService.callService(
        '/api/auth/unified-login',
        method: 'POST',
        data: {
          'mobileNumber': mobileNumber,
          'password': password,
        },
      );

      final responseData = response.data as Map<String, dynamic>;
      
      if (responseData['success'] == true) {
        final userData = responseData['user'];
        
        // Store user data securely
        await _storage.write(key: 'user_token', value: responseData['token']);
        await _storage.write(key: 'user_data', value: userData.toString());
        await _storage.write(key: 'user_role', value: userData['role'].toString());
        await _storage.write(key: 'school_id', value: userData['schoolId']?.toString() ?? '');
        await _storage.write(key: 'is_first_time', value: userData['isFirstTime'].toString());
        
        // Extract school_id from JWT token for additional security
        final schoolIdFromJWT = await _extractSchoolIdFromToken(responseData['token']);
        if (schoolIdFromJWT != null) {
          await _storage.write(key: 'jwt_school_id', value: schoolIdFromJWT.toString());
        }
        
        return {
          'success': true,
          'user': userData,
          'message': responseData['message'] ?? 'Login successful',
          'requiresPasswordChange': responseData['requiresPasswordChange'] ?? false,
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Login failed',
        };
      }
    } catch (e) {
      print('Login error: $e');
      return {
        'success': false,
        'message': 'Network error. Please try again.',
      };
    }
  }

  // Mock implementation for development
  Future<Map<String, dynamic>> loginMock(String mobileNumber, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    
    // Mock user database
    final mockUsers = {
      // Super Admin - can access all schools
      '9999999999': {
        'id': 'super_admin_1',
        'mobileNumber': '9999999999',
        'name': 'App Developer',
        'role': 'SUPER_ADMIN',
        'schoolId': null, // Can access all schools
        'isFirstTime': false,
        'email': 'developer@kidsy.com',
      },
      
      // School 1 Admin
      '1111111111': {
        'id': 'school1_admin',
        'mobileNumber': '1111111111',
        'name': 'School 1 Admin',
        'role': 'SCHOOL_ADMIN',
        'schoolId': 1,
        'isFirstTime': false,
        'email': 'admin1@school.com',
      },
      
      // School 2 Admin
      '2222222222': {
        'id': 'school2_admin',
        'mobileNumber': '2222222222',
        'name': 'School 2 Admin',
        'role': 'SCHOOL_ADMIN',
        'schoolId': 2,
        'isFirstTime': false,
        'email': 'admin2@school.com',
      },
      
      // School 1 Teachers
      '3333333333': {
        'id': 'teacher1_school1',
        'mobileNumber': '3333333333',
        'name': 'John Teacher',
        'role': 'TEACHER',
        'schoolId': 1,
        'isFirstTime': false,
        'email': 'john.teacher@school.com',
        'class': '10A',
        'subject': 'Mathematics',
      },
      
      '4444444444': {
        'id': 'teacher2_school1',
        'mobileNumber': '4444444444',
        'name': 'Sarah Teacher',
        'role': 'TEACHER',
        'schoolId': 1,
        'isFirstTime': false,
        'email': 'sarah.teacher@school.com',
        'class': '9B',
        'subject': 'Science',
      },
      
      // School 2 Teachers
      '5555555555': {
        'id': 'teacher1_school2',
        'mobileNumber': '5555555555',
        'name': 'Mike Teacher',
        'role': 'TEACHER',
        'schoolId': 2,
        'isFirstTime': false,
        'email': 'mike.teacher@school.com',
        'class': '8A',
        'subject': 'English',
      },
      
      // School 1 Parents
      '6666666666': {
        'id': 'parent1_school1',
        'mobileNumber': '6666666666',
        'name': 'David Parent',
        'role': 'PARENT',
        'schoolId': 1,
        'isFirstTime': false,
        'email': 'david.parent@email.com',
        'kids': ['John Doe', 'Jane Smith'],
      },
      
      '7777777777': {
        'id': 'parent2_school1',
        'mobileNumber': '7777777777',
        'name': 'Lisa Parent',
        'role': 'PARENT',
        'schoolId': 1,
        'isFirstTime': false,
        'email': 'lisa.parent@email.com',
        'kids': ['Mike Johnson'],
      },
      
      // School 2 Parents
      '8888888888': {
        'id': 'parent1_school2',
        'mobileNumber': '8888888888',
        'name': 'Robert Parent',
        'role': 'PARENT',
        'schoolId': 2,
        'isFirstTime': false,
        'email': 'robert.parent@email.com',
        'kids': ['Alice Brown'],
      },
    };

    if (mockUsers.containsKey(mobileNumber)) {
      final user = mockUsers[mobileNumber]!;
      
      // Store user data
              await _storage.write(key: 'user_token', value: 'mock_token_${user['id']}');
        await _storage.write(key: 'user_data', value: user.toString());
        await _storage.write(key: 'user_role', value: user['role'].toString());
        await _storage.write(key: 'school_id', value: user['schoolId']?.toString() ?? '');
        await _storage.write(key: 'is_first_time', value: user['isFirstTime'].toString());
      
      return {
        'success': true,
        'user': user,
        'message': 'Login successful',
      };
    } else {
      return {
        'success': false,
        'message': 'Invalid mobile number or password',
      };
    }
  }

  // Get current user data
  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final userData = await _storage.read(key: 'user_data');
      if (userData != null) {
        // Parse the stored user data
        return _parseUserData(userData);
      }
      return null;
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }

  // Get current school ID from JWT (more secure)
  Future<int?> getCurrentSchoolId() async {
    try {
      final schoolIdString = await _storage.read(key: 'jwt_school_id');
      if (schoolIdString != null) {
        return int.tryParse(schoolIdString);
      }
      
      // Fallback to regular school_id
      final fallbackSchoolId = await _storage.read(key: 'school_id');
      return int.tryParse(fallbackSchoolId ?? '');
    } catch (e) {
      return null;
    }
  }

  // Parse user data from storage
  Map<String, dynamic> _parseUserData(String userData) {
    try {
      // Remove the curly braces and split by comma
      final cleanData = userData.replaceAll('{', '').replaceAll('}', '');
      final pairs = cleanData.split(', ');
      
      final Map<String, dynamic> parsed = {};
      for (final pair in pairs) {
        final keyValue = pair.split(': ');
        if (keyValue.length == 2) {
          final key = keyValue[0].trim();
          final value = keyValue[1].trim();
          
          // Convert string values to appropriate types
          if (value == 'null') {
            parsed[key] = null;
          } else if (value == 'true') {
            parsed[key] = true;
          } else if (value == 'false') {
            parsed[key] = false;
          } else if (int.tryParse(value) != null) {
            parsed[key] = int.parse(value);
          } else {
            parsed[key] = value;
          }
        }
      }
      return parsed;
    } catch (e) {
      print('Error parsing user data: $e');
      return {};
    }
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'user_token');
    return token != null;
  }

  // Get user role
  Future<String?> getUserRole() async {
    return await _storage.read(key: 'user_role');
  }

  // Get school ID
  Future<String?> getSchoolId() async {
    return await _storage.read(key: 'school_id');
  }

  // Check if user is first time
  Future<bool> isFirstTime() async {
    final isFirstTime = await _storage.read(key: 'is_first_time');
    return isFirstTime == 'true';
  }

  // Logout
  Future<void> logout() async {
    await _storage.deleteAll();
  }

  // Check if user can access a specific school
  Future<bool> canAccessSchool(int schoolId) async {
    final user = await getCurrentUser();
    if (user == null) return false;
    
    final userRole = user['role'];
    final userSchoolId = user['schoolId'];
    
    // Super Admin can access all schools
    if (userRole == 'SUPER_ADMIN') {
      return true;
    }
    
    // Other users can only access their assigned school
    return userSchoolId == schoolId;
  }

  // Get accessible schools for current user
  Future<List<int>> getAccessibleSchools() async {
    final user = await getCurrentUser();
    if (user == null) return [];
    
    final userRole = user['role'];
    final userSchoolId = user['schoolId'];
    
    // Super Admin can access all schools
    if (userRole == 'SUPER_ADMIN') {
      return [1, 2, 3, 4, 5]; // All available schools
    }
    
    // Other users can only access their assigned school
    return userSchoolId != null ? [userSchoolId] : [];
  }

  // Change password
  Future<Map<String, dynamic>> changePassword(String currentPassword, String newPassword) async {
    try {
      final user = await getCurrentUser();
      if (user == null) {
        return {'success': false, 'message': 'User not found'};
      }

      final response = await _apiService.callService(
        '/api/auth/change-password',
        method: 'POST',
        data: {
          'mobileNumber': user['mobileNumber'],
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        },
      );

      final responseData = response.data as Map<String, dynamic>;
      
      return {
        'success': responseData['success'] ?? false,
        'message': responseData['message'] ?? 'Password change failed',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error. Please try again.',
      };
    }
  }

  // Forgot password
  Future<Map<String, dynamic>> forgotPassword(String mobileNumber) async {
    try {
      final response = await _apiService.callService(
        '/api/auth/forgot-password',
        method: 'POST',
        data: {
          'mobileNumber': mobileNumber,
        },
      );

      final responseData = response.data as Map<String, dynamic>;
      
      return {
        'success': responseData['success'] ?? false,
        'message': responseData['message'] ?? 'Password reset failed',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error. Please try again.',
      };
    }
  }

  // Verify reset OTP
  Future<Map<String, dynamic>> verifyResetOTP(String mobileNumber, String otp) async {
    try {
      final response = await _apiService.callService(
        '/api/auth/verify-reset-otp',
        method: 'POST',
        data: {
          'mobileNumber': mobileNumber,
          'otp': otp,
        },
      );

      final responseData = response.data as Map<String, dynamic>;
      
      return {
        'success': responseData['success'] ?? false,
        'message': responseData['message'] ?? 'OTP verification failed',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error. Please try again.',
      };
    }
  }

  // Extract school_id from JWT token
  Future<int?> _extractSchoolIdFromToken(String token) async {
    try {
      // Simple JWT parsing (in production, use a proper JWT library)
      final parts = token.split('.');
      if (parts.length != 3) return null;
      
      // Decode payload (base64url)
      String payload = parts[1];
      // Add padding if needed
      while (payload.length % 4 != 0) {
        payload += '=';
      }
      
      // Replace URL-safe characters
      payload = payload.replaceAll('-', '+').replaceAll('_', '/');
      
      // Decode base64 using dart:convert
      final decodedBytes = base64Decode(payload);
      final decodedString = String.fromCharCodes(decodedBytes);
      
      // Parse JSON
      final payloadMap = jsonDecode(decodedString) as Map<String, dynamic>;
      
      // Extract school_id
      final schoolId = payloadMap['schoolId'];
      if (schoolId != null) {
        return int.tryParse(schoolId.toString());
      }
      
      return null;
    } catch (e) {
      print('Error parsing JWT: $e');
      return null;
    }
  }
}