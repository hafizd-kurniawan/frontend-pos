import '../models/sale_model.dart';
import '../../core/network/dio_client.dart';

class SalesService {
  static final SalesService _instance = SalesService._internal();
  factory SalesService() => _instance;
  SalesService._internal();

  // ✅ ADD THIS METHOD
  Future<List<Sale>> getAllSales({
    int page = 1,
    int limit = 20,
    String? status,
  }) async {
    try {
      print('🔍 Fetching all sales...');

      final Map<String, dynamic> queryParams = {'page': page, 'limit': limit};

      if (status != null && status.isNotEmpty) {
        queryParams['status'] = status;
      }

      final response = await DioClient.instance.get(
        '/sales',
        queryParameters: queryParams,
      );

      print('✅ Sales response: ${response.data}');

      if (response.data['success'] == true) {
        final salesData = response.data['data']['sales'] as List;
        return salesData
            .map((item) => Sale.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(response.data['message'] ?? 'Failed to load sales');
      }
    } catch (e) {
      print('❌ Error loading sales: $e');
      return []; // Return empty list instead of throwing
    }
  }

  Future<Sale?> getSaleById(int id) async {
    try {
      print('🔍 Fetching sale with ID: $id');

      final response = await DioClient.instance.get('/sales/$id');

      print('✅ Sale detail response: ${response.data}');

      if (response.data['success'] == true) {
        return Sale.fromJson(response.data['data']);
      } else {
        print('❌ Sale not found: ${response.data['message']}');
        return null;
      }
    } catch (e) {
      print('❌ Error loading sale: $e');
      return null;
    }
  }

  Future<Sale> createSale({
    required int vehicleId,
    required int customerId,
    required double totalAmount,
    required double downPayment,
    required String paymentMethod,
    String? notes,
  }) async {
    try {
      print('📝 Creating sale...');

      final Map<String, dynamic> saleData = {
        'vehicle_id': vehicleId,
        'customer_id': customerId,
        'total_amount': totalAmount,
        'down_payment': downPayment,
        'remaining_amount': totalAmount - downPayment,
        'payment_method': paymentMethod,
        'notes': notes ?? '',
        'status': 'pending',
      };

      final response = await DioClient.instance.post('/sales', data: saleData);

      print('✅ Create sale response: ${response.data}');

      if (response.data['success'] == true) {
        return Sale.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to create sale');
      }
    } catch (e) {
      print('❌ Error creating sale: $e');
      rethrow;
    }
  }

  Future<List<Sale>> getSalesWithFilters({
    String? status,
    String? vehicleType,
    String? dateFrom,
    String? dateTo,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      print('🔍 Fetching sales with filters...');

      final Map<String, dynamic> queryParams = {'page': page, 'limit': limit};

      if (status != null) queryParams['status'] = status;
      if (vehicleType != null) queryParams['vehicle_type'] = vehicleType;
      if (dateFrom != null) queryParams['date_from'] = dateFrom;
      if (dateTo != null) queryParams['date_to'] = dateTo;

      final response = await DioClient.instance.get(
        '/sales/filter',
        queryParameters: queryParams,
      );

      print('✅ Filtered sales response: ${response.data}');

      if (response.data['success'] == true) {
        final salesData = response.data['data'] as List;
        return salesData
            .map((item) => Sale.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(response.data['message'] ?? 'Failed to load sales');
      }
    } catch (e) {
      print('❌ Error loading filtered sales: $e');
      return [];
    }
  }

  Future<bool> updateSaleStatus(int saleId, String status) async {
    try {
      print('📝 Updating sale status: $saleId -> $status');

      final response = await DioClient.instance.patch(
        '/sales/$saleId/status',
        data: {'status': status},
      );

      print('✅ Update sale status response: ${response.data}');

      return response.data['success'] == true;
    } catch (e) {
      print('❌ Error updating sale status: $e');
      return false;
    }
  }

  Future<bool> deleteSale(int id) async {
    try {
      print('🗑️ Deleting sale: $id');

      final response = await DioClient.instance.delete('/sales/$id');

      print('✅ Delete sale response: ${response.data}');

      return response.data['success'] == true;
    } catch (e) {
      print('❌ Error deleting sale: $e');
      return false;
    }
  }
}
