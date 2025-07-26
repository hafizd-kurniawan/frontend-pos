import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';
import '../../core/constants/api_constants.dart';
import '../models/customer_model.dart';

class CustomerService {
  Future<Customer> createCustomer({required Customer customerData}) async {
    try {
      print('👤 Creating new customer');
      print('📋 Customer data: ${customerData.toJson()}');

      final response = await DioClient.instance.post(
        ApiConstants.customers,
        data: customerData.toJson(),
      );

      print('✅ Customer Response Status: ${response.statusCode}');
      print('📦 Customer Response Data: ${response.data}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;

        // Check if wrapped in success structure
        if (responseData.containsKey('success') &&
            responseData['success'] == true &&
            responseData.containsKey('data')) {
          final customerResponseData =
              responseData['data'] as Map<String, dynamic>;
          return Customer.fromJson(customerResponseData);
        } else {
          // Direct response
          return Customer.fromJson(responseData);
        }
      } else {
        throw Exception('Failed to create customer');
      }
    } on DioException catch (e) {
      print('❌ Create Customer Dio Exception: ${e.message}');
      print('📄 Response: ${e.response?.data}');
      print('📊 Status: ${e.response?.statusCode}');

      if (e.response?.statusCode == 400) {
        final errorData = e.response?.data as Map<String, dynamic>?;
        final errorMessage = errorData?['message'] ?? 'Invalid customer data';
        throw Exception(errorMessage);
      } else if (e.response?.statusCode == 409) {
        throw Exception('Customer with this phone number already exists');
      } else {
        throw Exception('Failed to create customer: ${e.message}');
      }
    } catch (e) {
      print('❌ Create Customer General Exception: $e');
      throw Exception('Failed to create customer: ${e.toString()}');
    }
  }

  Future<List<Customer>> getCustomers({
    int page = 1,
    int limit = 20,
    String? search,
    String? sortBy = 'created_at',
    String? sortOrder = 'desc',
  }) async {
    try {
      print('👥 Fetching customers list');

      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
        if (search != null && search.isNotEmpty) 'search': search,
        'sort_by': sortBy,
        'sort_order': sortOrder,
      };

      final response = await DioClient.instance.get(
        ApiConstants.customers,
        queryParameters: queryParams,
      );

      print('✅ Customers List Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;

        // Check if wrapped in success structure
        if (responseData.containsKey('success') &&
            responseData['success'] == true &&
            responseData.containsKey('data')) {
          final customersData = responseData['data'] as List;
          return customersData
              .map(
                (customer) =>
                    Customer.fromJson(customer as Map<String, dynamic>),
              )
              .toList();
        } else if (responseData.containsKey('data') &&
            responseData['data'] is List) {
          // Data is directly in 'data' field
          final customersData = responseData['data'] as List;
          return customersData
              .map(
                (customer) =>
                    Customer.fromJson(customer as Map<String, dynamic>),
              )
              .toList();
        } else if (responseData is List) {
          // Direct list response
          return responseData
              .map(
                (customer) =>
                    Customer.fromJson(customer as Map<String, dynamic>),
              )
              .toList();
        } else {
          return [];
        }
      } else {
        throw Exception('Failed to fetch customers');
      }
    } on DioException catch (e) {
      print('❌ Get Customers Error: ${e.message}');
      throw Exception('Failed to fetch customers: ${e.message}');
    } catch (e) {
      print('❌ Get Customers General Exception: $e');
      throw Exception('Failed to fetch customers: ${e.toString()}');
    }
  }

  Future<Customer> getCustomerById(int customerId) async {
    try {
      print('👤 Fetching customer details for ID: $customerId');

      final response = await DioClient.instance.get(
        '${ApiConstants.customers}/$customerId',
      );

      print('✅ Customer Detail Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;

        // Check if wrapped in success structure
        if (responseData.containsKey('success') &&
            responseData['success'] == true &&
            responseData.containsKey('data')) {
          final customerData = responseData['data'] as Map<String, dynamic>;
          return Customer.fromJson(customerData);
        } else {
          // Direct response
          return Customer.fromJson(responseData);
        }
      } else {
        throw Exception('Customer not found');
      }
    } on DioException catch (e) {
      print('❌ Get Customer Detail Error: ${e.message}');
      if (e.response?.statusCode == 404) {
        throw Exception('Customer not found');
      }
      throw Exception('Failed to fetch customer details: ${e.message}');
    } catch (e) {
      print('❌ Get Customer Detail General Exception: $e');
      throw Exception('Failed to fetch customer details: ${e.toString()}');
    }
  }

  Future<Customer> updateCustomer({required Customer customerData}) async {
    try {
      print('🔄 Updating customer: ${customerData.id}');

      final response = await DioClient.instance.put(
        '${ApiConstants.customers}/${customerData.id}',
        data: customerData.toJson(),
      );

      print('✅ Update Customer Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;

        // Check if wrapped in success structure
        if (responseData.containsKey('success') &&
            responseData['success'] == true &&
            responseData.containsKey('data')) {
          final customerResponseData =
              responseData['data'] as Map<String, dynamic>;
          return Customer.fromJson(customerResponseData);
        } else {
          // Direct response
          return Customer.fromJson(responseData);
        }
      } else {
        throw Exception('Failed to update customer');
      }
    } on DioException catch (e) {
      print('❌ Update Customer Error: ${e.message}');
      throw Exception('Failed to update customer: ${e.message}');
    } catch (e) {
      print('❌ Update Customer General Exception: $e');
      throw Exception('Failed to update customer: ${e.toString()}');
    }
  }

  Future<void> deleteCustomer(int customerId) async {
    try {
      print('🗑️ Deleting customer: $customerId');

      final response = await DioClient.instance.delete(
        '${ApiConstants.customers}/$customerId',
      );

      print('✅ Delete Customer Response Status: ${response.statusCode}');

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete customer');
      }
    } on DioException catch (e) {
      print('❌ Delete Customer Error: ${e.message}');
      throw Exception('Failed to delete customer: ${e.message}');
    } catch (e) {
      print('❌ Delete Customer General Exception: $e');
      throw Exception('Failed to delete customer: ${e.toString()}');
    }
  }

  Future<List<Customer>> searchCustomers({
    required String query,
    int limit = 10,
  }) async {
    try {
      print('🔍 Searching customers: $query');

      final response = await DioClient.instance.get(
        '${ApiConstants.customers}/search',
        queryParameters: {'q': query, 'limit': limit},
      );

      print('✅ Search Customers Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;

        // Check if wrapped in success structure
        if (responseData.containsKey('success') &&
            responseData['success'] == true &&
            responseData.containsKey('data')) {
          final customersData = responseData['data'] as List;
          return customersData
              .map(
                (customer) =>
                    Customer.fromJson(customer as Map<String, dynamic>),
              )
              .toList();
        } else if (responseData.containsKey('data') &&
            responseData['data'] is List) {
          final customersData = responseData['data'] as List;
          return customersData
              .map(
                (customer) =>
                    Customer.fromJson(customer as Map<String, dynamic>),
              )
              .toList();
        } else if (responseData is List) {
          return responseData
              .map(
                (customer) =>
                    Customer.fromJson(customer as Map<String, dynamic>),
              )
              .toList();
        } else {
          return [];
        }
      } else {
        throw Exception('Failed to search customers');
      }
    } on DioException catch (e) {
      print('❌ Search Customers Error: ${e.message}');
      throw Exception('Failed to search customers: ${e.message}');
    } catch (e) {
      print('❌ Search Customers General Exception: $e');
      throw Exception('Failed to search customers: ${e.toString()}');
    }
  }
}
