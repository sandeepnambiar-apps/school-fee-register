import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/parent.dart';
import '../services/api_service.dart';

class ParentProvider extends ChangeNotifier {
  Parent? _currentParent;
  bool _isLoading = false;
  String? _error;
  
  static const String _storageKey = 'parent_data';
  final ApiService _apiService = ApiService();

  // Getters
  Parent? get currentParent => _currentParent;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _currentParent != null;

  // Initialize
  ParentProvider() {
    _apiService.initialize();
    _loadStoredParent();
  }

  // Load stored parent data
  Future<void> _loadStoredParent() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final parentJson = prefs.getString(_storageKey);
      
      if (parentJson != null) {
        final Map<String, dynamic> parentData = json.decode(parentJson);
        _currentParent = Parent.fromJson(parentData);
        notifyListeners();
      }
    } catch (e) {
      print('Error loading stored parent: $e');
    }
  }

  // Save parent data to storage
  Future<void> _saveParentData(Parent parent) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey, json.encode(parent.toJson()));
    } catch (e) {
      print('Error saving parent data: $e');
    }
  }

  // Clear stored parent data
  Future<void> _clearParentData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_storageKey);
    } catch (e) {
      print('Error clearing parent data: $e');
    }
  }

  // Register parent
  Future<bool> registerParent({
    required String mobileNumber,
    required String password,
    required String name,
    required String email,
    required String loginCode,
    required int schoolId,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _apiService.dio.post('/api/parents/register', data: {
        'mobileNumber': mobileNumber,
        'password': password,
        'name': name,
        'email': email,
        'loginCode': loginCode,
        'schoolId': schoolId,
      });

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          final parent = Parent.fromJson(data['parent']);
          _currentParent = parent;
          await _saveParentData(parent);
          _isLoading = false;
          notifyListeners();
          return true;
        } else {
          _error = data['message'] ?? 'Registration failed';
          _isLoading = false;
          notifyListeners();
          return false;
        }
      } else {
        _error = 'Registration failed';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Registration failed: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Login parent
  Future<bool> loginParent({
    required String mobileNumber,
    required String password,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _apiService.dio.post('/api/parents/login', data: {
        'mobileNumber': mobileNumber,
        'password': password,
      });

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          final parent = Parent.fromJson(data['parent']);
          _currentParent = parent;
          await _saveParentData(parent);
          _isLoading = false;
          notifyListeners();
          return true;
        } else {
          _error = data['message'] ?? 'Login failed';
          _isLoading = false;
          notifyListeners();
          return false;
        }
      } else {
        _error = 'Login failed';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Login failed: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Logout parent
  Future<void> logout() async {
    _currentParent = null;
    await _clearParentData();
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Get parent by ID
  Future<Parent?> getParentById(int id) async {
    try {
      final response = await _apiService.dio.get('/api/parents/$id');
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          return Parent.fromJson(data['parent']);
        }
      }
      return null;
    } catch (e) {
      print('Error getting parent: $e');
      return null;
    }
  }

  // Get parents by school
  Future<List<Parent>> getParentsBySchool(int schoolId) async {
    try {
      final response = await _apiService.dio.get('/api/parents/school/$schoolId');
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          final List<dynamic> parentsData = data['parents'];
          return parentsData.map((json) => Parent.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      print('Error getting parents by school: $e');
      return [];
    }
  }

  // Update parent
  Future<bool> updateParent({
    required int id,
    required String name,
    required String email,
    String? password,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final updateData = {
        'name': name,
        'email': email,
      };
      
      if (password != null && password.isNotEmpty) {
        updateData['password'] = password;
      }

      final response = await _apiService.dio.put('/api/parents/$id', data: updateData);

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          final parent = Parent.fromJson(data['parent']);
          _currentParent = parent;
          await _saveParentData(parent);
          _isLoading = false;
          notifyListeners();
          return true;
        } else {
          _error = data['message'] ?? 'Update failed';
          _isLoading = false;
          notifyListeners();
          return false;
        }
      } else {
        _error = 'Update failed';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Update failed: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Generate login code
  Future<String?> generateLoginCode() async {
    try {
      final response = await _apiService.dio.post('/api/parents/generate-login-code');
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          return data['loginCode'];
        }
      }
      return null;
    } catch (e) {
      print('Error generating login code: $e');
      return null;
    }
  }

  // Verify login code
  Future<bool> verifyLoginCode({
    required String loginCode,
    required int schoolId,
  }) async {
    try {
      final response = await _apiService.dio.post('/api/parents/verify-login-code', data: {
        'loginCode': loginCode,
        'schoolId': schoolId,
      });
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true) {
          return data['isValid'] ?? false;
        }
      }
      return false;
    } catch (e) {
      print('Error verifying login code: $e');
      return false;
    }
  }
}

