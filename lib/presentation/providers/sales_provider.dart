import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/sales_model.dart';

// Sales Provider (placeholder for now)
final salesProvider =
    StateNotifierProvider<SalesNotifier, AsyncValue<List<Sale>>>((ref) {
      return SalesNotifier();
    });

class SalesNotifier extends StateNotifier<AsyncValue<List<Sale>>> {
  SalesNotifier() : super(const AsyncValue.data([]));

  Future<void> createSale(Sale sale) async {
    // Implement create sale logic
    print('Creating sale: ${sale.saleCode}');
  }
}
