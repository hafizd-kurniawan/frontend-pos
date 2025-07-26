import 'package:dio/dio.dart';
import '../constants/api_constants.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  static DioClient get instance => _instance;

  late Dio _dio;
  String? _authToken;

  DioClient._internal() {
    _dio = Dio();
    _initializeInterceptors();
  }

  // Method to set auth token
  void setAuthToken(String? token) {
    _authToken = token;
    print('🎫 DioClient: Auth token ${token != null ? 'set' : 'cleared'}');
  }

  void _initializeInterceptors() {
    _dio.options = BaseOptions(
      baseUrl: ApiConstants.fullBaseUrl,
      connectTimeout: ApiConstants.connectTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
      sendTimeout: ApiConstants.sendTimeout,
      headers: ApiConstants.defaultHeaders,
    );

    // Add auth token interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add auth token to requests if available
          if (_authToken != null && !options.path.contains('/auth/login')) {
            options.headers['Authorization'] = 'Bearer $_authToken';
            print('🎫 Added auth token to request: ${options.path}');
          }

          print(
            '🚀 API Request: ${options.method} ${ApiConstants.fullBaseUrl}${options.path}',
          );
          if (options.data != null) {
            print('📤 Request Body: ${options.data}');
          }
          if (options.queryParameters.isNotEmpty) {
            print('📋 Query Parameters: ${options.queryParameters}');
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          print(
            '✅ API Response: ${response.statusCode} ${response.statusMessage}',
          );
          print('📥 Response Data Type: ${response.data.runtimeType}');
          handler.next(response);
        },
        onError: (error, handler) {
          print('❌ API Error: ${error.message}');
          print('📄 Error Response: ${error.response?.data}');
          print('📊 Status Code: ${error.response?.statusCode}');
          print('🔗 Request URL: ${error.requestOptions.uri}');

          // Handle 401 unauthorized - clear token
          if (error.response?.statusCode == 401) {
            _authToken = null;
            print('🔓 Cleared auth token due to 401 response');
          }

          handler.next(error);
        },
      ),
    );

    // Add logging interceptor
    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: false, // Reduce noise
        responseBody: true,
        error: true,
        logPrint: (object) {
          print('🌐 API LOG: $object');
        },
      ),
    );
  }

  Dio get dio => _dio;

  // GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } catch (e) {
      print('❌ GET Error for $path: $e');
      rethrow;
    }
  }

  // POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } catch (e) {
      print('❌ POST Error for $path: $e');
      rethrow;
    }
  }

  // PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } catch (e) {
      print('❌ PUT Error for $path: $e');
      rethrow;
    }
  }

  // DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } catch (e) {
      print('❌ DELETE Error for $path: $e');
      rethrow;
    }
  }
}
