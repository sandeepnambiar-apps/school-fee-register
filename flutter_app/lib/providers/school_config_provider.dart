import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SchoolConfigProvider extends ChangeNotifier {
  static const String _schoolNameKey = 'school_name';
  static const String _schoolAddressKey = 'school_address';
  static const String _schoolPhoneKey = 'school_phone';
  static const String _schoolEmailKey = 'school_email';
  static const String _schoolLogoKey = 'school_logo';
  
  String _schoolName = 'School System';
  String _schoolAddress = '';
  String _schoolPhone = '';
  String _schoolEmail = '';
  String _schoolLogo = '';
  String? _error;
  bool _isLoading = false;

  // Getters
  String get schoolName => _schoolName;
  String get schoolAddress => _schoolAddress;
  String get schoolPhone => _schoolPhone;
  String get schoolEmail => _schoolEmail;
  String get schoolLogo => _schoolLogo;
  String? get error => _error;
  bool get isLoading => _isLoading;

  SchoolConfigProvider() {
    _loadConfig();
  }

  // Load configuration from persistent storage
  Future<void> _loadConfig() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      
      _schoolName = prefs.getString(_schoolNameKey) ?? 'School System';
      _schoolAddress = prefs.getString(_schoolAddressKey) ?? '';
      _schoolPhone = prefs.getString(_schoolPhoneKey) ?? '';
      _schoolEmail = prefs.getString(_schoolEmailKey) ?? '';
      _schoolLogo = prefs.getString(_schoolLogoKey) ?? '';

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load school configuration: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Save configuration to persistent storage
  Future<void> _saveConfig() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.setString(_schoolNameKey, _schoolName);
      await prefs.setString(_schoolAddressKey, _schoolAddress);
      await prefs.setString(_schoolPhoneKey, _schoolPhone);
      await prefs.setString(_schoolEmailKey, _schoolEmail);
      await prefs.setString(_schoolLogoKey, _schoolLogo);
      
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to save school configuration: $e';
      notifyListeners();
    }
  }

  // Update school name
  Future<void> updateSchoolName(String newName) async {
    if (newName.trim().isNotEmpty && newName != _schoolName) {
      _schoolName = newName.trim();
      await _saveConfig();
    }
  }

  // Update school address
  Future<void> updateSchoolAddress(String newAddress) async {
    if (newAddress != _schoolAddress) {
      _schoolAddress = newAddress;
      await _saveConfig();
    }
  }

  // Update school phone
  Future<void> updateSchoolPhone(String newPhone) async {
    if (newPhone != _schoolPhone) {
      _schoolPhone = newPhone;
      await _saveConfig();
    }
  }

  // Update school email
  Future<void> updateSchoolEmail(String newEmail) async {
    if (newEmail != _schoolEmail) {
      _schoolEmail = newEmail;
      await _saveConfig();
    }
  }

  // Update school logo
  Future<void> updateSchoolLogo(String newLogo) async {
    if (newLogo != _schoolLogo) {
      _schoolLogo = newLogo;
      await _saveConfig();
    }
  }

  // Update multiple settings at once
  Future<void> updateConfig({
    String? schoolName,
    String? schoolAddress,
    String? schoolPhone,
    String? schoolEmail,
    String? schoolLogo,
  }) async {
    bool hasChanges = false;
    
    if (schoolName != null && schoolName.trim().isNotEmpty && schoolName != _schoolName) {
      _schoolName = schoolName.trim();
      hasChanges = true;
    }
    
    if (schoolAddress != null && schoolAddress != _schoolAddress) {
      _schoolAddress = schoolAddress;
      hasChanges = true;
    }
    
    if (schoolPhone != null && schoolPhone != _schoolPhone) {
      _schoolPhone = schoolPhone;
      hasChanges = true;
    }
    
    if (schoolEmail != null && schoolEmail != _schoolEmail) {
      _schoolEmail = schoolEmail;
      hasChanges = true;
    }
    
    if (schoolLogo != null && schoolLogo != _schoolLogo) {
      _schoolLogo = schoolLogo;
      hasChanges = true;
    }
    
    if (hasChanges) {
      await _saveConfig();
    }
  }

  // Reset to default values
  Future<void> resetToDefaults() async {
    _schoolName = 'School System';
    _schoolAddress = '';
    _schoolPhone = '';
    _schoolEmail = '';
    _schoolLogo = '';
    await _saveConfig();
  }

  // Clear all configuration
  Future<void> clearConfig() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_schoolNameKey);
      await prefs.remove(_schoolAddressKey);
      await prefs.remove(_schoolPhoneKey);
      await prefs.remove(_schoolEmailKey);
      await prefs.remove(_schoolLogoKey);
      
      _schoolName = 'School System';
      _schoolAddress = '';
      _schoolPhone = '';
      _schoolEmail = '';
      _schoolLogo = '';
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to clear configuration: $e';
      notifyListeners();
    }
  }

  // Get configuration as a map
  Map<String, dynamic> getConfigMap() {
    return {
      'schoolName': _schoolName,
      'schoolAddress': _schoolAddress,
      'schoolPhone': _schoolPhone,
      'schoolEmail': _schoolEmail,
      'schoolLogo': _schoolLogo,
    };
  }

  // Set configuration from a map
  Future<void> setConfigFromMap(Map<String, dynamic> config) async {
    if (config.containsKey('schoolName')) {
      _schoolName = config['schoolName']?.toString() ?? 'School System';
    }
    if (config.containsKey('schoolAddress')) {
      _schoolAddress = config['schoolAddress']?.toString() ?? '';
    }
    if (config.containsKey('schoolPhone')) {
      _schoolPhone = config['schoolPhone']?.toString() ?? '';
    }
    if (config.containsKey('schoolEmail')) {
      _schoolEmail = config['schoolEmail']?.toString() ?? '';
    }
    if (config.containsKey('schoolLogo')) {
      _schoolLogo = config['schoolLogo']?.toString() ?? '';
    }
    
    await _saveConfig();
  }
}
