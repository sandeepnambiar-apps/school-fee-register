import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/school.dart';
import '../services/api_service.dart';
import '../services/school_api_service.dart';

class MultiSchoolProvider extends ChangeNotifier {
  static const String _currentSchoolIdKey = 'current_school_id';
  static const String _schoolsKey = 'schools';
  static const String _superAdminKey = 'super_admin';

  List<School> _schools = [];
  School? _currentSchool;
  bool _isSuperAdmin = false;
  bool _isLoading = false;
  String? _error;

  late final ApiService _apiService;
  late final SchoolApiService _schoolApiService;

  // Getters
  List<School> get schools => _schools;
  School? get currentSchool => _currentSchool;
  bool get isSuperAdmin => _isSuperAdmin;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasSchools => _schools.isNotEmpty;
  bool get hasSchoolContext => _currentSchool != null;
  String? get currentSchoolId => _currentSchool?.id;

  MultiSchoolProvider() {
    _initializeServices();
    _loadData();
  }

  void _initializeServices() {
    _apiService = ApiService();
    _apiService.initialize();
    _schoolApiService = SchoolApiService(_apiService.dio);
  }

  // Load schools from API
  Future<void> _loadSchoolsFromApi() async {
    try {
      final schools = await _schoolApiService.getAllSchools();
      _schools = schools;
      await _saveData(); // Save to local storage for offline access
    } catch (e) {
      // If API fails, try to load from local storage
      final prefs = await SharedPreferences.getInstance();
      final schoolsJson = prefs.getStringList(_schoolsKey) ?? [];
      _schools = schoolsJson
          .map((json) => School.fromJson(Map<String, dynamic>.from(
              Map.fromEntries(json.split(',').map((e) {
                final parts = e.split(':');
                return MapEntry(parts[0], parts.sublist(1).join(':'));
              }))
          )))
          .toList();
      
      // If no schools in local storage, create default
      if (_schools.isEmpty) {
        _schools = [_createDefaultSchool()];
      }
    }
  }

  // Load data from SharedPreferences and API
  Future<void> _loadData() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      
      // Load super admin status
      _isSuperAdmin = prefs.getBool(_superAdminKey) ?? false;
      
      // Load schools from API
      await _loadSchoolsFromApi();
      
      // Load current school from preferences
      final currentSchoolId = prefs.getString(_currentSchoolIdKey);
      if (currentSchoolId != null) {
        _currentSchool = _schools.firstWhere(
          (school) => school.id == currentSchoolId,
          orElse: () => _schools.isNotEmpty ? _schools.first : _createDefaultSchool(),
        );
      } else if (_schools.isNotEmpty) {
        _currentSchool = _schools.first;
        await _saveCurrentSchoolId(_currentSchool!.id);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load school data: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Save data to SharedPreferences
  Future<void> _saveData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Save schools
      final schoolsJson = _schools.map((school) {
        final json = school.toJson();
        return json.entries.map((e) => '${e.key}:${e.value}').join(',');
      }).toList();
      await prefs.setStringList(_schoolsKey, schoolsJson);
      
      // Save super admin status
      await prefs.setBool(_superAdminKey, _isSuperAdmin);
    } catch (e) {
      _error = 'Failed to save school data: $e';
      notifyListeners();
    }
  }

  // Save current school ID
  Future<void> _saveCurrentSchoolId(String schoolId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_currentSchoolIdKey, schoolId);
    } catch (e) {
      _error = 'Failed to save current school ID: $e';
      notifyListeners();
    }
  }

  // Refresh schools from API
  Future<void> refreshSchools() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();
      
      await _loadSchoolsFromApi();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to refresh schools: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create default school for demo
  School _createDefaultSchool() {
    return School(
      id: 'default_school',
      name: 'Demo School',
      schoolCode: 'DEMO',
      address: '123 Demo Street, Demo City',
      city: 'Demo City',
      state: 'Demo State',
      country: 'Demo Country',
      postalCode: '12345',
      phone: '+1-234-567-8900',
      email: 'demo@school.com',
      website: 'www.demoschool.com',
      principalName: 'Dr. John Principal',
      principalPhone: '+1-234-567-8901',
      principalEmail: 'principal@demoschool.com',
      status: 'ACTIVE',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  // Initialize with demo data
  Future<void> initializeWithDemoData() async {
    if (_schools.isNotEmpty) return; // Already has data

    final demoSchool = _createDefaultSchool();
    _schools = [demoSchool];
    _currentSchool = demoSchool;
    _isSuperAdmin = true;
    
    await _saveData();
    await _saveCurrentSchoolId(demoSchool.id);
    notifyListeners();
  }

  // Add new school (Super Admin only)
  Future<void> addSchool(School school) async {
    if (!_isSuperAdmin) {
      _error = 'Only Super Admin can add schools';
      notifyListeners();
      return;
    }

    try {
      _schools.add(school);
      await _saveData();
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to add school: $e';
      notifyListeners();
    }
  }

  // Update school
  Future<void> updateSchool(School updatedSchool) async {
    try {
      final index = _schools.indexWhere((school) => school.id == updatedSchool.id);
      if (index != -1) {
        _schools[index] = updatedSchool;
        
        // Update current school if it's the one being updated
        if (_currentSchool?.id == updatedSchool.id) {
          _currentSchool = updatedSchool;
        }
        
        await _saveData();
        _error = null;
        notifyListeners();
      }
    } catch (e) {
      _error = 'Failed to update school: $e';
      notifyListeners();
    }
  }

  // Delete school (Super Admin only)
  Future<void> deleteSchool(String schoolId) async {
    if (!_isSuperAdmin) {
      _error = 'Only Super Admin can delete schools';
      notifyListeners();
      return;
    }

    try {
      _schools.removeWhere((school) => school.id == schoolId);
      
      // If current school is deleted, switch to first available
      if (_currentSchool?.id == schoolId) {
        _currentSchool = _schools.isNotEmpty ? _schools.first : null;
        if (_currentSchool != null) {
          await _saveCurrentSchoolId(_currentSchool!.id);
        }
      }
      
      await _saveData();
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to delete school: $e';
      notifyListeners();
    }
  }

  // Switch to different school
  Future<void> switchSchool(String schoolId) async {
    try {
      final school = _schools.firstWhere((school) => school.id == schoolId);
      _currentSchool = school;
      await _saveCurrentSchoolId(schoolId);
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to switch school: $e';
      notifyListeners();
    }
  }

  // Get school by ID
  School? getSchoolById(String schoolId) {
    try {
      return _schools.firstWhere((school) => school.id == schoolId);
    } catch (e) {
      return null;
    }
  }

  // Check if user has access to school
  bool hasAccessToSchool(String schoolId) {
    if (_isSuperAdmin) return true;
    return _currentSchool?.id == schoolId;
  }

  // Clear all data
  Future<void> clearAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_currentSchoolIdKey);
      await prefs.remove(_schoolsKey);
      await prefs.remove(_superAdminKey);
      
      _schools.clear();
      _currentSchool = null;
      _isSuperAdmin = false;
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to clear data: $e';
      notifyListeners();
    }
  }

  // Reset to demo data
  Future<void> resetToDemoData() async {
    await clearAllData();
    await initializeWithDemoData();
  }


}
