import 'package:dio/dio.dart';
import '../models/school.dart';

class SchoolApiService {
  final Dio _dio;

  SchoolApiService(this._dio);

  // Get all schools
  Future<List<School>> getAllSchools() async {
    try {
      final response = await _dio.get('/api/schools');
      if (response.statusCode == 200) {
        final List<dynamic> schoolsData = response.data;
        return schoolsData.map((json) => School.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load schools: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load schools: $e');
    }
  }

  // Get school by ID
  Future<School> getSchoolById(int id) async {
    try {
      final response = await _dio.get('/api/schools/$id');
      if (response.statusCode == 200) {
        return School.fromJson(response.data);
      } else {
        throw Exception('Failed to load school: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load school: $e');
    }
  }

  // Get school by code
  Future<School> getSchoolByCode(String schoolCode) async {
    try {
      final response = await _dio.get('/api/schools/code/$schoolCode');
      if (response.statusCode == 200) {
        return School.fromJson(response.data);
      } else {
        throw Exception('Failed to load school: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load school: $e');
    }
  }

  // Register new school
  Future<School> registerSchool(Map<String, dynamic> schoolData) async {
    try {
      final response = await _dio.post('/api/schools/register', data: schoolData);
      if (response.statusCode == 201) {
        return School.fromJson(response.data);
      } else {
        throw Exception('Failed to register school: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to register school: $e');
    }
  }

  // Update school
  Future<School> updateSchool(int id, Map<String, dynamic> schoolData) async {
    try {
      final response = await _dio.put('/api/schools/$id', data: schoolData);
      if (response.statusCode == 200) {
        return School.fromJson(response.data);
      } else {
        throw Exception('Failed to update school: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to update school: $e');
    }
  }

  // Update school status
  Future<School> updateSchoolStatus(int id, String status) async {
    try {
      final response = await _dio.patch('/api/schools/$id/status', queryParameters: {'status': status});
      if (response.statusCode == 200) {
        return School.fromJson(response.data);
      } else {
        throw Exception('Failed to update school status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to update school status: $e');
    }
  }

  // Delete school
  Future<void> deleteSchool(int id) async {
    try {
      final response = await _dio.delete('/api/schools/$id');
      if (response.statusCode != 204) {
        throw Exception('Failed to delete school: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to delete school: $e');
    }
  }

  // Check if school exists
  Future<bool> schoolExists(String schoolCode) async {
    try {
      final response = await _dio.get('/api/schools/exists/$schoolCode');
      if (response.statusCode == 200) {
        return response.data as bool;
      } else {
        throw Exception('Failed to check school existence: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to check school existence: $e');
    }
  }

  // Get schools by status
  Future<List<School>> getSchoolsByStatus(String status) async {
    try {
      final response = await _dio.get('/api/schools/status/$status');
      if (response.statusCode == 200) {
        final List<dynamic> schoolsData = response.data;
        return schoolsData.map((json) => School.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load schools by status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load schools by status: $e');
    }
  }
}


