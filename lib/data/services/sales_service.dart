import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';
import '../../core/constants/api_constants.dart';
import '../../data/models/sale_model.dart';
import '../models/customer_model.dart';

class SalesService {
  Future<Sale> createSale({required Sale saleData}) async {
    try {
      print('🛒 Creating sale transaction');
      print('📋 Sale data: ${saleData.toJson()}');

      final response = await DioClient.instance.post(
        ApiConstants.salesTransactions,
        data: saleData.toJson(),
      );

      print('✅ Sale Response Status: ${response.statusCode}');
      print('📦 Sale Response Data: ${response.data}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;

        // Check if wrapped in success structure
        if (responseData.containsKey('success') &&
            responseData['success'] == true &&
            responseData.containsKey('data')) {
          final saleResponseData = responseData['data'] as Map<String, dynamic>;
          return Sale.fromJson(saleResponseData);
        } else {
          // Direct response
          return Sale.fromJson(responseData);
        }
      } else {
        throw Exception('Failed to create sale transaction');
      }
    } on DioException catch (e) {
      print('❌ Create Sale Dio Exception: ${e.message}');
      print('📄 Response: ${e.response?.data}');
      print('📊 Status: ${e.response?.statusCode}');

      if (e.response?.statusCode == 400) {
        final errorData = e.response?.data as Map<String, dynamic>?;
        final errorMessage = errorData?['message'] ?? 'Invalid sale data';
        throw Exception(errorMessage);
      } else if (e.response?.statusCode == 404) {
        throw Exception('Vehicle or customer not found');
      } else if (e.response?.statusCode == 409) {
        throw Exception('Vehicle is not available for sale');
      } else {
        throw Exception('Failed to create sale: ${e.message}');
      }
    } catch (e) {
      print('❌ Create Sale General Exception: $e');
      throw Exception('Failed to create sale: ${e.toString()}');
    }
  }

  Future<List<Sale>> getSales({
    int page = 1,
    int limit = 20,
    String? search,
    String? status,
    String? sortBy = 'created_at',
    String? sortOrder = 'desc',
  }) async {
    try {
      print('📋 Fetching sales list');

      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
        if (search != null && search.isNotEmpty) 'search': search,
        if (status != null && status.isNotEmpty) 'status': status,
        'sort_by': sortBy,
        'sort_order': sortOrder,
      };

      final response = await DioClient.instance.get(
        ApiConstants.salesTransactions,
        queryParameters: queryParams,
      );

      print('✅ Sales List Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;

        // Check if wrapped in success structure
        if (responseData.containsKey('success') &&
            responseData['success'] == true &&
            responseData.containsKey('data')) {
          final salesData = responseData['data'] as List;
          return salesData
              .map((sale) => Sale.fromJson(sale as Map<String, dynamic>))
              .toList();
        } else if (responseData.containsKey('data') &&
            responseData['data'] is List) {
          // Data is directly in 'data' field
          final salesData = responseData['data'] as List;
          return salesData
              .map((sale) => Sale.fromJson(sale as Map<String, dynamic>))
              .toList();
        } else if (responseData is List) {
          // Direct list response
          return responseData
              .map((sale) => Sale.fromJson(sale as Map<String, dynamic>))
              .toList();
        } else {
          return [];
        }
      } else {
        throw Exception('Failed to fetch sales');
      }
    } on DioException catch (e) {
      print('❌ Get Sales Error: ${e.message}');
      throw Exception('Failed to fetch sales: ${e.message}');
    } catch (e) {
      print('❌ Get Sales General Exception: $e');
      throw Exception('Failed to fetch sales: ${e.toString()}');
    }
  }

  Future<Sale> getSaleById(int saleId) async {
    try {
      print('📋 Fetching sale details for ID: $saleId');

      final response = await DioClient.instance.get(
        '${ApiConstants.salesTransactions}/$saleId',
      );

      print('✅ Sale Detail Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;

        // Check if wrapped in success structure
        if (responseData.containsKey('success') &&
            responseData['success'] == true &&
            responseData.containsKey('data')) {
          final saleData = responseData['data'] as Map<String, dynamic>;
          return Sale.fromJson(saleData);
        } else {
          // Direct response
          return Sale.fromJson(responseData);
        }
      } else {
        throw Exception('Sale not found');
      }
    } on DioException catch (e) {
      print('❌ Get Sale Detail Error: ${e.message}');
      if (e.response?.statusCode == 404) {
        throw Exception('Sale not found');
      }
      throw Exception('Failed to fetch sale details: ${e.message}');
    } catch (e) {
      print('❌ Get Sale Detail General Exception: $e');
      throw Exception('Failed to fetch sale details: ${e.toString()}');
    }
  }

  Future<void> updateSaleStatus({
    required int saleId,
    required String status,
    String? notes,
  }) async {
    try {
      print('🔄 Updating sale status: $saleId to $status');

      final response = await DioClient.instance.patch(
        '${ApiConstants.salesTransactions}/$saleId/status',
        data: {'status': status, if (notes != null) 'notes': notes},
      );

      print('✅ Update Sale Status Response: ${response.statusCode}');

      if (response.statusCode != 200) {
        throw Exception('Failed to update sale status');
      }
    } on DioException catch (e) {
      print('❌ Update Sale Status Error: ${e.message}');
      throw Exception('Failed to update sale status: ${e.message}');
    } catch (e) {
      print('❌ Update Sale Status General Exception: $e');
      throw Exception('Failed to update sale status: ${e.toString()}');
    }
  }

  Future<void> cancelSale({required int saleId, required String reason}) async {
    try {
      print('❌ Cancelling sale: $saleId');

      final response = await DioClient.instance.patch(
        '${ApiConstants.salesTransactions}/$saleId/cancel',
        data: {'reason': reason},
      );

      print('✅ Cancel Sale Response: ${response.statusCode}');

      if (response.statusCode != 200) {
        throw Exception('Failed to cancel sale');
      }
    } on DioException catch (e) {
      print('❌ Cancel Sale Error: ${e.message}');
      throw Exception('Failed to cancel sale: ${e.message}');
    } catch (e) {
      print('❌ Cancel Sale General Exception: $e');
      throw Exception('Failed to cancel sale: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> generateReceipt(int saleId) async {
    try {
      print('🧾 Generating receipt for sale: $saleId');

      final response = await DioClient.instance.get(
        '${ApiConstants.salesTransactions}/$saleId/receipt',
      );

      print('✅ Receipt Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;

        // Check if wrapped in success structure
        if (responseData.containsKey('success') &&
            responseData['success'] == true &&
            responseData.containsKey('data')) {
          return responseData['data'] as Map<String, dynamic>;
        } else {
          return responseData;
        }
      } else {
        throw Exception('Failed to generate receipt');
      }
    } on DioException catch (e) {
      print('❌ Generate Receipt Error: ${e.message}');
      throw Exception('Failed to generate receipt: ${e.message}');
    } catch (e) {
      print('❌ Generate Receipt General Exception: $e');
      throw Exception('Failed to generate receipt: ${e.toString()}');
    }
  }
}
