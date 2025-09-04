import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../models/homework.dart';
import 'multi_school_provider.dart';
import '../services/api_service.dart';
import '../services/homework_api_service.dart';
class HomeworkProvider extends ChangeNotifier {
  List<Homework> _assignments = [];
  bool _isLoading = false;
  String? _error;
  
  static const String _assignmentsKey = 'homework_assignments';
  
  late final ApiService _apiService;
  late final HomeworkApiService _homeworkApiService;

  // Get current school ID - simplified approach
  String get _getCurrentSchoolId {
    return '1'; // Default school ID
  }

  // Getters
  List<Homework> get assignments => _assignments;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Initialize with persistent storage
  HomeworkProvider() {
    _initializeServices();
    _loadData();
  }

  void _initializeServices() {
    _apiService = ApiService();
    _apiService.initialize();
    _homeworkApiService = HomeworkApiService(_apiService.dio);
  }

  // Load data from API or persistent storage
  Future<void> _loadData() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Try to load from API first (when school context is available)
      try {
        // TODO: Get school ID from context when available
        final schoolId = 1; // Default school ID
        final assignments = await _homeworkApiService.getAllAssignments(schoolId);
        _assignments = assignments;
        await _saveAssignments(); // Save to local storage for offline access
      } catch (e) {
        // If API fails, load from local storage
        final prefs = await SharedPreferences.getInstance();
        final assignmentsJson = prefs.getString(_assignmentsKey);
        if (assignmentsJson != null) {
          final List<dynamic> decoded = json.decode(assignmentsJson);
          _assignments = decoded.map((json) => Homework.fromJson(json)).toList();
        } else {
          _loadMockData();
        }
      }
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load homework data: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Save assignments to persistent storage
  Future<void> _saveAssignments() async {
    final prefs = await SharedPreferences.getInstance();
    final assignmentsJson = json.encode(_assignments.map((hw) => hw.toJson()).toList());
    await prefs.setString(_assignmentsKey, assignmentsJson);
  }

  // Refresh homework data from API
  Future<void> refreshHomeworkData() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final currentSchoolId = _getCurrentSchoolId;
      final assignments = await _homeworkApiService.getAllAssignments(int.parse(currentSchoolId));
      _assignments = assignments;
      
      await _saveAssignments(); // Save to local storage for offline access
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to refresh homework data: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  void _loadMockData() {
    _assignments = [
      Homework(
        id: '1',
        title: 'Mathematics Chapter 5',
        description: 'Complete exercises 1-20 from Chapter 5. Focus on quadratic equations.',
        subject: 'Mathematics',
        className: '10A',
        section: 'A',
        dueDate: DateTime.parse('2024-01-25'),
        assignedDate: DateTime.parse('2024-01-20'),
        teacherId: '1',
        teacherName: 'Mr. Johnson',
        status: 'Active',
        schoolId: '1',
        createdAt: DateTime.now(),
      ),
      Homework(
        id: '2',
        title: 'English Essay Writing',
        description: 'Write a 500-word essay on "The Importance of Education in Modern Society".',
        subject: 'English',
        className: '9B',
        section: 'B',
        dueDate: DateTime.parse('2024-01-28'),
        assignedDate: DateTime.parse('2024-01-22'),
        teacherId: '2',
        teacherName: 'Ms. Davis',
        status: 'Active',
        schoolId: '1',
        createdAt: DateTime.now(),
      ),
      Homework(
        id: '3',
        title: 'Science Lab Report',
        description: 'Complete lab report for the chemistry experiment conducted last week.',
        subject: 'Science',
        className: '11C',
        section: 'C',
        dueDate: DateTime.parse('2024-01-30'),
        assignedDate: DateTime.parse('2024-01-23'),
        teacherId: '3',
        teacherName: 'Dr. Wilson',
        status: 'Active',
        schoolId: '1',
        createdAt: DateTime.now(),
      ),
    ];
  }

