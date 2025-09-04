import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../models/student.dart';
import '../services/api_service.dart';
import '../providers/multi_school_provider.dart';
class StudentProvider extends ChangeNotifier {
  List<Student> _students = [];
  List<Student> _filteredStudents = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';
  
  // Multi-school support - can be updated without context
  String _currentSchoolId = '1';
  
  // Get current school ID - simplified approach
  String get _getCurrentSchoolId {
    return _currentSchoolId;
  }
  
  static const String _storageKey = 'students_data';
  final ApiService _apiService = ApiService();

  // Getters
  List<Student> get students => _filteredStudents;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;

  // Initialize
  StudentProvider() {
    _apiService.initialize();
    _loadData();
  }

  // Load data from API or persistent storage
  Future<void> _loadData() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Try to load from local storage first
      final prefs = await SharedPreferences.getInstance();
      final studentsJson = prefs.getString(_storageKey);
      
      if (studentsJson != null) {
        final List<dynamic> decoded = json.decode(studentsJson);
        _students = decoded.map((json) => Student.fromJson(json)).toList();
      } else {
        // Load mock data if no stored data exists
        _loadMockData();
      }
      
      // Now try to load from API
      await _loadAllStudentsFromAPI();
      
      _applySearchFilter();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load students: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load students from API for current school
  Future<void> _loadAllStudentsFromAPI() async {
    try {
      final currentSchoolId = _getCurrentSchoolId;
      print('Loading students for school ID: $currentSchoolId');
      final response = await _apiService.dio.get('/api/students?schoolId=$currentSchoolId');
      if (response.statusCode == 200) {
        final List<dynamic> studentsData = response.data;
        _students = studentsData.map((json) => Student.fromJson(json)).toList();
        await _saveData(); // Save to local storage
        print('Successfully loaded ${_students.length} students for school $currentSchoolId');
      }
    } catch (e) {
      print('Failed to load students for school $currentSchoolId: $e');
      // Keep existing data if API call fails
    }
  }

  // Load students from API with school context (for future multi-school support)
  Future<void> _loadStudentsFromAPIWithSchool(BuildContext context) async {
    try {
      final currentSchoolId = Provider.of<MultiSchoolProvider>(context, listen: false).currentSchool?.id?.toString() ?? '1';
      print('Loading students for school ID: $currentSchoolId');
      
      final response = await _apiService.dio.get('/api/students?schoolId=$currentSchoolId');
      if (response.statusCode == 200) {
        final List<dynamic> studentsData = response.data;
        _students = studentsData.map((json) => Student.fromJson(json)).toList();
        await _saveData();
        print('Successfully loaded ${_students.length} students for school $currentSchoolId');
      }
    } catch (e) {
      print('Failed to load students for school from API: $e');
      // Keep existing data if API call fails
    }
  }

