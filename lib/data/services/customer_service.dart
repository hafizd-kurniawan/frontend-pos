import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/customer_model.dart';
import '../../core/constants/api_constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'auth_service.dart';

class CustomerService {
  static const String baseUrl = ApiConstants.fullBaseUrl;

  Future<String?> _getValidToken() async {
    try {
      final token = await AuthService.getToken();

      if (token == null) {
        print('❌ No valid token available');
        throw Exception('Authentication required. Please login again.');
      }

      print('📦 Token: ${token.substring(0, 10)}...');
      return token;
    } catch (e) {
      print('❌ Error getting valid token: $e');
      throw Exception('Authentication failed. Please login again.');
    }
  }

  Future<List<Customer>> getAllCustomers() async {
    print('🔍 Fetching customers...');
    print('🌐 GET /customers');

    final token = await _getValidToken(); // ✅ hindari pemanggilan berulang

    final response = await http.get(
      Uri.parse('$baseUrl/customers'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('📦 Headers: ${response.request?.headers}');
    print('✅ Response ${response.statusCode}: /customers');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('✅ Customer response: $data');

      final List<dynamic> customerData = data['data'];
      return customerData.map((json) => Customer.fromJson(json)).toList();
    } else {
      print('❌ Error ${response.statusCode}: ${response.body}');
      throw Exception('Failed to load customers');
    }
  }

  Future<Customer> createCustomer({
    required String fullName,
    required String phone,
    required String email,
    required String address,
    String? companyName,
  }) async {
    print('🚀 Creating customer...');
    print('🌐 POST /customers');

    final requestData = {
      'full_name': fullName,
      'phone': phone,
      'email': email,
      'address': address,
      'customer_type': 'individual',
      'city': 'Jakarta',
      'is_active': true,
      if (companyName != null) 'company_name': companyName,
    };
    final token = await _getValidToken(); // ✅ hindari dipanggil dua kali
    final response = await http.post(
      Uri.parse('$baseUrl/customers'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(requestData),
    );

    print('📦 Request headers: ${response.request?.headers}');
    print('✅ Response ${response.statusCode}: POST /customers');
    print('📄 Response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      print('✅ Customer created successfully: $data');

      if (data['data'] != null) {
        return Customer.fromJson(data['data']);
      } else {
        return Customer(
          id: DateTime.now().millisecondsSinceEpoch,
          fullName: fullName,
          name: fullName,
          phone: phone,
          email: email,
          address: address,
          companyName: companyName,
          createdAt: DateTime.now().toIso8601String(),
          updatedAt: DateTime.now().toIso8601String(),
        );
      }
    } else {
      print('❌ Error ${response.statusCode}: ${response.body}');
      throw Exception('Failed to create customer: ${response.body}');
    }
  }

  Future<List<Customer>> searchCustomers() async {
    // For now, return all customers (you can add search parameter later)
    return await getAllCustomers();
  }
}
