import 'package:dio/dio.dart';
import '../models/timetable.dart';

class TimetableApiService {
  final Dio _dio;

  TimetableApiService(this._dio);

  // Get all timetable assignments for a specific school
  Future<List<TimetableEntry>> getAllAssignments(int schoolId) async {
    try {
      final response = await _dio.get('/api/timetable/assignments', queryParameters: {'schoolId': schoolId});
      if (response.statusCode == 200) {
        final List<dynamic> assignmentsData = response.data;
        return assignmentsData.map((json) => TimetableEntry.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load timetable assignments: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load timetable assignments: $e');
    }
  }

  // Get timetable assignment by ID
  Future<TimetableEntry?> getAssignmentById(String id, int schoolId) async {
    try {
      final response = await _dio.get('/api/timetable/assignments/$id', queryParameters: {'schoolId': schoolId});
      if (response.statusCode == 200) {
        return TimetableEntry.fromJson(response.data);
      } else {
        throw Exception('Failed to load timetable assignment: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load timetable assignment: $e');
    }
  }

  // Create new timetable assignment
  Future<TimetableEntry> createAssignment(TimetableEntry assignment) async {
    try {
      final response = await _dio.post('/api/timetable/assignments', data: assignment.toJson());
      if (response.statusCode == 201) {
        return TimetableEntry.fromJson(response.data);
      } else {
        throw Exception('Failed to create timetable assignment: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to create timetable assignment: $e');
    }
  }

  // Update timetable assignment
  Future<TimetableEntry> updateAssignment(String id, TimetableEntry assignment) async {
    try {
      final response = await _dio.put('/api/timetable/assignments/$id', data: assignment.toJson());
      if (response.statusCode == 200) {
        return TimetableEntry.fromJson(response.data);
      } else {
        throw Exception('Failed to update timetable assignment: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to update timetable assignment: $e');
    }
  }

  // Delete timetable assignment
  Future<void> deleteAssignment(String id) async {
    try {
      final response = await _dio.delete('/api/timetable/assignments/$id');
      if (response.statusCode != 204) {
        throw Exception('Failed to delete timetable assignment: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to delete timetable assignment: $e');
    }
  }

  // Get timetable assignments by class
  Future<List<TimetableEntry>> getAssignmentsByClass(String className, int schoolId) async {
    try {
      final response = await _dio.get('/api/timetable/assignments/class/$className', queryParameters: {'schoolId': schoolId});
      if (response.statusCode == 200) {
        final List<dynamic> assignmentsData = response.data;
        return assignmentsData.map((json) => TimetableEntry.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load timetable assignments by class: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load timetable assignments by class: $e');
    }
  }

  // Get timetable assignments by day
  Future<List<TimetableEntry>> getAssignmentsByDay(String day, int schoolId) async {
    try {
      final response = await _dio.get('/api/timetable/assignments/day/$day', queryParameters: {'schoolId': schoolId});
      if (response.statusCode == 200) {
        final List<dynamic> assignmentsData = response.data;
        return assignmentsData.map((json) => TimetableEntry.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load timetable assignments by day: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load timetable assignments by day: $e');
    }
  }

  // Get timetable assignments by teacher
  Future<List<TimetableEntry>> getAssignmentsByTeacher(String teacherId, int schoolId) async {
    try {
      final response = await _dio.get('/api/timetable/assignments/teacher/$teacherId', queryParameters: {'schoolId': schoolId});
      if (response.statusCode == 200) {
        final List<dynamic> assignmentsData = response.data;
        return assignmentsData.map((json) => TimetableEntry.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load timetable assignments by teacher: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load timetable assignments by teacher: $e');
    }
  }

  // Get timetable assignments by subject
  Future<List<TimetableEntry>> getAssignmentsBySubject(String subject, int schoolId) async {
    try {
      final response = await _dio.get('/api/timetable/assignments/subject/$subject', queryParameters: {'schoolId': schoolId});
      if (response.statusCode == 200) {
        final List<dynamic> assignmentsData = response.data;
        return assignmentsData.map((json) => TimetableEntry.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load timetable assignments by subject: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load timetable assignments by subject: $e');
    }
  }

  // Search timetable assignments
  Future<List<TimetableEntry>> searchAssignments(String query, int schoolId) async {
    try {
      final response = await _dio.get('/api/timetable/assignments/search', queryParameters: {
        'query': query,
        'schoolId': schoolId,
      });
      if (response.statusCode == 200) {
        final List<dynamic> assignmentsData = response.data;
        return assignmentsData.map((json) => TimetableEntry.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search timetable assignments: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to search timetable assignments: $e');
    }
  }
}