  // Save data to persistent storage
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final studentsJson = json.encode(_students.map((student) => student.toJson()).toList());
    await prefs.setString(_storageKey, studentsJson);
  }

  void _loadMockData() {
    _students = [
      Student(
        id: '1',
        name: 'John Doe',
        className: '10A',
        section: 'A',
        rollNumber: '1001',
        fatherName: 'Mike Doe',
        fatherPhone: '+1234567891',
        parentEmail: 'john.doe@email.com',
        motherName: 'Jane Doe',
        motherPhone: '+1234567892',
        address: '123 Main St, City, State',
        email: 'john.doe@email.com',
        dateOfBirth: DateTime.parse('2008-05-15'),
        gender: 'Male',
        admissionDate: DateTime.parse('2023-09-01'),
        isActive: true,
        schoolId: '1',
        kidAadhaar: '123456789012',
        pen: 'PEN001',
        fatherAadhaar: '987654321098',
        motherAadhaar: '876543210987',
        caste: 'General',
        category: 'General',
        parentLoginCode: 'ABC123',
        parentLoginCodeUsed: false,
      ),
      Student(
        id: '2',
        name: 'Sarah Smith',
        className: '9B',
        section: 'B',
        rollNumber: '2001',
        fatherName: 'David Smith',
        fatherPhone: '+1234567893',
        parentEmail: 'sarah.smith@email.com',
        motherName: 'Lisa Smith',
        motherPhone: '+1234567894',
        address: '456 Oak Ave, City, State',
        email: 'sarah.smith@email.com',
        dateOfBirth: DateTime.parse('2009-03-20'),
        gender: 'Female',
        admissionDate: DateTime.parse('2023-09-01'),
        isActive: true,
        schoolId: '1',
        kidAadhaar: '234567890123',
        pen: 'PEN002',
        fatherAadhaar: '876543210987',
        motherAadhaar: '765432109876',
        caste: 'OBC',
        category: 'OBC',
        parentLoginCode: 'DEF456',
        parentLoginCodeUsed: false,
      ),
      Student(
        id: '3',
        name: 'Michael Johnson',
        className: '11C',
        section: 'C',
        rollNumber: '3001',
        fatherName: 'Robert Johnson',
        fatherPhone: '+1234567895',
        parentEmail: 'michael.johnson@email.com',
        motherName: 'Patricia Johnson',
        motherPhone: '+1234567896',
        address: '789 Pine Rd, City, State',
        email: 'michael.johnson@email.com',
        dateOfBirth: DateTime.parse('2007-08-10'),
        gender: 'Male',
        admissionDate: DateTime.parse('2023-09-01'),
        isActive: true,
        schoolId: '1',
        kidAadhaar: '345678901234',
        pen: 'PEN003',
        fatherAadhaar: '765432109876',
        motherAadhaar: '654321098765',
        caste: 'SC',
        category: 'SC',
        parentLoginCode: 'GHI789',
        parentLoginCodeUsed: false,
      ),
      Student(
        id: '4',
        name: 'Emily Davis',
        className: '8A',
        section: 'A',
        rollNumber: '4001',
        fatherName: 'James Davis',
        fatherPhone: '+1234567897',
        parentEmail: 'emily.davis@email.com',
        motherName: 'Mary Davis',
        motherPhone: '+1234567898',
        address: '321 Elm St, City, State',
        email: 'emily.davis@email.com',
        dateOfBirth: DateTime.parse('2010-12-05'),
        gender: 'Female',
        admissionDate: DateTime.parse('2023-09-01'),
        isActive: true,
        schoolId: '1',
        kidAadhaar: '456789012345',
        pen: 'PEN004',
        fatherAadhaar: '654321098765',
        motherAadhaar: '543210987654',
        caste: 'ST',
        category: 'ST',
        parentLoginCode: 'JKL012',
        parentLoginCodeUsed: false,
      ),
      Student(
        id: '5',
        name: 'David Wilson',
        className: '12D',
        section: 'D',
        rollNumber: '5001',
        fatherName: 'Thomas Wilson',
        fatherPhone: '+1234567899',
        parentEmail: 'david.wilson@email.com',
        motherName: 'Helen Wilson',
        motherPhone: '+1234567900',
        address: '654 Maple Dr, City, State',
        email: 'david.wilson@email.com',
        dateOfBirth: DateTime.parse('2006-06-15'),
        gender: 'Male',
        admissionDate: DateTime.parse('2023-09-01'),
        isActive: true,
        schoolId: '1',
        kidAadhaar: '567890123456',
        pen: 'PEN005',
        fatherAadhaar: '543210987654',
        motherAadhaar: '432109876543',
        caste: 'EWS',
        category: 'EWS',
        parentLoginCode: 'MNO345',
        parentLoginCodeUsed: false,
      ),
    ];
  }

  // Load students from API
  Future<void> loadStudents([BuildContext? context]) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (context != null) {
        // Try to load with school context first
        await _loadStudentsFromAPIWithSchool(context);
      } else {
        // Fallback to loading all students
        await _loadAllStudentsFromAPI();
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add new student
  Future<void> addStudent(Map<String, dynamic> studentData) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Create the student data for API call
      final apiData = {
        'name': studentData['name'] ?? '',
        'className': studentData['className'] ?? studentData['class'] ?? '',
        'section': studentData['section'] ?? '',
        'rollNumber': studentData['rollNumber'] ?? '',
        'fatherName': studentData['parentName'] ?? '',
        'fatherPhone': studentData['parentPhone'] ?? '',
        'parentEmail': studentData['parentEmail'] ?? '',
        'motherName': studentData['motherName'] ?? '',
        'motherPhone': studentData['motherPhone'] ?? '',
        'address': studentData['address'] ?? '',
        'email': studentData['email'] ?? '',
        'dateOfBirth': studentData['dateOfBirth'] ?? DateTime.now().toIso8601String(),
        'gender': studentData['gender'] ?? 'Other',
        'kidAadhaar': studentData['kidAadhaar'] ?? '123456789012',
        'pen': studentData['pen'] ?? 'PEN${DateTime.now().millisecondsSinceEpoch}',
        'fatherAadhaar': studentData['fatherAadhaar'] ?? '987654321098',
        'motherAadhaar': studentData['motherAadhaar'] ?? '876543210987',
        'caste': studentData['caste'] ?? 'General',
        'category': studentData['category'] ?? 'General',
        'schoolId': int.parse(_getCurrentSchoolId), // Convert to Long for backend
      };

      // Call the backend API
      final response = await _apiService.dio.post('/api/students', data: apiData);
      
      if (response.statusCode == 200) {
        // API call successful, add to local list
        final newStudent = Student.fromJson(response.data);
        _students.add(newStudent);
        await _saveData();
        _applySearchFilter();
        notifyListeners();
        print('Student created successfully via API: ${newStudent.name}');
      } else {
        throw Exception('Failed to create student: ${response.statusCode}');
      }
    } catch (e) {
      _error = e.toString();
      print('Error creating student: $e');
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update student
  Future<void> updateStudent(Map<String, dynamic> studentData) async {
    _isLoading = true;
    notifyListeners();

    try {
      final id = studentData['id'];
      
      // Create the student data for API call
      final apiData = {
        'id': int.parse(id), // Convert to Long for backend
        'name': studentData['name'] ?? '',
        'className': studentData['className'] ?? studentData['class'] ?? '',
        'section': studentData['section'] ?? '',
        'rollNumber': studentData['rollNumber'] ?? '',
        'fatherName': studentData['parentName'] ?? '',
        'fatherPhone': studentData['parentPhone'] ?? '',
        'parentEmail': studentData['parentEmail'] ?? '',
        'motherName': studentData['motherName'] ?? '',
        'motherPhone': studentData['motherPhone'] ?? '',
        'address': studentData['address'] ?? '',
        'email': studentData['email'] ?? '',
        'dateOfBirth': studentData['dateOfBirth'] ?? DateTime.now().toIso8601String(),
        'gender': studentData['gender'] ?? 'Other',
        'kidAadhaar': studentData['kidAadhaar'] ?? '123456789012',
        'pen': studentData['pen'] ?? 'PEN${DateTime.now().millisecondsSinceEpoch}',
        'fatherAadhaar': studentData['fatherAadhaar'] ?? '987654321098',
        'motherAadhaar': studentData['motherAadhaar'] ?? '876543210987',
        'caste': studentData['caste'] ?? 'General',
        'category': studentData['category'] ?? 'General',
      };

      // Call the backend API
      final response = await _apiService.dio.put('/api/students/$id', data: apiData);
      
      if (response.statusCode == 200) {
        // API call successful, update local list
        final updatedStudent = Student.fromJson(response.data);
        final index = _students.indexWhere((student) => student.id == id);
        if (index != -1) {
          _students[index] = updatedStudent;
          await _saveData();
          _applySearchFilter();
          notifyListeners();
          print('Student updated successfully via API: ${updatedStudent.name}');
        }
      } else {
        throw Exception('Failed to update student: ${response.statusCode}');
      }
    } catch (e) {
      _error = e.toString();
      print('Error updating student: $e');
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Delete student
  Future<void> deleteStudent(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Call the backend API
      final response = await _apiService.dio.delete('/api/students/$id');
      
      if (response.statusCode == 204) { // 204 No Content for successful deletion
        // API call successful, remove from local list
        _students.removeWhere((student) => student.id == id);
        await _saveData();
        _applySearchFilter();
        notifyListeners();
        print('Student deleted successfully via API: ID $id');
      } else {
        throw Exception('Failed to delete student: ${response.statusCode}');
      }
    } catch (e) {
      _error = e.toString();
      print('Error deleting student: $e');
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Search students
  void searchStudents(String query) {
    _searchQuery = query;
    _applySearchFilter();
    notifyListeners();
  }

  void _applySearchFilter() {
    if (_searchQuery.isEmpty) {
      _filteredStudents = List.from(_students);
    } else {
      _filteredStudents = _students.where((student) {
        final query = _searchQuery.toLowerCase();
        return student.name.toLowerCase().contains(query) ||
               student.email.toLowerCase().contains(query) ||
               student.className.toLowerCase().contains(query) ||
               student.fatherName.toLowerCase().contains(query);
      }).toList();
    }
  }

  // Get student by ID
  Student? getStudentById(String id) {
    try {
      return _students.firstWhere((student) => student.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get students by class
  List<Student> getStudentsByClass(String className) {
    return _students.where((student) => student.className == className).toList();
  }

  // Get students by status
  List<Student> getStudentsByStatus(String status) {
    return _students.where((student) => student.isActive == (status == 'Active')).toList();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Get class list
  List<String> getClassList() {
    final classes = _students.map((student) => student.className).toSet().toList();
    classes.sort();
    return classes;
  }

  // Get section list
  List<String> getSectionList() {
    final sections = _students.map((student) => student.section).toSet().toList();
    sections.sort();
    return sections;
  }

  // Multi-school support methods
  String get currentSchoolId => _currentSchoolId;
  
  void setCurrentSchool(String schoolId) {
    _currentSchoolId = schoolId;
    // Reload students for the new school
    _loadData();
  }

  // Refresh from API
  Future<void> refreshFromAPI([BuildContext? context]) async {
    if (context != null) {
      await _loadStudentsFromAPIWithSchool(context);
    } else {
      await _loadAllStudentsFromAPI();
    }
    _applySearchFilter();
    notifyListeners();
  }

  // Load students for a specific school
  Future<void> loadStudentsForSchool(String schoolId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      print('Loading students for school ID: $schoolId');
      final response = await _apiService.dio.get('/api/students?schoolId=$schoolId');
      if (response.statusCode == 200) {
        final List<dynamic> studentsData = response.data;
        _students = studentsData.map((json) => Student.fromJson(json)).toList();
        await _saveData();
        _applySearchFilter();
        print('Successfully loaded ${_students.length} students for school $schoolId');
      }
    } catch (e) {
      _error = e.toString();
      print('Failed to load students for school $schoolId: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

