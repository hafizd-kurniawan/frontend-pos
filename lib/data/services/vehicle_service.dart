import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';
import '../../core/network/api_response.dart';
import '../../core/constants/api_constants.dart';
import '../models/vehicle_model.dart';

class VehicleService {
  Future<List<Vehicle>> getVehicles({
    int page = 1,
    int limit = 50,
    String? sortBy,
    String? sortOrder,
  }) async {
    try {
      final queryParams = <String, dynamic>{'page': page, 'limit': limit};

      if (sortBy != null) queryParams['sort_by'] = sortBy;
      if (sortOrder != null) queryParams['sort_order'] = sortOrder;

      print('🚀 API Call: GET ${ApiConstants.vehicles}');
      print('📋 Query Parameters: $queryParams');

      final response = await DioClient.instance.get(
        ApiConstants.vehicles,
        queryParameters: queryParams,
      );

      print('✅ API Response Status: ${response.statusCode}');
      print('📦 Raw Response: ${response.data}');

      // Handle both direct array and wrapped response
      List<dynamic> vehicleList;

      if (response.data is List) {
        // Direct array response
        vehicleList = response.data as List<dynamic>;
        print('📊 Direct array response with ${vehicleList.length} items');
      } else if (response.data is Map<String, dynamic>) {
        // Wrapped response
        final apiResponse = ApiResponse<List<dynamic>>.fromJson(
          response.data,
          (json) => json as List<dynamic>,
        );

        if (apiResponse.success && apiResponse.data != null) {
          vehicleList = apiResponse.data!;
          print('📊 Wrapped response with ${vehicleList.length} items');
        } else {
          throw Exception(apiResponse.message ?? 'No vehicle data received');
        }
      } else {
        throw Exception(
          'Unexpected response format: ${response.data.runtimeType}',
        );
      }

      final vehicles = vehicleList.map((vehicleJson) {
        try {
          return Vehicle.fromJson(vehicleJson as Map<String, dynamic>);
        } catch (e) {
          print('❌ Error parsing vehicle: $e');
          print('🔍 Vehicle JSON: $vehicleJson');
          rethrow;
        }
      }).toList();

      print('🚗 Successfully parsed ${vehicles.length} vehicles');
      return vehicles;
    } on DioException catch (e) {
      print('❌ Dio Exception: ${e.message}');
      print('📡 Error Type: ${e.type}');
      print('📄 Response Data: ${e.response?.data}');
      print('📄 Response Status: ${e.response?.statusCode}');

      if (e.response?.statusCode == 404) {
        throw Exception(
          'Vehicle endpoint not found. Please check API configuration.',
        );
      } else if (e.response?.statusCode == 500) {
        throw Exception('Server error. Please contact support.');
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception(
          'Connection timeout. Please check your internet connection.',
        );
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Server response timeout. Please try again.');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      print('❌ General Exception: $e');
      print('📍 Stack trace: ${StackTrace.current}');
      throw Exception('Failed to load vehicles: ${e.toString()}');
    }
  }

  Future<List<Vehicle>> searchVehicles({
    String? query,
    String? condition,
    String? status,
    String? sortBy,
    String? sortOrder,
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final queryParams = <String, dynamic>{'page': page, 'limit': limit};

      if (query != null && query.isNotEmpty) queryParams['search'] = query;
      if (condition != null && condition.isNotEmpty)
        queryParams['condition_status'] = condition;
      if (status != null && status.isNotEmpty)
        queryParams['availability_status'] = status;
      if (sortBy != null && sortBy.isNotEmpty) queryParams['sort_by'] = sortBy;
      if (sortOrder != null && sortOrder.isNotEmpty)
        queryParams['sort_order'] = sortOrder;

      print('🔍 API Search Call: GET ${ApiConstants.vehicles}');
      print('📋 Search Parameters: $queryParams');

      final response = await DioClient.instance.get(
        ApiConstants.vehicles,
        queryParameters: queryParams,
      );

      print('✅ Search Response Status: ${response.statusCode}');

      // Handle both direct array and wrapped response
      List<dynamic> vehicleList;

      if (response.data is List) {
        vehicleList = response.data as List<dynamic>;
      } else if (response.data is Map<String, dynamic>) {
        final apiResponse = ApiResponse<List<dynamic>>.fromJson(
          response.data,
          (json) => json as List<dynamic>,
        );

        if (apiResponse.success && apiResponse.data != null) {
          vehicleList = apiResponse.data!;
        } else {
          throw Exception(apiResponse.message ?? 'Search failed');
        }
      } else {
        throw Exception('Unexpected search response format');
      }

      final vehicles = vehicleList
          .map(
            (vehicleJson) =>
                Vehicle.fromJson(vehicleJson as Map<String, dynamic>),
          )
          .toList();

      print('🔍 Search Results: ${vehicles.length} vehicles found');
      return vehicles;
    } on DioException catch (e) {
      print('❌ Search Dio Exception: ${e.message}');

      if (e.response?.statusCode == 400) {
        throw Exception('Invalid search parameters');
      } else {
        throw Exception('Search failed: ${e.message}');
      }
    } catch (e) {
      print('❌ Search General Exception: $e');
      throw Exception('Search failed: ${e.toString()}');
    }
  }

  Future<Vehicle> getVehicleById(int vehicleId) async {
    try {
      print('🔍 API Call: GET ${ApiConstants.vehicles}/$vehicleId');

      final response = await DioClient.instance.get(
        '${ApiConstants.vehicles}/$vehicleId',
      );

      print('✅ Vehicle Detail Response Status: ${response.statusCode}');

      // Handle both direct object and wrapped response
      Map<String, dynamic> vehicleData;

      if (response.data is Map<String, dynamic>) {
        if (response.data.containsKey('data')) {
          // Wrapped response
          final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
            response.data,
            (json) => json as Map<String, dynamic>,
          );

          if (apiResponse.success && apiResponse.data != null) {
            vehicleData = apiResponse.data!;
          } else {
            throw Exception(apiResponse.message ?? 'Vehicle not found');
          }
        } else {
          // Direct object response
          vehicleData = response.data as Map<String, dynamic>;
        }
      } else {
        throw Exception('Unexpected vehicle detail response format');
      }

      final vehicle = Vehicle.fromJson(vehicleData);
      print('✅ Vehicle loaded: ${vehicle.brand} ${vehicle.model}');
      return vehicle;
    } on DioException catch (e) {
      print('❌ Vehicle Detail Dio Exception: ${e.message}');

      if (e.response?.statusCode == 404) {
        throw Exception('Vehicle not found');
      } else {
        throw Exception('Failed to load vehicle: ${e.message}');
      }
    } catch (e) {
      print('❌ Vehicle Detail General Exception: $e');
      throw Exception('Failed to load vehicle: ${e.toString()}');
    }
  }

