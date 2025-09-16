import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  late final Dio _dio;
  bool _isInitialized = false;
  
  // Getter for dio instance
  Dio get dio => _dio;
  
  // Base URL for monolithic backend
  static const String baseUrl = 'http://172.20.48.1:8080';

  void initialize() {
    if (_isInitialized) return; // Prevent multiple initializations
    
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Add interceptors for logging and error handling
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => print(obj),
    ));
    
    _isInitialized = true;
  }

  // Generic HTTP methods
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> post(String path, {dynamic data}) async {
    try {
      final response = await _dio.post(path, data: data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> put(String path, {dynamic data}) async {
    try {
      final response = await _dio.put(path, data: data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> delete(String path) async {
    try {
      final response = await _dio.delete(path);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Multi-school API endpoints
  static const String schoolsEndpoint = '/api/schools';
  static const String studentsEndpoint = '/api/students';
  static const String feesEndpoint = '/api/fees';
  static const String homeworkEndpoint = '/api/homework';
  static const String notificationsEndpoint = '/api/notifications';
  static const String timetableEndpoint = '/api/timetable';

  // Generic service call method
  Future<Response> callService(String endpoint, {String method = 'GET', dynamic data, Map<String, dynamic>? queryParameters}) async {
    switch (method.toUpperCase()) {
      case 'GET':
        return await get(endpoint, queryParameters: queryParameters);
      case 'POST':
        return await post(endpoint, data: data);
      case 'PUT':
        return await put(endpoint, data: data);
      case 'DELETE':
        return await delete(endpoint);
      default:
        throw Exception('Unsupported HTTP method: $method');
    }
  }

  // Helper method to parse response
  Map<String, dynamic> parseResponse(Response response) {
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      return response.data is Map<String, dynamic> 
          ? response.data 
          : {'data': response.data};
    } else {
      throw Exception('HTTP Error: ${response.statusCode} - ${response.statusMessage}');
    }
  }

  // Authentication endpoints
  Future<Map<String, dynamic>> login(String mobileNumber, String password) async {
    try {
      final response = await post('/api/auth/login', data: {
        'mobileNumber': mobileNumber,
        'password': password,
      });
      return parseResponse(response);
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<Map<String, dynamic>> unifiedLogin(String mobileNumber, String password) async {
    try {
      final response = await post('/api/auth/unified-login', data: {
        'mobileNumber': mobileNumber,
        'password': password,
      });
      return parseResponse(response);
    } catch (e) {
      throw Exception('Unified login failed: $e');
    }
  }

  Future<Map<String, dynamic>> changePassword(String mobileNumber, String newPassword) async {
    try {
      final response = await post('/api/auth/change-password', data: {
        'mobileNumber': mobileNumber,
        'newPassword': newPassword,
      });
      return parseResponse(response);
    } catch (e) {
      throw Exception('Password change failed: $e');
    }
  }

  Future<Map<String, dynamic>> forgotPassword(String mobileNumber) async {
    try {
      final response = await post('/api/auth/forgot-password', data: {
        'mobileNumber': mobileNumber,
      });
      return parseResponse(response);
    } catch (e) {
      throw Exception('Password reset failed: $e');
    }
  }

  Future<Map<String, dynamic>> verifyResetOTP(String mobileNumber, String otp) async {
    try {
      final response = await post('/api/auth/verify-reset-otp', data: {
        'mobileNumber': mobileNumber,
        'otp': otp,
      });
      return parseResponse(response);
    } catch (e) {
      throw Exception('OTP verification failed: $e');
    }
  }

  // School Code Validation
  Future<Map<String, dynamic>> validateSchoolCode(String schoolCode) async {
    try {
      final response = await post('/api/schools/validate-code', data: {
        'schoolCode': schoolCode,
      });
      return parseResponse(response);
    } catch (e) {
      throw Exception('School code validation failed: $e');
    }
  }

  // Store school code in local storage
  Future<void> storeSchoolCode(String schoolCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('school_code', schoolCode);
    await prefs.setBool('school_code_verified', true);
    print('Stored school code: $schoolCode');
  }

  // Check if school code is already verified
  Future<bool> isSchoolCodeVerified() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('school_code_verified') ?? false;
  }

  // Get stored school code
  Future<String?> getStoredSchoolCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('school_code');
  }

  // Clear school code (for testing/reset)
  Future<void> clearSchoolCode() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('school_code');
    await prefs.remove('school_code_verified');
  }
}


