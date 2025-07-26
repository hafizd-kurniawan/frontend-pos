import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';
import '../../core/network/api_response.dart';
import '../../core/constants/api_constants.dart';
import '../models/user_model.dart';

class AuthResponse {
  final User user;
  final String token;
  final int expiresAt;
  final String? refreshToken; // Make optional since backend doesn't send it

  AuthResponse({
    required this.user,
    required this.token,
    required this.expiresAt,
    this.refreshToken,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    print('🔍 Parsing AuthResponse from JSON: $json');

    return AuthResponse(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'] as String,
      expiresAt: json['expires_at'] as int,
      refreshToken: json['refresh_token'] as String?, // nullable
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'token': token,
      'expires_at': expiresAt,
      if (refreshToken != null) 'refresh_token': refreshToken,
    };
  }
}

class AuthService {
  Future<AuthResponse> login({
    required String username,
    required String password,
  }) async {
    try {
      print('🔐 Attempting login for username: $username');
      print('🌐 Login URL: ${ApiConstants.fullBaseUrl}${ApiConstants.login}');

      final response = await DioClient.instance.post(
        ApiConstants.login,
        data: {'username': username, 'password': password},
      );

      print('✅ Login Response Status: ${response.statusCode}');
      print('📦 Login Response Data: ${response.data}');

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;

        // Backend sends wrapped response: {success: true, message: "", data: {...}}
        if (responseData.containsKey('success') &&
            responseData['success'] == true &&
            responseData.containsKey('data')) {
          final authData = responseData['data'] as Map<String, dynamic>;
          print('✅ Parsing auth data: $authData');

          return AuthResponse.fromJson(authData);
        } else {
          throw Exception(
            'Invalid response format: ${responseData['message'] ?? 'Unknown error'}',
          );
        }
      } else {
        throw Exception('Login failed with status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('❌ Login Dio Exception: ${e.message}');
      print('📄 Response: ${e.response?.data}');
      print('📊 Status: ${e.response?.statusCode}');

      if (e.response?.statusCode == 401) {
        final errorData = e.response?.data as Map<String, dynamic>?;
        final errorMessage =
            errorData?['message'] ?? 'Invalid username or password';
        throw Exception(errorMessage);
      } else if (e.response?.statusCode == 404) {
        throw Exception(
          'Login endpoint not found. Please check server configuration.',
        );
      } else if (e.response?.statusCode == 400) {
        final errorData = e.response?.data as Map<String, dynamic>?;
        final errorMessage = errorData?['message'] ?? 'Bad request';
        throw Exception(errorMessage);
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception(
          'Connection timeout. Please check your internet connection.',
        );
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception(
          'Cannot connect to server. Please check if server is running.',
        );
      } else {
        throw Exception('Login failed: ${e.message}');
      }
    } catch (e) {
      print('❌ Login General Exception: $e');
      print('🔍 Exception type: ${e.runtimeType}');
      print('🔍 Stack trace: ${StackTrace.current}');
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    try {
      print('🚪 Attempting logout');

      final response = await DioClient.instance.post(ApiConstants.logout);

      print('✅ Logout Response Status: ${response.statusCode}');

      if (response.statusCode != 200) {
        throw Exception('Logout failed with status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('❌ Logout Error: ${e.message}');
      // Don't throw on logout errors - allow silent logout
      print('⚠️ Logout failed but continuing with local logout');
    } catch (e) {
      print('❌ Logout General Exception: $e');
      // Don't throw on logout errors - allow silent logout
      print('⚠️ Logout failed but continuing with local logout');
    }
  }

  Future<User?> getCurrentUser() async {
    try {
      print('👤 Fetching current user');

      final response = await DioClient.instance.get(ApiConstants.currentUser);

      print('✅ Current User Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;

        // Check if it's wrapped in success structure
        if (responseData.containsKey('success') &&
            responseData['success'] == true &&
            responseData.containsKey('data')) {
          final userData = responseData['data'] as Map<String, dynamic>;
          return User.fromJson(userData);
        } else {
          // Direct response
          return User.fromJson(responseData);
        }
      } else if (response.statusCode == 401) {
        return null; // User not authenticated
      } else {
        throw Exception('Failed to get current user');
      }
    } on DioException catch (e) {
      print('❌ Current User Error: ${e.message}');
      if (e.response?.statusCode == 401) {
        return null; // User not authenticated
      }
      throw Exception('Failed to get current user: ${e.message}');
    } catch (e) {
      print('❌ Current User General Exception: $e');
      throw Exception('Failed to get current user: ${e.toString()}');
    }
  }

  Future<String> refreshToken() async {
    try {
      print('🔄 Refreshing token');

      final response = await DioClient.instance.post(ApiConstants.refreshToken);

      print('✅ Refresh Token Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;

        // Check if it's wrapped in success structure
        if (responseData.containsKey('success') &&
            responseData['success'] == true &&
            responseData.containsKey('data')) {
          final tokenData = responseData['data'] as Map<String, dynamic>;
          return tokenData['token'] as String;
        } else {
          // Direct response
          return responseData['token'] as String;
        }
      } else {
        throw Exception('Token refresh failed');
      }
    } on DioException catch (e) {
      print('❌ Refresh Token Error: ${e.message}');
      throw Exception('Token refresh failed: ${e.message}');
    } catch (e) {
      print('❌ Refresh Token General Exception: $e');
      throw Exception('Token refresh failed: ${e.toString()}');
    }
  }
}
