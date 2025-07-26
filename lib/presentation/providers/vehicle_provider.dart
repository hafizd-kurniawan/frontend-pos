import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/vehicle_model.dart';
import '../../data/services/vehicle_service.dart';

// Vehicle Service Provider
final vehicleServiceProvider = Provider<VehicleService>((ref) {
  return VehicleService();
});

// Vehicle List State Notifier
class VehicleListNotifier extends StateNotifier<AsyncValue<List<Vehicle>>> {
  final VehicleService _vehicleService;

  VehicleListNotifier(this._vehicleService) : super(const AsyncValue.loading());

  Future<void> loadVehicles({
    int page = 1,
    int limit = 50,
    String? sortBy,
    String? sortOrder,
  }) async {
    state = const AsyncValue.loading();

    try {
      print('🔄 Loading vehicles from API...');
      final vehicles = await _vehicleService.getVehicles(
        page: page,
        limit: limit,
        sortBy: sortBy,
        sortOrder: sortOrder,
      );

      print('✅ Loaded ${vehicles.length} vehicles successfully');
      state = AsyncValue.data(vehicles);
    } catch (error, stackTrace) {
      print('❌ Error loading vehicles: $error');
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> searchVehicles({
    String? query,
    String? condition,
    String? status,
    String? sortBy,
    String? sortOrder,
    int page = 1,
    int limit = 50,
  }) async {
    state = const AsyncValue.loading();

    try {
      print(
        '🔍 Searching vehicles: query="$query", condition="$condition", status="$status"',
      );
      final vehicles = await _vehicleService.searchVehicles(
        query: query,
        condition: condition,
        status: status,
        sortBy: sortBy,
        sortOrder: sortOrder,
        page: page,
        limit: limit,
      );

      print('✅ Search completed: ${vehicles.length} vehicles found');
      state = AsyncValue.data(vehicles);
    } catch (error, stackTrace) {
      print('❌ Error searching vehicles: $error');
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> addVehicle(Vehicle vehicle) async {
    try {
      print('➕ Adding new vehicle: ${vehicle.brand} ${vehicle.model}');
      final newVehicle = await _vehicleService.createVehicle(vehicle);

      state.whenData((vehicles) {
        final updatedList = [newVehicle, ...vehicles];
        state = AsyncValue.data(updatedList);
        print(
          '✅ Vehicle added successfully. Total vehicles: ${updatedList.length}',
        );
      });
    } catch (error, stackTrace) {
      print('❌ Error adding vehicle: $error');
      state = AsyncValue.error(error, stackTrace);
      rethrow; // Re-throw to handle in UI
    }
  }

  Future<void> updateVehicle(Vehicle vehicle) async {
    try {
      print(
        '✏️ Updating vehicle: ${vehicle.brand} ${vehicle.model} (ID: ${vehicle.id})',
      );
      final updatedVehicle = await _vehicleService.updateVehicle(vehicle);

      state.whenData((vehicles) {
        final updatedList = vehicles
            .map((v) => v.id == updatedVehicle.id ? updatedVehicle : v)
            .toList();
        state = AsyncValue.data(updatedList);
        print('✅ Vehicle updated successfully');
      });
    } catch (error, stackTrace) {
      print('❌ Error updating vehicle: $error');
      state = AsyncValue.error(error, stackTrace);
      rethrow; // Re-throw to handle in UI
    }
  }

  Future<void> deleteVehicle(int vehicleId) async {
    try {
      print('🗑️ Deleting vehicle ID: $vehicleId');
      await _vehicleService.deleteVehicle(vehicleId);

      state.whenData((vehicles) {
        final updatedList = vehicles.where((v) => v.id != vehicleId).toList();
        state = AsyncValue.data(updatedList);
        print(
          '✅ Vehicle deleted successfully. Remaining vehicles: ${updatedList.length}',
        );
      });
    } catch (error, stackTrace) {
      print('❌ Error deleting vehicle: $error');
      state = AsyncValue.error(error, stackTrace);
      rethrow; // Re-throw to handle in UI
    }
  }

  Future<void> refreshVehicles() async {
    print('🔄 Refreshing vehicle list...');
    await loadVehicles();
  }
}

// Vehicle List Provider
final vehicleListProvider =
    StateNotifierProvider<VehicleListNotifier, AsyncValue<List<Vehicle>>>((
      ref,
    ) {
      final vehicleService = ref.read(vehicleServiceProvider);
      return VehicleListNotifier(vehicleService);
    });

// Individual Vehicle Provider
final vehicleDetailProvider = FutureProvider.family<Vehicle, int>((
  ref,
  vehicleId,
) async {
  final vehicleService = ref.read(vehicleServiceProvider);
  print('🔍 Fetching vehicle details for ID: $vehicleId');
  return await vehicleService.getVehicleById(vehicleId);
});

// Vehicle Statistics Provider
final vehicleStatsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final vehicleService = ref.read(vehicleServiceProvider);
  print('📊 Fetching vehicle statistics from API...');
  return await vehicleService.getVehicleStatistics();
});
