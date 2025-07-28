import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';
import '../../core/constants/api_constants.dart';
import '../models/user_model.dart';
import '../models/auth_response_model.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const _tokenKey = 'auth_token';

  Future<AuthResponse> login({
    required String username,
    required String password,
  }) async {
    try {
      print('🔐 Attempting login for: $username');

      final response = await DioClient.post(
        ApiConstants.login,
        data: {'username': username, 'password': password},
      );

      print('✅ Login Response Status: ${response.statusCode}');
      print('📦 Login Response Data: ${response.data}');

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;

        // Check if wrapped in success structure
        if (responseData.containsKey('success') &&
            responseData['success'] == true &&
            responseData.containsKey('data')) {
          final authData = responseData['data'] as Map<String, dynamic>;
          print('📦 Login Response Data: ${authData['token'].toString()}');
          // print('📦 Login Response Data: ${authData.toString()}');

          // ✅ Simpan token ke SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_tokenKey, authData['token'].toString());
          return AuthResponse.fromJson(authData);
        } else {
          // Direct response
          return AuthResponse.fromJson(responseData);
        }
      } else {
        throw Exception('Login failed');
      }
    } on DioException catch (e) {
      print('❌ Login Dio Exception: ${e.message}');
      print('📄 Response: ${e.response?.data}');
      print('📊 Status: ${e.response?.statusCode}');

      if (e.response?.statusCode == 401) {
        throw Exception('Invalid username or password');
      } else if (e.response?.statusCode == 400) {
        final errorData = e.response?.data as Map<String, dynamic>?;
        final errorMessage = errorData?['message'] ?? 'Invalid credentials';
        throw Exception(errorMessage);
      } else {
        throw Exception('Login failed: ${e.message}');
      }
    } catch (e) {
      print('❌ Login General Exception: $e');
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    try {
      print('🚪 Logging out');

      final response = await DioClient.post(ApiConstants.logout);

      print('✅ Logout Response Status: ${response.statusCode}');

      if (response.statusCode != 200) {
        // Even if logout fails on server, we still clear local token
        print('⚠️ Logout failed on server, but clearing local token');
      }
    } on DioException catch (e) {
      print('❌ Logout Error: ${e.message}');
      // Don't throw error for logout, just log it
    } catch (e) {
      print('❌ Logout General Exception: $e');
      // Don't throw error for logout, just log it
    }
  }

  Future<AuthResponse> refreshToken() async {
    try {
      print('🔄 Refreshing token');

      final response = await DioClient.post(ApiConstants.refreshToken);

      print('✅ Refresh Token Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;

        if (responseData.containsKey('success') &&
            responseData['success'] == true &&
            responseData.containsKey('data')) {
          final authData = responseData['data'] as Map<String, dynamic>;
          return AuthResponse.fromJson(authData);
        } else {
          return AuthResponse.fromJson(responseData);
        }
      } else {
        throw Exception('Token refresh failed');
      }
    } on DioException catch (e) {
      print('❌ Refresh Token Error: ${e.message}');
      if (e.response?.statusCode == 401) {
        throw Exception('Session expired, please login again');
      }
      throw Exception('Token refresh failed: ${e.message}');
    } catch (e) {
      print('❌ Refresh Token General Exception: $e');
      throw Exception('Token refresh failed: ${e.toString()}');
    }
  }

  Future<User> getCurrentUser() async {
    try {
      print('👤 Getting current user');

      final response = await DioClient.get(ApiConstants.currentUser);

      print('✅ Current User Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;

        if (responseData.containsKey('success') &&
            responseData['success'] == true &&
            responseData.containsKey('data')) {
          final userData = responseData['data'] as Map<String, dynamic>;
          return User.fromJson(userData);
        } else {
          return User.fromJson(responseData);
        }
      } else {
        throw Exception('Failed to get current user');
      }
    } on DioException catch (e) {
      print('❌ Get Current User Error: ${e.message}');
      if (e.response?.statusCode == 401) {
        throw Exception('Authentication required');
      }
      throw Exception('Failed to get current user: ${e.message}');
    } catch (e) {
      print('❌ Get Current User General Exception: $e');
      throw Exception('Failed to get current user: ${e.toString()}');
    }
  }

  static Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_tokenKey);
    } catch (e) {
      print('❌ Error getting token: $e');
      return null;
    }
  }
}
