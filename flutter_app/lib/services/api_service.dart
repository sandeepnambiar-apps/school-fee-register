import 'package:dio/dio.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  late final Dio _dio;
  
  // Base URLs for different services
  static const String gatewayUrl = 'http://localhost:8080';
  static const String authServiceUrl = 'http://localhost:8082';
  static const String studentServiceUrl = 'http://localhost:8081';
  static const String feeServiceUrl = 'http://localhost:8086';

  void initialize() {
    _dio = Dio(BaseOptions(
      baseUrl: gatewayUrl,
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

  // Service-specific methods
  Future<Response> callAuthService(String endpoint, {String method = 'GET', dynamic data}) async {
    final url = '$authServiceUrl$endpoint';
    switch (method.toUpperCase()) {
      case 'GET':
        return await get(url);
      case 'POST':
        return await post(url, data: data);
      case 'PUT':
        return await put(url, data: data);
      case 'DELETE':
        return await delete(url);
      default:
        throw Exception('Unsupported HTTP method: $method');
    }
  }

  Future<Response> callStudentService(String endpoint, {String method = 'GET', dynamic data}) async {
    final url = '$studentServiceUrl$endpoint';
    switch (method.toUpperCase()) {
      case 'GET':
        return await get(url);
      case 'POST':
        return await post(url, data: data);
      case 'PUT':
        return await put(url, data: data);
      case 'DELETE':
        return await delete(url);
      default:
        throw Exception('Unsupported HTTP method: $method');
    }
  }

  Future<Response> callFeeService(String endpoint, {String method = 'GET', dynamic data}) async {
    final url = '$feeServiceUrl$endpoint';
    switch (method.toUpperCase()) {
      case 'GET':
        return await get(url);
      case 'POST':
        return await post(url, data: data);
      case 'PUT':
        return await put(url, data: data);
      case 'DELETE':
        return await delete(url);
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
}


