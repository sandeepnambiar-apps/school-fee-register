import 'package:dio/dio.dart';
import '../models/homework.dart';

class HomeworkApiService {
  final Dio _dio;

  HomeworkApiService(this._dio);

  // Homework Assignment operations
  Future<List<Homework>> getAllAssignments(int schoolId) async {
    try {
      final response = await _dio.get('/api/homework/assignments', queryParameters: {'schoolId': schoolId});
      if (response.statusCode == 200) {
        final List<dynamic> assignmentsData = response.data;
        return assignmentsData.map((json) => Homework.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load homework assignments: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load homework assignments: $e');
    }
  }

  Future<Homework> getAssignmentById(int id, int schoolId) async {
    try {
      final response = await _dio.get('/api/homework/assignments/$id', queryParameters: {'schoolId': schoolId});
      if (response.statusCode == 200) {
        return Homework.fromJson(response.data);
      } else {
        throw Exception('Failed to load homework assignment: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load homework assignment: $e');
    }
  }

  Future<Homework> createAssignment(Map<String, dynamic> assignmentData) async {
    try {
      final response = await _dio.post('/api/homework/assignments', data: assignmentData);
      if (response.statusCode == 200) {
        return Homework.fromJson(response.data);
      } else {
        throw Exception('Failed to create homework assignment: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to create homework assignment: $e');
    }
  }

  Future<Homework> updateAssignment(int id, Map<String, dynamic> assignmentData) async {
    try {
      final response = await _dio.put('/api/homework/assignments/$id', data: assignmentData);
      if (response.statusCode == 200) {
        return Homework.fromJson(response.data);
      } else {
        throw Exception('Failed to update homework assignment: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to update homework assignment: $e');
    }
  }

  Future<void> deleteAssignment(int id) async {
    try {
      final response = await _dio.delete('/api/homework/assignments/$id');
      if (response.statusCode != 204) {
        throw Exception('Failed to delete homework assignment: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to delete homework assignment: $e');
    }
  }

  Future<List<Homework>> getAssignmentsByClass(String className, int schoolId) async {
    try {
      final response = await _dio.get('/api/homework/assignments/class/$className', queryParameters: {'schoolId': schoolId});
      if (response.statusCode == 200) {
        final List<dynamic> assignmentsData = response.data;
        return assignmentsData.map((json) => Homework.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load assignments by class: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load assignments by class: $e');
    }
  }

  Future<List<Homework>> getAssignmentsBySubject(String subject, int schoolId) async {
    try {
      final response = await _dio.get('/api/homework/assignments/subject/$subject', queryParameters: {'schoolId': schoolId});
      if (response.statusCode == 200) {
        final List<dynamic> assignmentsData = response.data;
        return assignmentsData.map((json) => Homework.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load assignments by subject: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load assignments by subject: $e');
    }
  }

  // Homework Submission operations
  Future<List<Map<String, dynamic>>> getAllSubmissions(int schoolId) async {
    try {
      final response = await _dio.get('/api/homework/submissions', queryParameters: {'schoolId': schoolId});
      if (response.statusCode == 200) {
        final List<dynamic> submissionsData = response.data;
        return submissionsData.map((json) => Map<String, dynamic>.from(json)).toList();
      } else {
        throw Exception('Failed to load homework submissions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load homework submissions: $e');
    }
  }

  Future<Map<String, dynamic>> getSubmissionById(int id, int schoolId) async {
    try {
      final response = await _dio.get('/api/homework/submissions/$id', queryParameters: {'schoolId': schoolId});
      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(response.data);
      } else {
        throw Exception('Failed to load homework submission: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load homework submission: $e');
    }
  }

  Future<Map<String, dynamic>> submitHomework(Map<String, dynamic> submissionData) async {
    try {
      final response = await _dio.post('/api/homework/submissions', data: submissionData);
      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(response.data);
      } else {
        throw Exception('Failed to submit homework: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to submit homework: $e');
    }
  }

  Future<Map<String, dynamic>> updateSubmission(int id, Map<String, dynamic> submissionData) async {
    try {
      final response = await _dio.put('/api/homework/submissions/$id', data: submissionData);
      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(response.data);
      } else {
        throw Exception('Failed to update homework submission: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to update homework submission: $e');
    }
  }

  Future<void> deleteSubmission(int id) async {
    try {
      final response = await _dio.delete('/api/homework/submissions/$id');
      if (response.statusCode != 204) {
        throw Exception('Failed to delete homework submission: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to delete homework submission: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getSubmissionsByStudent(int studentId, int schoolId) async {
    try {
      final response = await _dio.get('/api/homework/submissions/student/$studentId', queryParameters: {'schoolId': schoolId});
      if (response.statusCode == 200) {
        final List<dynamic> submissionsData = response.data;
        return submissionsData.map((json) => Map<String, dynamic>.from(json)).toList();
      } else {
        throw Exception('Failed to load submissions by student: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load submissions by student: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getSubmissionsByAssignment(int assignmentId, int schoolId) async {
    try {
      final response = await _dio.get('/api/homework/submissions/assignment/$assignmentId', queryParameters: {'schoolId': schoolId});
      if (response.statusCode == 200) {
        final List<dynamic> submissionsData = response.data;
        return submissionsData.map((json) => Map<String, dynamic>.from(json)).toList();
      } else {
        throw Exception('Failed to load submissions by assignment: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load submissions by assignment: $e');
    }
  }

  // Homework Grading operations
  Future<List<Map<String, dynamic>>> getAllGrades(int schoolId) async {
    try {
      final response = await _dio.get('/api/homework/grades', queryParameters: {'schoolId': schoolId});
      if (response.statusCode == 200) {
        final List<dynamic> gradesData = response.data;
        return gradesData.map((json) => Map<String, dynamic>.from(json)).toList();
      } else {
        throw Exception('Failed to load homework grades: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load homework grades: $e');
    }
  }

  Future<Map<String, dynamic>> getGradeById(int id, int schoolId) async {
    try {
      final response = await _dio.get('/api/homework/grades/$id', queryParameters: {'schoolId': schoolId});
      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(response.data);
      } else {
        throw Exception('Failed to load homework grade: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load homework grade: $e');
    }
  }

  Future<Map<String, dynamic>> createGrade(Map<String, dynamic> gradeData) async {
    try {
      final response = await _dio.post('/api/homework/grades', data: gradeData);
      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(response.data);
      } else {
        throw Exception('Failed to create homework grade: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to create homework grade: $e');
    }
  }

  Future<Map<String, dynamic>> updateGrade(int id, Map<String, dynamic> gradeData) async {
    try {
      final response = await _dio.put('/api/homework/grades/$id', data: gradeData);
      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(response.data);
      } else {
        throw Exception('Failed to update homework grade: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to update homework grade: $e');
    }
  }

  Future<void> deleteGrade(int id) async {
    try {
      final response = await _dio.delete('/api/homework/grades/$id');
      if (response.statusCode != 204) {
        throw Exception('Failed to delete homework grade: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to delete homework grade: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getGradesByStudent(int studentId, int schoolId) async {
    try {
      final response = await _dio.get('/api/homework/grades/student/$studentId', queryParameters: {'schoolId': schoolId});
      if (response.statusCode == 200) {
        final List<dynamic> gradesData = response.data;
        return gradesData.map((json) => Map<String, dynamic>.from(json)).toList();
      } else {
        throw Exception('Failed to load grades by student: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load grades by student: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getGradesByAssignment(int assignmentId, int schoolId) async {
    try {
      final response = await _dio.get('/api/homework/grades/assignment/$assignmentId', queryParameters: {'schoolId': assignmentId});
      if (response.statusCode == 200) {
        final List<dynamic> gradesData = response.data;
        return gradesData.map((json) => Map<String, dynamic>.from(json)).toList();
      } else {
        throw Exception('Failed to load grades by assignment: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load grades by assignment: $e');
    }
  }
}


