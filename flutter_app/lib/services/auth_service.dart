import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'api_service.dart';

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
      if (username == 'superadmin' && password == 'super123') {
        user = {
          'id': 1,
          'username': 'superadmin',
          'email': 'superadmin@kidsy.com',
          'role': 'Super Admin',
          'name': 'Super Administrator',
        };
      } else if (username == 'admin001' && password == 'admin123') {
        user = {
          'id': 2,
          'username': 'admin001',
          'email': 'admin001@school.com',
          'role': 'School Admin',
          'name': 'School Administrator',
        };
      } else if (username == 'T001' && password == 'teacher123') {
        user = {
          'id': 3,
          'username': 'T001',
          'email': 'teacher@school.com',
          'role': 'Teacher',
          'name': 'Class Teacher',
          'class': '10A',
        };
      } else if (username == 'P001' && password == 'parent123') {
        user = {
          'id': 4,
          'username': 'P001',
          'email': 'parent@home.com',
          'role': 'Parent',
          'name': 'Parent User',
          'kidId': 1,
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
      final response = await _apiService.callAuthService(
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
        'message': 'Invalid credentials. Try: Super Admin (superadmin/super123), School Admin (admin001/admin123), Teacher (T001/teacher123), Parent (P001/parent123).',
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
        return jsonDecode(userData) as Map<String, dynamic>;
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
      final response = await _apiService.callAuthService(
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
      final response = await _apiService.callAuthService(
        '/api/auth/validate',
        method: 'GET',
        data: null,
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}


