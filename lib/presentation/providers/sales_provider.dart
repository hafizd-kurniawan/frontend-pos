import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/sale_model.dart';
import '../../data/services/sales_service.dart';

class SalesState {
  final List<Sale> sales;
  final bool isLoading;
  final bool isCreating;
  final String? error;

  SalesState({
    this.sales = const [],
    this.isLoading = false,
    this.isCreating = false,
    this.error,
  });

  SalesState copyWith({
    List<Sale>? sales,
    bool? isLoading,
    bool? isCreating,
    String? error,
  }) {
    return SalesState(
      sales: sales ?? this.sales,
      isLoading: isLoading ?? this.isLoading,
      isCreating: isCreating ?? this.isCreating,
      error: error ?? this.error,
    );
  }
}

class SalesNotifier extends StateNotifier<SalesState> {
  final SalesService _salesService = SalesService();

  SalesNotifier() : super(SalesState());

  String generateSaleCode() {
    return 'SALE-${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<void> createSale({
    required int vehicleId,
    required int customerId,
    required double totalAmount,
    required double downPayment,
    required String paymentMethod,
    String? notes,
  }) async {
    state = state.copyWith(isCreating: true, error: null);

    try {
      final sale = Sale(
        id: DateTime.now().millisecondsSinceEpoch,
        vehicleId: vehicleId,
        customerId: customerId,
        saleDate: DateTime.now().toIso8601String(),
        totalAmount: totalAmount,
        downPayment: downPayment,
        remainingAmount: totalAmount - downPayment,
        paymentMethod: paymentMethod,
        status: 'completed',
        notes: notes ?? '',
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      );

      state = state.copyWith(isCreating: false, sales: [...state.sales, sale]);
    } catch (e) {
      state = state.copyWith(isCreating: false, error: e.toString());
    }
  }

  Future<void> loadSales() async {
    state = state.copyWith(isLoading: true);
    try {
      final sales = await _salesService.getAllSales();
      state = state.copyWith(isLoading: false, sales: sales);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final salesProvider = StateNotifierProvider<SalesNotifier, SalesState>((ref) {
  return SalesNotifier();
});

// Alias untuk compatibility
final salesListProvider = salesProvider;
