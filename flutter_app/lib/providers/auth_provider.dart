import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final _secureStorage = const FlutterSecureStorage();
  
  Map<String, dynamic>? _user;
  String? _error;
  bool _isLoading = false;

  Map<String, dynamic>? get user => _user;
  String? get error => _error;
  bool get isLoading => _isLoading;

  // Initialize provider
  Future<void> initialize() async {
    await _loadCurrentUser();
  }

  // Load current user from storage
  Future<void> _loadCurrentUser() async {
    _user = await _authService.getCurrentUser();
    notifyListeners();
  }

  // Unified login method for all user types
  Future<Map<String, dynamic>> login(String mobileNumber, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _authService.login(mobileNumber, password);
      
      if (result['success']) {
        _user = result['user'];
        _clearError();
      } else {
        _setError(result['message']);
      }
      
      return result;
    } catch (e) {
      _setError('Login failed: $e');
      return {'success': false, 'message': 'Login failed: $e'};
    } finally {
      _setLoading(false);
    }
  }

  // Mock login for development
  Future<Map<String, dynamic>> loginMock(String mobileNumber, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _authService.loginMock(mobileNumber, password);
      
      if (result['success']) {
        _user = result['user'];
        _clearError();
      } else {
        _setError(result['message']);
      }
      
      return result;
    } catch (e) {
      _setError('Login failed: $e');
      return {'success': false, 'message': 'Login failed: $e'};
    } finally {
      _setLoading(false);
    }
  }

  // Logout
  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    _clearError();
    notifyListeners();
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    return await _authService.isLoggedIn();
  }

  // Get user role
  Future<String?> getUserRole() async {
    return await _authService.getUserRole();
  }

  // Get school ID
  Future<String?> getSchoolId() async {
    return await _authService.getSchoolId();
  }

  // Check if user is first time
  Future<bool> isFirstTime() async {
    return await _authService.isFirstTime();
  }

  // Check if user can access a specific school
  Future<bool> canAccessSchool(int schoolId) async {
    return await _authService.canAccessSchool(schoolId);
  }

  // Get accessible schools for current user
  Future<List<int>> getAccessibleSchools() async {
    return await _authService.getAccessibleSchools();
  }


  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  // Check if user has specific role
  bool hasRole(String role) {
    return _user?['role'] == role;
  }

  // Check if user is Super Admin
  bool get isSuperAdmin => hasRole('SUPER_ADMIN');

  // Check if user is School Admin
  bool get isSchoolAdmin => hasRole('SCHOOL_ADMIN');

  // Check if user is Teacher
  bool get isTeacher => hasRole('TEACHER');

  // Check if user is Parent
  bool get isParent => hasRole('PARENT');

  // Check if user is Admin (Super Admin or School Admin)
  bool get isAdmin => isSuperAdmin || isSchoolAdmin;

  // Get user's school ID
  int? get userSchoolId => _user?['schoolId'];

  // Get user's name
  String? get userName => _user?['name'];

  // Get user's email
  String? get userEmail => _user?['email'];

  // Get user's mobile number
  String? get userMobile => _user?['mobileNumber'];

  // Store user data after login
  Future<void> storeUserData(Map<String, dynamic> userData) async {
    _user = userData;
    await _secureStorage.write(key: 'user_data', value: userData.toString());
    notifyListeners();
  }

  // Change password
  Future<Map<String, dynamic>> changePassword(String mobileNumber, String newPassword) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _authService.changePassword(mobileNumber, newPassword);
      
      if (!result['success']) {
        _setError(result['message']);
      }
      
      return result;
    } catch (e) {
      _setError('Password change failed: $e');
      return {'success': false, 'message': 'Password change failed: $e'};
    } finally {
      _setLoading(false);
    }
  }

  // Forgot password
  Future<Map<String, dynamic>> forgotPassword(String mobileNumber) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _authService.forgotPassword(mobileNumber);
      
      if (!result['success']) {
        _setError(result['message']);
      }
      
      return result;
    } catch (e) {
      _setError('Password reset failed: $e');
      return {'success': false, 'message': 'Password reset failed: $e'};
    } finally {
      _setLoading(false);
    }
  }

  // Verify reset OTP
  Future<Map<String, dynamic>> verifyResetOTP(String mobileNumber, String otp) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _authService.verifyResetOTP(mobileNumber, otp);
      
      if (!result['success']) {
        _setError(result['message']);
      }
      
      return result;
    } catch (e) {
      _setError('OTP verification failed: $e');
      return {'success': false, 'message': 'OTP verification failed: $e'};
    } finally {
      _setLoading(false);
    }
  }
}



