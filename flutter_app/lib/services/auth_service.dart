import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_service.dart';
import 'dart:convert'; // Added for jsonEncode

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final ApiService _apiService = ApiService();

  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userKey = 'user_data';

  // Initialize the service
  void initialize() {
    _apiService.initialize();
  }

  // Login method
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      // For development, use mock login for multiple roles
      Map<String, dynamic>? user;
      
      // Super Admin for School 1
      if (username == 'superadmin1' && password == 'super123') {
        user = {
          'id': 1,
          'username': 'superadmin1',
          'email': 'superadmin1@boon.school.com',
          'role': 'SUPER_ADMIN',
          'name': 'Super Admin - BOON E.M School',
          'schoolId': 1,
        };
      }
      // Super Admin for School 2
      else if (username == 'superadmin2' && password == 'super456') {
        user = {
          'id': 2,
          'username': 'superadmin2',
          'email': 'superadmin2@school2.com',
          'role': 'SUPER_ADMIN',
          'name': 'Super Admin - School 2',
          'schoolId': 2,
        };
      }
      // School Admin
      else if (username == 'schooladmin' && password == 'school123') {
        user = {
          'id': 3,
          'username': 'schooladmin',
          'email': 'schooladmin@school.com',
          'role': 'SCHOOL_ADMIN',
          'name': 'School Administrator',
          'schoolId': 1,
        };
      }
      // Teacher
      else if (username == 'teacher' && password == 'teacher123') {
        user = {
          'id': 4,
          'username': 'teacher',
          'email': 'teacher@school.com',
          'role': 'TEACHER',
          'name': 'Class Teacher',
          'class': '10A',
          'schoolId': 1,
        };
      }
      // Parent
      else if (username == 'parent' && password == 'parent123') {
        user = {
          'id': 5,
          'username': 'parent',
          'email': 'parent@home.com',
          'role': 'PARENT',
          'name': 'Parent User',
          'kidId': 1,
          'schoolId': 1,
        };
      }

      if (user != null) {
        final token = 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}';
        final refreshToken = 'mock_refresh_token_${DateTime.now().millisecondsSinceEpoch}';

        // Store tokens and user data
        await _storage.write(key: _tokenKey, value: token);
        await _storage.write(key: _refreshTokenKey, value: refreshToken);
        await _storage.write(key: _userKey, value: jsonEncode(user));

        return {
          'success': true,
          'user': user,
          'token': token,
          'message': 'Login successful',
        };
      }
      
      // Real API call (uncomment when backend is ready)
      /*
      final response = await _apiService.callService(
        '/api/auth/login',
        method: 'POST',
        data: {
          'username': username,
          'password': password,
        },
      );
      
      final data = _apiService.parseResponse(response);
      final token = data['token'];
      final user = data['user'];
      
      // Store tokens and user data
      await _storage.write(key: _tokenKey, value: token);
      await _storage.write(key: _userKey, value: user.toString());
      
      return {
        'success': true,
        'user': user,
        'token': token,
        'message': 'Login successful',
      };
      */
      
      return {
        'success': false,
        'message': 'Invalid credentials. Please check your username and password.',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Login failed: ${e.toString()}',
      };
    }
  }

  // Logout method
  Future<void> logout() async {
    try {
      await _storage.delete(key: _tokenKey);
      await _storage.delete(key: _refreshTokenKey);
      await _storage.delete(key: _userKey);
    } catch (e) {
      print('Logout error: $e');
    }
  }

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    try {
      final token = await _storage.read(key: _tokenKey);
      return token != null;
    } catch (e) {
      return false;
    }
  }

  // Get current user
  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final userData = await _storage.read(key: _userKey);
      if (userData != null) {
        // Parse the stored user data string back to map
        // This is a simplified approach - in production, use proper serialization
        return jsonDecode(userData);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Get auth token
  Future<String?> getToken() async {
    try {
      return await _storage.read(key: _tokenKey);
    } catch (e) {
      return null;
    }
  }

  // Refresh token
  Future<bool> refreshToken() async {
    try {
      final refreshToken = await _storage.read(key: _refreshTokenKey);
      if (refreshToken == null) return false;

      // Call refresh token API
      final response = await _apiService.callService(
        '/api/auth/refresh',
        method: 'POST',
        data: {'refreshToken': refreshToken},
      );

      final data = _apiService.parseResponse(response);
      final newToken = data['token'];
      final newRefreshToken = data['refreshToken'];

      // Update stored tokens
      await _storage.write(key: _tokenKey, value: newToken);
      await _storage.write(key: _refreshTokenKey, value: newRefreshToken);

      return true;
    } catch (e) {
      print('Token refresh failed: $e');
      return false;
    }
  }

  // Validate token
  Future<bool> validateToken() async {
    try {
      final token = await getToken();
      if (token == null) return false;

      // Call validate token API
      final response = await _apiService.callService(
        '/api/auth/validate',
        method: 'GET',
        data: null,
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Parent login with mobile and login code
  Future<Map<String, dynamic>> loginWithMobileAndCode(String mobileNumber, String loginCode) async {
    try {
      // Mock parent verification - in real app, this would call the backend API
      Map<String, dynamic>? user;
      
      // Mock parent data - in real app, this would come from the database
      if (mobileNumber == '9876543210' && loginCode == 'ABC123') {
        user = {
          'id': 101,
          'username': 'parent_9876543210',
          'email': 'parent@home.com',
          'role': 'PARENT',
          'name': 'John Parent',
          'mobileNumber': mobileNumber,
          'schoolId': 1,
          'kidId': 1,
          'kidName': 'John Doe',
          'isFirstTime': true, // Flag to indicate if password setup is needed
        };
      } else if (mobileNumber == '9876543211' && loginCode == 'DEF456') {
        user = {
          'id': 102,
          'username': 'parent_9876543211',
          'email': 'parent2@home.com',
          'role': 'PARENT',
          'name': 'Sarah Parent',
          'mobileNumber': mobileNumber,
          'schoolId': 1,
          'kidId': 2,
          'kidName': 'Sarah Smith',
          'isFirstTime': false, // Already has password set
        };
      }

      if (user != null) {
        final token = 'mock_jwt_token_${DateTime.now().millisecondsSinceEpoch}';
        final refreshToken = 'mock_refresh_token_${DateTime.now().millisecondsSinceEpoch}';

        // Store tokens and user data
        await _storage.write(key: _tokenKey, value: token);
        await _storage.write(key: _refreshTokenKey, value: refreshToken);
        await _storage.write(key: _userKey, value: jsonEncode(user));

        return {
          'success': true,
          'user': user,
          'token': token,
          'message': user['isFirstTime'] ? 'Please set up your password' : 'Login successful',
        };
      }
      
      // Real API call (uncomment when backend is ready)
      /*
      final response = await _apiService.callService(
        '/api/parents/verify-login-code',
        method: 'POST',
        data: {
          'mobileNumber': mobileNumber,
          'loginCode': loginCode,
        },
      );
      
      final data = _apiService.parseResponse(response);
      final token = data['token'];
      final user = data['user'];
      
      // Store tokens and user data
      await _storage.write(key: _tokenKey, value: token);
      await _storage.write(key: _userKey, value: user.toString());
      
      return {
        'success': true,
        'user': user,
        'token': token,
        'message': 'Login successful',
      };
      */
      
      return {
        'success': false,
        'message': 'Invalid mobile number or login code. Please check your credentials.',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Login failed: ${e.toString()}',
      };
    }
  }

  // Setup parent password
  Future<Map<String, dynamic>> setupParentPassword(String mobileNumber, String password) async {
    try {
      // Mock password setup - in real app, this would call the backend API
      Map<String, dynamic>? user;
      
      // Mock parent data - in real app, this would come from the database
      if (mobileNumber == '9876543210') {
        user = {
          'id': 101,
          'username': 'parent_9876543210',
          'email': 'parent@home.com',
          'role': 'PARENT',
          'name': 'John Parent',
          'mobileNumber': mobileNumber,
          'schoolId': 1,
          'kidId': 1,
          'kidName': 'John Doe',
          'isFirstTime': false, // Password is now set
        };
      }

      if (user != null) {
        // Update user data to reflect password is set
        user['isFirstTime'] = false;
        
        // Store updated user data
        await _storage.write(key: _userKey, value: jsonEncode(user));

        return {
          'success': true,
          'user': user,
          'message': 'Password set successfully!',
        };
      }
      
      // Real API call (uncomment when backend is ready)
      /*
      final response = await _apiService.callService(
        '/api/parents/setup-password',
        method: 'POST',
        data: {
          'mobileNumber': mobileNumber,
          'password': password,
        },
      );
      
      final data = _apiService.parseResponse(response);
      final user = data['user'];
      
      // Store updated user data
      await _storage.write(key: _userKey, value: user.toString());
      
      return {
        'success': true,
        'user': user,
        'message': 'Password set successfully!',
      };
      */
      
      return {
        'success': false,
        'message': 'Failed to set password. Please try again.',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Password setup failed: ${e.toString()}',
      };
    }
  }
}


