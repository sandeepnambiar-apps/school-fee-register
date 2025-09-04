import 'package:flutter/material.dart';

class StudentProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _students = [];
  List<Map<String, dynamic>> _filteredStudents = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';

  // Getters
  List<Map<String, dynamic>> get students => _filteredStudents;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;

  // Initialize with mock data
  StudentProvider() {
    _loadMockData();
  }

  void _loadMockData() {
    _students = [
      {
        'id': 1,
        'name': 'John Doe',
        'email': 'john.doe@email.com',
        'phone': '+1234567890',
        'class': '10A',
        'section': 'A',
        'admissionDate': '2023-09-01',
        'parentName': 'Mike Doe',
        'parentPhone': '+1234567891',
        'address': '123 Main St, City, State',
        'status': 'Active',
      },
      {
        'id': 2,
        'name': 'Sarah Smith',
        'email': 'sarah.smith@email.com',
        'phone': '+1234567892',
        'class': '9B',
        'section': 'B',
        'admissionDate': '2023-09-01',
        'parentName': 'David Smith',
        'parentPhone': '+1234567893',
        'address': '456 Oak Ave, City, State',
        'status': 'Active',
      },
      {
        'id': 3,
        'name': 'Michael Johnson',
        'email': 'michael.johnson@email.com',
        'phone': '+1234567894',
        'class': '11C',
        'section': 'C',
        'admissionDate': '2023-09-01',
        'parentName': 'Robert Johnson',
        'parentPhone': '+1234567895',
        'address': '789 Pine Rd, City, State',
        'status': 'Active',
      },
      {
        'id': 4,
        'name': 'Emily Davis',
        'email': 'emily.davis@email.com',
        'phone': '+1234567896',
        'class': '8A',
        'section': 'A',
        'admissionDate': '2023-09-01',
        'parentName': 'James Davis',
        'parentPhone': '+1234567897',
        'address': '321 Elm St, City, State',
        'status': 'Active',
      },
      {
        'id': 5,
        'name': 'David Wilson',
        'email': 'david.wilson@email.com',
        'phone': '+1234567898',
        'class': '12D',
        'section': 'D',
        'admissionDate': '2023-09-01',
        'parentName': 'Thomas Wilson',
        'parentPhone': '+1234567899',
        'address': '654 Maple Dr, City, State',
        'status': 'Active',
      },
    ];
    _filteredStudents = List.from(_students);
  }

  // Load students from API
  Future<void> loadStudents() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));
      _loadMockData();
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
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      final newStudent = {
        ...studentData,
        'id': _students.length + 1,
        'status': 'Active',
      };
      
      _students.add(newStudent);
      _applySearchFilter();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
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
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      final id = studentData['id'];
      final index = _students.indexWhere((student) => student['id'].toString() == id.toString());
      if (index != -1) {
        _students[index] = {
          ..._students[index],
          ...studentData,
          'id': id,
        };
        _applySearchFilter();
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Delete student
  Future<void> deleteStudent(int id) async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      _students.removeWhere((student) => student['id'] == id);
      _applySearchFilter();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
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
        return student['name'].toString().toLowerCase().contains(query) ||
               student['email'].toString().toLowerCase().contains(query) ||
               student['class'].toString().toLowerCase().contains(query) ||
               student['parentName'].toString().toLowerCase().contains(query);
      }).toList();
    }
  }

  // Get student by ID
  Map<String, dynamic>? getStudentById(int id) {
    try {
      return _students.firstWhere((student) => student['id'] == id);
    } catch (e) {
      return null;
    }
  }

  // Get students by class
  List<Map<String, dynamic>> getStudentsByClass(String className) {
    return _students.where((student) => student['class'] == className).toList();
  }

  // Get students by status
  List<Map<String, dynamic>> getStudentsByStatus(String status) {
    return _students.where((student) => student['status'] == status).toList();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Get class list
  List<String> getClassList() {
    final classes = _students.map((student) => student['class'].toString()).toSet().toList();
    classes.sort();
    return classes;
  }

  // Get section list
  List<String> getSectionList() {
    final sections = _students.map((student) => student['section'].toString()).toSet().toList();
    sections.sort();
    return sections;
  }
}