  Future<Vehicle> createVehicle(Vehicle vehicle) async {
    try {
      print('➕ API Call: POST ${ApiConstants.vehicles}');

      final requestData = vehicle.toJson();
      requestData.remove('id'); // Remove ID for creation
      requestData.remove('category'); // Remove nested category object

      print('📤 Create Request Data: $requestData');

      final response = await DioClient.instance.post(
        ApiConstants.vehicles,
        data: requestData,
      );

      print('✅ Create Response Status: ${response.statusCode}');
      print('📦 Create Response Data: ${response.data}');

      // Handle both direct object and wrapped response
      Map<String, dynamic> vehicleData;

      if (response.data is Map<String, dynamic>) {
        if (response.data.containsKey('data')) {
          // Wrapped response
          final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
            response.data,
            (json) => json as Map<String, dynamic>,
          );

          if (apiResponse.success && apiResponse.data != null) {
            vehicleData = apiResponse.data!;
          } else {
            throw Exception(apiResponse.message ?? 'Failed to create vehicle');
          }
        } else {
          // Direct object response
          vehicleData = response.data as Map<String, dynamic>;
        }
      } else {
        throw Exception('Unexpected create response format');
      }

      final createdVehicle = Vehicle.fromJson(vehicleData);
      print('✅ Vehicle created successfully with ID: ${createdVehicle.id}');
      return createdVehicle;
    } on DioException catch (e) {
      print('❌ Create Vehicle Dio Exception: ${e.message}');
      print('📄 Error Response: ${e.response?.data}');

      if (e.response?.statusCode == 400) {
        final errorData = e.response?.data;
        if (errorData is Map && errorData.containsKey('message')) {
          throw Exception(errorData['message']);
        } else if (errorData is Map && errorData.containsKey('errors')) {
          throw Exception('Validation error: ${errorData['errors']}');
        }
      } else if (e.response?.statusCode == 409) {
        throw Exception('Vehicle code or chassis number already exists');
      }

      throw Exception('Failed to create vehicle: ${e.message}');
    } catch (e) {
      print('❌ Create Vehicle General Exception: $e');
      throw Exception('Failed to create vehicle: ${e.toString()}');
    }
  }

  Future<Vehicle> updateVehicle(Vehicle vehicle) async {
    try {
      print('✏️ API Call: PUT ${ApiConstants.vehicles}/${vehicle.id}');

      final requestData = vehicle.toJson();
      requestData.remove('category'); // Remove nested category object

      print('📤 Update Request Data: $requestData');

      final response = await DioClient.instance.put(
        '${ApiConstants.vehicles}/${vehicle.id}',
        data: requestData,
      );

      print('✅ Update Response Status: ${response.statusCode}');

      // Handle both direct object and wrapped response
      Map<String, dynamic> vehicleData;

      if (response.data is Map<String, dynamic>) {
        if (response.data.containsKey('data')) {
          // Wrapped response
          final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
            response.data,
            (json) => json as Map<String, dynamic>,
          );

          if (apiResponse.success && apiResponse.data != null) {
            vehicleData = apiResponse.data!;
          } else {
            throw Exception(apiResponse.message ?? 'Failed to update vehicle');
          }
        } else {
          // Direct object response
          vehicleData = response.data as Map<String, dynamic>;
        }
      } else {
        throw Exception('Unexpected update response format');
      }

      final updatedVehicle = Vehicle.fromJson(vehicleData);
      print('✅ Vehicle updated successfully');
      return updatedVehicle;
    } on DioException catch (e) {
      print('❌ Update Vehicle Dio Exception: ${e.message}');

      if (e.response?.statusCode == 404) {
        throw Exception('Vehicle not found');
      } else if (e.response?.statusCode == 400) {
        final errorData = e.response?.data;
        if (errorData is Map && errorData.containsKey('message')) {
          throw Exception(errorData['message']);
        }
      }

      throw Exception('Failed to update vehicle: ${e.message}');
    } catch (e) {
      print('❌ Update Vehicle General Exception: $e');
      throw Exception('Failed to update vehicle: ${e.toString()}');
    }
  }

  Future<void> deleteVehicle(int vehicleId) async {
    try {
      print('🗑️ API Call: DELETE ${ApiConstants.vehicles}/$vehicleId');

      final response = await DioClient.instance.delete(
        '${ApiConstants.vehicles}/$vehicleId',
      );

      print('✅ Delete Response Status: ${response.statusCode}');

      // Check if response indicates success
      if (response.statusCode == 200 || response.statusCode == 204) {
        print('✅ Vehicle deleted successfully');
        return;
      }

      // Handle wrapped response
      if (response.data is Map<String, dynamic>) {
        final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
          response.data,
          (json) => json as Map<String, dynamic>,
        );

        if (!apiResponse.success) {
          throw Exception(apiResponse.message ?? 'Failed to delete vehicle');
        }
      }

      print('✅ Vehicle deleted successfully');
    } on DioException catch (e) {
      print('❌ Delete Vehicle Dio Exception: ${e.message}');

      if (e.response?.statusCode == 404) {
        throw Exception('Vehicle not found');
      } else if (e.response?.statusCode == 409) {
        throw Exception(
          'Cannot delete vehicle - it may be referenced in other records',
        );
      }

      throw Exception('Failed to delete vehicle: ${e.message}');
    } catch (e) {
      print('❌ Delete Vehicle General Exception: $e');
      throw Exception('Failed to delete vehicle: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> getVehicleStatistics() async {
    try {
      print(
        '📊 API Call: GET ${ApiConstants.fullBaseUrl}${ApiConstants.vehicleStats}',
      );

      final response = await DioClient.instance.get(ApiConstants.vehicleStats);

      print('✅ Statistics Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = response.data;

        // Handle both direct object and wrapped response
        Map<String, dynamic> statsData;

        if (responseData is Map<String, dynamic>) {
          if (responseData.containsKey('success') &&
              responseData.containsKey('data')) {
            // Wrapped response
            statsData = responseData['data'] as Map<String, dynamic>;
          } else {
            // Direct object response
            statsData = responseData;
          }
        } else {
          throw Exception('Unexpected statistics response format');
        }

        print('✅ Statistics loaded: $statsData');
        return statsData;
      } else {
        throw Exception(
          'Failed to load statistics: HTTP ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      print('❌ Statistics Dio Exception: ${e.message}');
      print('📄 Error Response: ${e.response?.data}');
      print('📊 Status Code: ${e.response?.statusCode}');

      if (e.response?.statusCode == 404) {
        throw Exception('Statistics endpoint not found');
      } else if (e.response?.statusCode == 401) {
        throw Exception('Authentication required for statistics');
      } else {
        throw Exception('Failed to load statistics: ${e.message}');
      }
    } catch (e) {
      print('❌ Statistics General Exception: $e');
      throw Exception('Failed to load statistics: ${e.toString()}');
    }
  }
}
