import '../../core/network/dio_client.dart';
import '../../core/network/api_response.dart';
import '../../core/constants/api_constants.dart';

class DashboardService {
  Future<Map<String, dynamic>> getCashierDashboard() async {
    try {
      final response = await DioClient.instance.get(
        ApiConstants.cashierDashboard,
      );

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data!;
      } else {
        throw Exception(apiResponse.message);
      }
    } catch (e) {
      // Return mock data for now
      return {
        'cashier_id': 1,
        'date': DateTime.now().toIso8601String().split('T')[0],
        'today_sales_count': 5,
        'today_purchase_count': 2,
        'today_sales_amount': 750000000.0,
        'today_purchase_amount': 300000000.0,
        'recent_transactions': [],
        'last_updated': DateTime.now().toIso8601String(),
      };
    }
  }

  Future<Map<String, dynamic>> getMechanicDashboard() async {
    try {
      final response = await DioClient.instance.get(
        ApiConstants.mechanicDashboard,
      );

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data!;
      } else {
        throw Exception(apiResponse.message);
      }
    } catch (e) {
      // Return mock data for now
      return {
        'mechanic_id': 1,
        'vehicles_in_maintenance': 8,
        'pending_work': 5,
        'condition_breakdown': {
          'excellent': 15,
          'good': 25,
          'fair': 8,
          'poor': 3,
        },
        'maintenance_vehicles': [],
        'total_vehicles': 51,
        'last_updated': DateTime.now().toIso8601String(),
      };
    }
  }

  Future<Map<String, dynamic>> getTodayTransactions() async {
    try {
      final response = await DioClient.instance.get(
        ApiConstants.todayTransactions,
      );

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data!;
      } else {
        throw Exception(apiResponse.message);
      }
    } catch (e) {
      // Return mock data for now
      return {
        'date': DateTime.now().toIso8601String().split('T')[0],
        'sales': [],
        'purchases': [],
        'total_transactions': 0,
        'recent_transactions': [
          {'type': 'sale', 'time': '10:30', 'amount': 250000000},
          {'type': 'purchase', 'time': '14:15', 'amount': 180000000},
        ],
      };
    }
  }

  Future<Map<String, dynamic>> getDashboardStats() async {
    try {
      final response = await DioClient.instance.get(
        ApiConstants.dashboardStats,
      );

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );

      if (apiResponse.success && apiResponse.data != null) {
        return apiResponse.data!;
      } else {
        throw Exception(apiResponse.message);
      }
    } catch (e) {
      // Return mock data for now
      return {
        'total_vehicles': 51,
        'available_vehicles': 38,
        'sold_vehicles': 8,
        'maintenance_vehicles': 5,
        'total_customers': 125,
        'active_customers': 89,
        'monthly_sales': 15,
        'monthly_revenue': 3750000000.0,
      };
    }
  }
}
