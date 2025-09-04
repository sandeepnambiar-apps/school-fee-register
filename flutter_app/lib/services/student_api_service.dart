import 'package:dio/dio.dart';
import '../models/student.dart';

class StudentApiService {
  final Dio _dio;

  StudentApiService(this._dio);

  // Get all students for a specific school
  Future<List<Student>> getAllStudents(int schoolId) async {
    try {
      final response = await _dio.get('/api/students', queryParameters: {'schoolId': schoolId});
      if (response.statusCode == 200) {
        final List<dynamic> studentsData = response.data;
        return studentsData.map((json) => Student.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load students: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load students: $e');
    }
  }

  // Get student by ID within school context
  Future<Student> getStudentById(int id, int schoolId) async {
    try {
      final response = await _dio.get('/api/students/$id', queryParameters: {'schoolId': schoolId});
      if (response.statusCode == 200) {
        return Student.fromJson(response.data);
      } else {
        throw Exception('Failed to load student: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load student: $e');
    }
  }

  // Create new student
  Future<Student> createStudent(Map<String, dynamic> studentData) async {
    try {
      final response = await _dio.post('/api/students', data: studentData);
      if (response.statusCode == 200) {
        return Student.fromJson(response.data);
      } else {
        throw Exception('Failed to create student: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to create student: $e');
    }
  }

  // Update student
  Future<Student> updateStudent(int id, Map<String, dynamic> studentData) async {
    try {
      final response = await _dio.put('/api/students/$id', data: studentData);
      if (response.statusCode == 200) {
        return Student.fromJson(response.data);
      } else {
        throw Exception('Failed to update student: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to update student: $e');
    }
  }

  // Delete student
  Future<void> deleteStudent(int id) async {
    try {
      final response = await _dio.delete('/api/students/$id');
      if (response.statusCode != 204) {
        throw Exception('Failed to delete student: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to delete student: $e');
    }
  }

  // Get students by class within school context
  Future<List<Student>> getStudentsByClass(String className, int schoolId) async {
    try {
      final response = await _dio.get('/api/students/class/$className', queryParameters: {'schoolId': schoolId});
      if (response.statusCode == 200) {
        final List<dynamic> studentsData = response.data;
        return studentsData.map((json) => Student.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load students by class: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load students by class: $e');
    }
  }

  // Search students within school context
  Future<List<Student>> searchStudents(String query, int schoolId) async {
    try {
      final response = await _dio.get('/api/students/search', queryParameters: {'query': query, 'schoolId': schoolId});
      if (response.statusCode == 200) {
        final List<dynamic> studentsData = response.data;
        return studentsData.map((json) => Student.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search students: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to search students: $e');
    }
  }

  // Get student profile
  Future<Student> getStudentProfile(int id) async {
    try {
      final response = await _dio.get('/api/students/$id/profile');
      if (response.statusCode == 200) {
        return Student.fromJson(response.data);
      } else {
        throw Exception('Failed to load student profile: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load student profile: $e');
    }
  }

  // Update student status
  Future<Student> updateStudentStatus(int id, String status) async {
    try {
      final response = await _dio.put('/api/students/$id/status', queryParameters: {'status': status});
      if (response.statusCode == 200) {
        return Student.fromJson(response.data);
      } else {
        throw Exception('Failed to update student status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to update student status: $e');
    }
  }

  // Get student fees
  Future<List<Map<String, dynamic>>> getStudentFees(int id) async {
    try {
      final response = await _dio.get('/api/students/$id/fees');
      if (response.statusCode == 200) {
        final List<dynamic> feesData = response.data;
        return feesData.map((json) => Map<String, dynamic>.from(json)).toList();
      } else {
        throw Exception('Failed to load student fees: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load student fees: $e');
    }
  }

  // Get student attendance
  Future<List<Map<String, dynamic>>> getStudentAttendance(int id) async {
    try {
      final response = await _dio.get('/api/students/$id/attendance');
      if (response.statusCode == 200) {
        final List<dynamic> attendanceData = response.data;
        return attendanceData.map((json) => Map<String, dynamic>.from(json)).toList();
      } else {
        throw Exception('Failed to load student attendance: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load student attendance: $e');
    }
  }

  // Get student marks
  Future<List<Map<String, dynamic>>> getStudentMarks(int id) async {
    try {
      final response = await _dio.get('/api/students/$id/marks');
      if (response.statusCode == 200) {
        final List<dynamic> marksData = response.data;
        return marksData.map((json) => Map<String, dynamic>.from(json)).toList();
      } else {
        throw Exception('Failed to load student marks: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load student marks: $e');
    }
  }
}


