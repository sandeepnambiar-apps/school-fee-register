import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/permissions.dart';
import '../providers/auth_provider.dart';

class UserManagementProvider extends ChangeNotifier {
  final AuthProvider _authProvider;
  
  List<User> _users = [];
  List<User> _filteredUsers = [];
  bool _isLoading = false;
  String? _error;

  UserManagementProvider(this._authProvider);

  // Getters
  List<User> get users => _users;
  List<User> get filteredUsers => _filteredUsers;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Initialize with mock data
  Future<void> refreshData() async {
    _setLoading(true);
    _clearError();

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Load mock users
      _loadMockUsers();
      
      // Apply current filters
      _applyCurrentFilters();
    } catch (e) {
      _setError('Failed to load users: $e');
    } finally {
      _setLoading(false);
    }
  }

  void _loadMockUsers() {
    _users = [
      User(
        id: '1',
        mobileNumber: '9999999999',
        fullName: 'App Developer',
        username: 'superadmin',
        email: 'developer@kidsy.com',
        role: 'SUPER_ADMIN',
        schoolId: null,
        status: 'ACTIVE',
        isActive: true,
        isFirstTime: false,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      User(
        id: '2',
        mobileNumber: '1111111111',
        fullName: 'School 1 Admin',
        username: 'admin1',
        email: 'admin1@school.com',
        role: 'SCHOOL_ADMIN',
        schoolId: '1',
        status: 'ACTIVE',
        isActive: true,
        isFirstTime: false,
        createdAt: DateTime.now().subtract(const Duration(days: 25)),
      ),
      User(
        id: '3',
        mobileNumber: '3333333333',
        fullName: 'John Teacher',
        username: 'teacher1',
        email: 'john.teacher@school.com',
        role: 'TEACHER',
        schoolId: '1',
        classAssigned: '10A',
        subjectTaught: 'Mathematics',
        status: 'ACTIVE',
        isActive: true,
        isFirstTime: false,
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
      ),
      User(
        id: '4',
        mobileNumber: '6666666666',
        fullName: 'David Parent',
        username: 'parent1',
        email: 'david.parent@email.com',
        role: 'PARENT',
        schoolId: '1',
        status: 'ACTIVE',
        isActive: true,
        isFirstTime: false,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
      ),
      User(
        id: '5',
        mobileNumber: '2222222222',
        fullName: 'School 2 Admin',
        username: 'admin2',
        email: 'admin2@school.com',
        role: 'SCHOOL_ADMIN',
        schoolId: '2',
        status: 'ACTIVE',
        isActive: true,
        isFirstTime: false,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
    ];
  }

  void filterUsers({
    String? searchQuery,
    String? role,
    String? schoolId,
    String? status,
  }) {
    _filteredUsers = _users.where((user) {
      // Search filter
      if (searchQuery != null && searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        if (!user.fullName.toLowerCase().contains(query) &&
            !user.username.toLowerCase().contains(query) &&
            !user.email.toLowerCase().contains(query) &&
            !user.mobileNumber.contains(query)) {
          return false;
        }
      }

      // Role filter
      if (role != null && role.isNotEmpty && user.role != role) {
        return false;
      }

      // School filter
      if (schoolId != null && schoolId.isNotEmpty && user.schoolId != schoolId) {
        return false;
      }

      // Status filter
      if (status != null && status.isNotEmpty && user.status != status) {
        return false;
      }

      return true;
    }).toList();

    notifyListeners();
  }

  void _applyCurrentFilters() {
    // Apply any existing filters
    filterUsers();
  }

  // Permission checking
  bool currentUserHasPermission(Permission permission) {
    final currentUser = _authProvider.user;
    if (currentUser == null) return false;
    
    final userRole = currentUser['role'] as String?;
    if (userRole == null) return false;
    
    return RolePermissions.hasPermission(userRole, permission);
  }

  // User management operations
  Future<bool> deleteUser(String userId) async {
    try {
      _setLoading(true);
      _clearError();

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Remove from local list
      _users.removeWhere((user) => user.id == userId);
      _applyCurrentFilters();

      return true;
    } catch (e) {
      _setError('Failed to delete user: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> changeUserStatus(String userId, String newStatus) async {
    try {
      _setLoading(true);
      _clearError();

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Update local list
      final userIndex = _users.indexWhere((user) => user.id == userId);
      if (userIndex != -1) {
        _users[userIndex] = _users[userIndex].copyWith(
          status: newStatus,
          updatedAt: DateTime.now(),
        );
        _applyCurrentFilters();
      }

      return true;
    } catch (e) {
      _setError('Failed to change user status: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> changeUserRole(String userId, String newRole) async {
    try {
      _setLoading(true);
      _clearError();

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Update local list
      final userIndex = _users.indexWhere((user) => user.id == userId);
      if (userIndex != -1) {
        _users[userIndex] = _users[userIndex].copyWith(
          role: newRole,
          updatedAt: DateTime.now(),
        );
        _applyCurrentFilters();
      }

      return true;
    } catch (e) {
      _setError('Failed to change user role: $e');
      return false;
    } finally {
      _setLoading(false);
    }
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
}