  // Load homework from API
  Future<void> loadHomework() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));
      // Data is already loaded from persistent storage
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add new assignment
  Future<void> addAssignment(Map<String, dynamic> assignmentData, BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Get current school context
      final multiSchoolProvider = context.read<MultiSchoolProvider>();
      final currentSchoolId = multiSchoolProvider.currentSchoolId;
      
      if (currentSchoolId == null) {
        throw Exception('No school context available');
      }
      
      final newAssignment = Homework(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: assignmentData['title'] ?? '',
        description: assignmentData['description'] ?? '',
        subject: assignmentData['subject'] ?? '',
        className: assignmentData['className'] ?? assignmentData['class'] ?? '',
        section: assignmentData['section'] ?? 'A',
        dueDate: DateTime.tryParse(assignmentData['dueDate'] ?? '') ?? DateTime.now(),
        assignedDate: DateTime.now(),
        teacherId: assignmentData['teacherId']?.toString() ?? '',
        teacherName: assignmentData['teacherName'] ?? '',
        status: 'Active',
        schoolId: currentSchoolId,
        createdAt: DateTime.now(),
      );
      
      _assignments.add(newAssignment);
      await _saveAssignments(); // Save to persistent storage
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update assignment
  Future<void> updateAssignment(Map<String, dynamic> assignmentData) async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      final id = assignmentData['id'];
      final index = _assignments.indexWhere((assignment) => assignment.id == id);
      if (index != -1) {
        final existingAssignment = _assignments[index];
        final updatedAssignment = existingAssignment.copyWith(
          title: assignmentData['title'] ?? existingAssignment.title,
          description: assignmentData['description'] ?? existingAssignment.description,
          subject: assignmentData['subject'] ?? existingAssignment.subject,
          className: assignmentData['className'] ?? assignmentData['class'] ?? existingAssignment.className,
          section: assignmentData['section'] ?? existingAssignment.section,
          dueDate: assignmentData['dueDate'] != null 
              ? DateTime.tryParse(assignmentData['dueDate']) ?? existingAssignment.dueDate
              : existingAssignment.dueDate,
          teacherId: assignmentData['teacherId']?.toString() ?? existingAssignment.teacherId,
          teacherName: assignmentData['teacherName'] ?? existingAssignment.teacherName,
          status: assignmentData['status'] ?? existingAssignment.status,
        );
        
        _assignments[index] = updatedAssignment;
        await _saveAssignments(); // Save to persistent storage
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

  // Delete assignment
  Future<void> deleteAssignment(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      _assignments.removeWhere((assignment) => assignment.id == id);
      await _saveAssignments(); // Save to persistent storage
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get assignments by class
  List<Homework> getAssignmentsByClass(String className) {
    return _assignments.where((assignment) => assignment.className == className).toList();
  }

  // Get assignments by subject
  List<Homework> getAssignmentsBySubject(String subject) {
    return _assignments.where((assignment) => assignment.subject == subject).toList();
  }

  // Get assignments by teacher
  List<Homework> getAssignmentsByTeacher(String teacherId) {
    return _assignments.where((assignment) => assignment.teacherId == teacherId).toList();
  }



  // Clear all data (for testing)
  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_assignmentsKey);
    
    _assignments.clear();
    notifyListeners();
  }

  // Reset to mock data
  Future<void> resetToMockData() async {
    _loadMockData();
    await _saveAssignments();
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Load assignments (public method for external calls)
  Future<void> loadAssignments() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      await _loadData();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Filter by school context
  void filterBySchoolContext(String? schoolId) {
    if (schoolId == null) {
      // Show all data if no school context
      notifyListeners();
      return;
    }
    
    // Filter assignments by school
    final filteredAssignments = _assignments.where((hw) => hw.schoolId == schoolId).toList();
    
    // Update the filtered lists (you might want to add separate filtered lists)
    notifyListeners();
  }

  // Mock submissions data (for now)
  List<Map<String, dynamic>> get submissions => [
    {
      'id': '1',
      'homeworkId': '1',
      'studentId': '1',
      'studentName': 'John Doe',
      'submittedAt': DateTime.now().subtract(const Duration(days: 1)),
      'content': 'Completed exercises 1-20',
      'status': 'Submitted',
    },
    {
      'id': '2',
      'homeworkId': '1',
      'studentId': '2',
      'studentName': 'Sarah Smith',
      'submittedAt': DateTime.now().subtract(const Duration(hours: 12)),
      'content': 'Completed exercises 1-20',
      'status': 'Submitted',
    },
  ];

  // Mock grades data (for now)
  List<Map<String, dynamic>> get grades => [
    {
      'id': '1',
      'homeworkId': '1',
      'studentId': '1',
      'studentName': 'John Doe',
      'score': 85,
      'maxScore': 100,
      'feedback': 'Good work, but check your calculations',
      'gradedAt': DateTime.now().subtract(const Duration(hours: 6)),
    },
    {
      'id': '2',
      'homeworkId': '1',
      'studentId': '2',
      'studentName': 'Sarah Smith',
      'score': 92,
      'maxScore': 100,
      'feedback': 'Excellent work!',
      'gradedAt': DateTime.now().subtract(const Duration(hours: 4)),
    },
  ];

  // Load submissions (mock method)
  Future<void> loadSubmissions() async {
    // Mock implementation - in real app, this would load from API
    await Future.delayed(const Duration(milliseconds: 300));
    notifyListeners();
  }

  // Load grades (mock method)
  Future<void> loadGrades() async {
    // Mock implementation - in real app, this would load from API
    await Future.delayed(const Duration(milliseconds: 300));
    notifyListeners();
  }

  // Get assignments for current school
  List<Homework> getAssignmentsForCurrentSchool(String? schoolId) {
    if (schoolId == null) return [];
    return _assignments.where((hw) => hw.schoolId == schoolId).toList();
  }
}

