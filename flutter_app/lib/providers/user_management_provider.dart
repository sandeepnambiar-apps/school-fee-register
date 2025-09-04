import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/permissions.dart';
import '../services/api_service.dart';

class UserManagementProvider extends ChangeNotifier {
  static const String _usersKey = 'users_data';
  static const String _currentUserKey = 'current_user_data';

  List<User> _users = [];
  User? _currentUser;
  bool _isLoading = false;
  String? _error;
  List<User> _filteredUsers = [];

  late final ApiService _apiService;

  // Getters
  List<User> get users => _users;
  List<User> get filteredUsers => _filteredUsers;
  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasUsers => _users.isNotEmpty;

  UserManagementProvider() {
    _initializeServices();
    _loadData();
  }

  void _initializeServices() {
    _apiService = ApiService();
    _apiService.initialize();
  }

  // Load data from SharedPreferences
  Future<void> _loadData() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      
      // Load users from local storage
      final usersJson = prefs.getStringList(_usersKey) ?? [];
      _users = usersJson
          .map((json) => User.fromJson(Map<String, dynamic>.from(
              Map.fromEntries(json.split(',').map((e) {
                final parts = e.split(':');
                return MapEntry(parts[0], parts.sublist(1).join(':'));
              }))
          )))
          .toList();
      
      // Load current user
      final currentUserJson = prefs.getString(_currentUserKey);
      if (currentUserJson != null) {
        _currentUser = User.fromJson(Map<String, dynamic>.from(
            Map.fromEntries(currentUserJson.split(',').map((e) {
              final parts = e.split(':');
              return MapEntry(parts[0], parts.sublist(1).join(':'));
            }))
        ));
      }

      // If no users exist, create demo users
      if (_users.isEmpty) {
        await _createDemoUsers();
      }

      _filteredUsers = List.from(_users);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load user data: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Save data to SharedPreferences
  Future<void> _saveData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Save users
      final usersJson = _users.map((user) {
        final json = user.toJson();
        return json.entries.map((e) => '${e.key}:${e.value}').join(',');
      }).toList();
      await prefs.setStringList(_usersKey, usersJson);
      
