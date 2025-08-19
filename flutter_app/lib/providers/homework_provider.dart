import 'package:flutter/material.dart';

class HomeworkProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _assignments = [];
  List<Map<String, dynamic>> _submissions = [];
  List<Map<String, dynamic>> _grades = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Map<String, dynamic>> get assignments => _assignments;
  List<Map<String, dynamic>> get submissions => _submissions;
  List<Map<String, dynamic>> get grades => _grades;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Initialize with mock data
  HomeworkProvider() {
    _loadMockData();
  }

  void _loadMockData() {
    _assignments = [
      {
        'id': 1,
        'title': 'Mathematics Chapter 5',
        'description': 'Complete exercises 1-20 from Chapter 5. Focus on quadratic equations.',
        'subject': 'Mathematics',
        'class': '10A',
        'dueDate': '2024-01-25',
        'assignedDate': '2024-01-20',
        'teacherId': 1,
        'teacherName': 'Mr. Johnson',
        'status': 'Active',
      },
      {
        'id': 2,
        'title': 'English Essay Writing',
        'description': 'Write a 500-word essay on "The Importance of Education in Modern Society".',
        'subject': 'English',
        'class': '9B',
        'dueDate': '2024-01-28',
        'assignedDate': '2024-01-22',
        'teacherId': 2,
        'teacherName': 'Ms. Davis',
        'status': 'Active',
      },
      {
        'id': 3,
        'title': 'Science Lab Report',
        'description': 'Complete lab report for the chemistry experiment conducted last week.',
        'subject': 'Science',
        'class': '11C',
        'dueDate': '2024-01-30',
        'assignedDate': '2024-01-23',
        'teacherId': 3,
        'teacherName': 'Dr. Wilson',
        'status': 'Active',
      },
    ];

    _submissions = [
      {
        'id': 1,
        'assignmentId': 1,
        'assignmentTitle': 'Mathematics Chapter 5',
        'studentId': 1,
        'studentName': 'John Doe',
        'submissionDate': '2024-01-24',
        'content': 'Completed all exercises 1-20 with detailed solutions.',
        'attachmentUrl': 'https://example.com/math_homework_1.pdf',
        'status': 'Submitted',
        'grade': null,
        'feedback': null,
      },
      {
        'id': 2,
        'assignmentId': 1,
        'assignmentTitle': 'Mathematics Chapter 5',
        'studentId': 2,
        'studentName': 'Sarah Smith',
        'submissionDate': '2024-01-25',
        'content': 'Completed exercises 1-18. Exercises 19-20 pending.',
        'attachmentUrl': 'https://example.com/math_homework_2.pdf',
        'status': 'Submitted',
        'grade': null,
        'feedback': null,
      },
      {
        'id': 3,
        'assignmentId': 2,
        'assignmentTitle': 'English Essay Writing',
        'studentId': 1,
        'studentName': 'John Doe',
        'submissionDate': '2024-01-27',
        'content': '500-word essay on education importance submitted.',
        'attachmentUrl': 'https://example.com/english_essay_1.pdf',
        'status': 'Submitted',
        'grade': null,
        'feedback': null,
      },
    ];

    _grades = [
      {
        'id': 1,
        'submissionId': 1,
        'assignmentId': 1,
        'studentId': 1,
        'studentName': 'John Doe',
        'assignmentTitle': 'Mathematics Chapter 5',
        'grade': 95,
        'maxGrade': 100,
        'feedback': 'Excellent work! All exercises completed correctly with proper methodology.',
        'gradedBy': 'Mr. Johnson',
        'gradedDate': '2024-01-26',
      },
    ];
  }

  // Load assignments from API
  Future<void> loadAssignments() async {
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

  // Load submissions from API
  Future<void> loadSubmissions() async {
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

  // Load grades from API
  Future<void> loadGrades() async {
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

  // Add new assignment
  Future<void> addAssignment(Map<String, dynamic> assignmentData) async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      final newAssignment = {
        ...assignmentData,
        'id': _assignments.length + 1,
        'assignedDate': DateTime.now().toIso8601String().split('T')[0],
        'teacherId': 1, // TODO: Get from auth
        'teacherName': 'Current Teacher', // TODO: Get from auth
      };
      
      _assignments.add(newAssignment);
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
      
      final assignmentId = assignmentData['id'];
      final index = _assignments.indexWhere((assignment) => assignment['id'].toString() == assignmentId.toString());
      if (index != -1) {
        _assignments[index] = {
          ..._assignments[index],
          ...assignmentData,
        };
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
  Future<void> deleteAssignment(int assignmentId) async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      _assignments.removeWhere((assignment) => assignment['id'] == assignmentId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Submit homework
  Future<void> submitHomework(Map<String, dynamic> submissionData) async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      final newSubmission = {
        ...submissionData,
        'id': _submissions.length + 1,
        'submissionDate': DateTime.now().toIso8601String().split('T')[0],
        'status': 'Submitted',
        'grade': null,
        'feedback': null,
      };
      
      _submissions.add(newSubmission);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Grade submission
  Future<void> gradeSubmission(int submissionId, Map<String, dynamic> gradeData) async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      final newGrade = {
        ...gradeData,
        'id': _grades.length + 1,
        'submissionId': submissionId,
        'gradedDate': DateTime.now().toIso8601String().split('T')[0],
      };
      
      _grades.add(newGrade);
      
      // Update submission with grade
      final submissionIndex = _submissions.indexWhere((sub) => sub['id'] == submissionId);
      if (submissionIndex != -1) {
        _submissions[submissionIndex]['grade'] = gradeData['grade'];
        _submissions[submissionIndex]['feedback'] = gradeData['feedback'];
      }
      
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update submission (e.g., add grade and feedback)
  Future<void> updateSubmission(Map<String, dynamic> submissionData) async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));
      
      final submissionId = submissionData['id'];
      final index = _submissions.indexWhere((sub) => sub['id'].toString() == submissionId.toString());
      if (index != -1) {
        _submissions[index] = {
          ..._submissions[index],
          ...submissionData,
        };
        
        // If grading, also add to grades list
        if (submissionData['grade'] != null) {
          final gradeData = {
            'id': _grades.length + 1,
            'submissionId': int.parse(submissionId.toString()),
            'assignmentId': _submissions[index]['assignmentId'],
            'studentId': _submissions[index]['studentId'],
            'studentName': _submissions[index]['studentName'],
            'assignmentTitle': _submissions[index]['assignmentTitle'],
            'grade': submissionData['grade'],
            'maxGrade': 100,
            'feedback': submissionData['feedback'] ?? '',
            'gradedBy': 'Current Teacher',
            'gradedDate': DateTime.now().toIso8601String().split('T')[0],
          };
          _grades.add(gradeData);
        }
        
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

  // Get assignment by ID
  Map<String, dynamic>? getAssignmentById(int id) {
    try {
      return _assignments.firstWhere((assignment) => assignment['id'] == id);
    } catch (e) {
      return null;
    }
  }

  // Get submissions by assignment ID
  List<Map<String, dynamic>> getSubmissionsByAssignmentId(int assignmentId) {
    return _submissions.where((submission) => submission['assignmentId'] == assignmentId).toList();
  }

  // Get submissions by student ID
  List<Map<String, dynamic>> getSubmissionsByStudentId(int studentId) {
    return _submissions.where((submission) => submission['studentId'] == studentId).toList();
  }

  // Get grade by submission ID
  Map<String, dynamic>? getGradeBySubmissionId(int submissionId) {
    try {
      return _grades.firstWhere((grade) => grade['submissionId'] == submissionId);
    } catch (e) {
      return null;
    }
  }

  // Get assignments by class
  List<Map<String, dynamic>> getAssignmentsByClass(String className) {
    return _assignments.where((assignment) => assignment['class'] == className).toList();
  }

  // Get assignments by subject
  List<Map<String, dynamic>> getAssignmentsBySubject(String subject) {
    return _assignments.where((assignment) => assignment['subject'] == subject).toList();
  }

  // Get pending submissions
  List<Map<String, dynamic>> getPendingSubmissions() {
    return _submissions.where((submission) => submission['grade'] == null).toList();
  }

  // Get graded submissions
  List<Map<String, dynamic>> getGradedSubmissions() {
    return _submissions.where((submission) => submission['grade'] != null).toList();
  }

  // Get average grade for student
  double getAverageGradeForStudent(int studentId) {
    final studentGrades = _grades.where((grade) => grade['studentId'] == studentId).toList();
    if (studentGrades.isEmpty) return 0.0;
    
    final totalGrade = studentGrades.fold(0.0, (sum, grade) => sum + (grade['grade'] as double));
    return totalGrade / studentGrades.length;
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Get subject list
  List<String> getSubjectList() {
    final subjects = _assignments.map((assignment) => assignment['subject'].toString()).toSet().toList();
    subjects.sort();
    return subjects;
  }

  // Get class list
  List<String> getClassList() {
    final classes = _assignments.map((assignment) => assignment['class'].toString()).toSet().toList();
    classes.sort();
    return classes;
  }
}