      // Save current user
      if (_currentUser != null) {
        final currentUserJson = _currentUser!.toJson();
        final jsonString = currentUserJson.entries.map((e) => '${e.key}:${e.value}').join(',');
        await prefs.setString(_currentUserKey, jsonString);
      }
    } catch (e) {
      _error = 'Failed to save user data: $e';
      notifyListeners();
    }
  }

  // Create demo users for testing
  Future<void> _createDemoUsers() async {
    final demoUsers = [
      User(
        id: '1',
        username: 'superadmin',
        fullName: 'Super Administrator',
        email: 'superadmin@kidsy.com',
        phone: '+1-555-0001',
        role: 'Super Admin',
        schoolId: null, // Super Admin can access all schools
        status: 'ACTIVE',
        createdAt: DateTime.now(),
        permissions: RolePermissions.getPermissionsForRole('Super Admin'),
      ),
      User(
        id: '2',
        username: 'admin001',
        fullName: 'School Administrator',
        email: 'admin001@school.com',
        phone: '+1-555-0002',
        role: 'School Admin',
        schoolId: '1', // BOON E.M School
        status: 'ACTIVE',
        createdAt: DateTime.now(),
        permissions: RolePermissions.getPermissionsForRole('School Admin'),
      ),
      User(
        id: '3',
        username: 'T001',
        fullName: 'Class Teacher',
        email: 'teacher@school.com',
        phone: '+1-555-0003',
        role: 'Teacher',
        schoolId: '1', // BOON E.M School
        status: 'ACTIVE',
        createdAt: DateTime.now(),
        department: 'Mathematics',
        subject: 'Mathematics',
        permissions: RolePermissions.getPermissionsForRole('Teacher'),
      ),
      User(
        id: '4',
        username: 'P001',
        fullName: 'Parent User',
        email: 'parent@home.com',
        phone: '+1-555-0004',
        role: 'Parent',
        schoolId: '1', // BOON E.M School
        status: 'ACTIVE',
        createdAt: DateTime.now(),
        kidId: '1',
        permissions: RolePermissions.getPermissionsForRole('Parent'),
      ),
    ];

    _users = demoUsers;
    await _saveData();
  }

  // Create new user
  Future<bool> createUser({
    required String username,
    required String password,
    required String fullName,
    required String email,
    required String phone,
    required String role,
    String? schoolId,
    String? department,
    String? subject,
    String? kidId,
  }) async {
    try {
      // Check if username already exists
      if (_users.any((user) => user.username == username)) {
        _error = 'Username already exists';
        notifyListeners();
        return false;
      }

      // Check if email already exists
      if (_users.any((user) => user.email == email)) {
        _error = 'Email already exists';
        notifyListeners();
        return false;
      }

      // Create new user
      final newUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        username: username,
        fullName: fullName,
        email: email,
        phone: phone,
        role: role,
        schoolId: schoolId,
        status: 'ACTIVE',
        createdAt: DateTime.now(),
        department: department,
        subject: subject,
        kidId: kidId,
        permissions: RolePermissions.getPermissionsForRole(role),
      );

      _users.add(newUser);
      _filteredUsers = List.from(_users);
      await _saveData();
      
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to create user: $e';
      notifyListeners();
      return false;
    }
  }

  // Update existing user
  Future<bool> updateUser(String userId, {
    String? fullName,
    String? email,
    String? phone,
    String? role,
    String? schoolId,
    String? status,
    String? department,
    String? subject,
    String? kidId,
  }) async {
    try {
      final userIndex = _users.indexWhere((user) => user.id == userId);
      if (userIndex == -1) {
        _error = 'User not found';
        notifyListeners();
        return false;
      }

      final updatedUser = _users[userIndex].copyWith(
        fullName: fullName,
        email: email,
        phone: phone,
        role: role,
        schoolId: schoolId,
        status: status,
        department: department,
        subject: subject,
        kidId: kidId,
        permissions: role != null ? RolePermissions.getPermissionsForRole(role) : null,
      );

      _users[userIndex] = updatedUser;
      
      // Update current user if it's the one being updated
      if (_currentUser?.id == userId) {
        _currentUser = updatedUser;
      }
      
      _filteredUsers = List.from(_users);
      await _saveData();
      
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to update user: $e';
      notifyListeners();
      return false;
    }
  }

  // Delete user
  Future<bool> deleteUser(String userId) async {
    try {
      // Don't allow deletion of current user
      if (_currentUser?.id == userId) {
        _error = 'Cannot delete current user';
        notifyListeners();
        return false;
      }

      _users.removeWhere((user) => user.id == userId);
      _filteredUsers = List.from(_users);
      await _saveData();
      
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to delete user: $e';
      notifyListeners();
      return false;
    }
  }

  // Change user status
  Future<bool> changeUserStatus(String userId, String newStatus) async {
    try {
      final userIndex = _users.indexWhere((user) => user.id == userId);
      if (userIndex == -1) {
        _error = 'User not found';
        notifyListeners();
        return false;
      }

      final updatedUser = _users[userIndex].copyWith(status: newStatus);
      _users[userIndex] = updatedUser;
      
      // Update current user if it's the one being updated
      if (_currentUser?.id == userId) {
        _currentUser = updatedUser;
      }
      
      _filteredUsers = List.from(_users);
      await _saveData();
      
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to change user status: $e';
      notifyListeners();
      return false;
    }
  }

  // Change user role
  Future<bool> changeUserRole(String userId, String newRole) async {
    try {
      final userIndex = _users.indexWhere((user) => user.id == userId);
      if (userIndex == -1) {
        _error = 'User not found';
        notifyListeners();
        return false;
      }

      final updatedUser = _users[userIndex].copyWith(
        role: newRole,
        permissions: RolePermissions.getPermissionsForRole(newRole),
      );

      _users[userIndex] = updatedUser;
      
      // Update current user if it's the one being updated
      if (_currentUser?.id == userId) {
        _currentUser = updatedUser;
      }
      
      _filteredUsers = List.from(_users);
      await _saveData();
      
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to change user role: $e';
      notifyListeners();
      return false;
    }
  }

  // Filter users by various criteria
  void filterUsers({
    String? searchQuery,
    String? role,
    String? schoolId,
    String? status,
  }) {
    _filteredUsers = _users.where((user) {
      bool matchesSearch = true;
      bool matchesRole = true;
      bool matchesSchool = true;
      bool matchesStatus = true;

      // Search query filter
      if (searchQuery != null && searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        matchesSearch = user.fullName.toLowerCase().contains(query) ||
                       user.username.toLowerCase().contains(query) ||
                       user.email.toLowerCase().contains(query);
      }

      // Role filter
      if (role != null && role.isNotEmpty) {
        matchesRole = user.role == role;
      }

      // School filter
      if (schoolId != null && schoolId.isNotEmpty) {
        matchesSchool = user.schoolId == schoolId;
      }

      // Status filter
      if (status != null && status.isNotEmpty) {
        matchesStatus = user.status == status;
      }

      return matchesSearch && matchesRole && matchesSchool && matchesStatus;
    }).toList();

    notifyListeners();
  }

  // Get users by school
  List<User> getUsersBySchool(String schoolId) {
    return _users.where((user) => user.schoolId == schoolId).toList();
  }

  // Get users by role
  List<User> getUsersByRole(String role) {
    return _users.where((user) => user.role == role).toList();
  }

  // Get user by ID
  User? getUserById(String userId) {
    try {
      return _users.firstWhere((user) => user.id == userId);
    } catch (e) {
      return null;
    }
  }

  // Get user by username
  User? getUserByUsername(String username) {
    try {
      return _users.firstWhere((user) => user.username == username);
    } catch (e) {
      return null;
    }
  }

  // Check if user has permission
  bool hasPermission(String userId, String permission) {
    final user = getUserById(userId);
    if (user == null) return false;
    return user.permissions.contains(permission);
  }

  // Check if current user has permission
  bool currentUserHasPermission(String permission) {
    if (_currentUser == null) return false;
    return _currentUser!.permissions.contains(permission);
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Refresh data
  Future<void> refreshData() async {
    await _loadData();
  }

  // Reset to demo data
  Future<void> resetToDemoData() async {
    _users.clear();
    _filteredUsers.clear();
    await _createDemoUsers();
  }
}
