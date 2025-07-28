import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/customer_model.dart';
import '../../data/services/customer_service.dart';

class CustomerState {
  final List<Customer> customers;
  final bool isLoading;
  final bool isCreating;
  final String? error;

  CustomerState({
    this.customers = const [],
    this.isLoading = false,
    this.isCreating = false,
    this.error,
  });

  CustomerState copyWith({
    List<Customer>? customers,
    bool? isLoading,
    bool? isCreating,
    String? error,
  }) {
    return CustomerState(
      customers: customers ?? this.customers,
      isLoading: isLoading ?? this.isLoading,
      isCreating: isCreating ?? this.isCreating,
      error: error ?? this.error,
    );
  }
}

class CustomerNotifier extends StateNotifier<CustomerState> {
  final CustomerService _customerService = CustomerService();

  CustomerNotifier() : super(CustomerState());

  Future<void> loadCustomers() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      print('🔄 Loading customers from API...');
      final customers = await _customerService.getAllCustomers();
      print('✅ Loaded ${customers.length} customers');
      state = state.copyWith(isLoading: false, customers: customers);
    } catch (e) {
      print('❌ Error loading customers: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> searchCustomers(String query) async {
    try {
      print('🔍 Searching customers with query: $query');
      final customers = await _customerService.searchCustomers();
      state = state.copyWith(customers: customers);
    } catch (e) {
      print('❌ Error searching customers: $e');
      state = state.copyWith(error: e.toString());
    }
  }

  // ✅ FIXED CREATE CUSTOMER WITH REAL API CALL
  Future<bool> createCustomer({
    required String name,
    required String phone,
    required String email,
    required String address,
    String? companyName,
  }) async {
    state = state.copyWith(isCreating: true, error: null);

    try {
      print('🚀 Creating customer via API...');
      print(
        '📋 Customer data: name=$name, phone=$phone, email=$email, address=$address',
      );

      // ✅ REAL API CALL TO CREATE CUSTOMER
      final createdCustomer = await _customerService.createCustomer(
        fullName: name,
        phone: phone,
        email: email,
        address: address,
        // companyName: companyName,
      );

      print(
        '✅ Customer created successfully: ${createdCustomer.fullName} (ID: ${createdCustomer.id})',
      );

      // ✅ ADD TO LOCAL STATE
      final updatedCustomers = [...state.customers, createdCustomer];
      state = state.copyWith(isCreating: false, customers: updatedCustomers);

      print('📊 Total customers in state: ${state.customers.length}');
      return true;
    } catch (e) {
      print('❌ Error creating customer: $e');
      state = state.copyWith(isCreating: false, error: e.toString());
      return false;
    }
  }
}

final customerProvider = StateNotifierProvider<CustomerNotifier, CustomerState>(
  (ref) {
    return CustomerNotifier();
  },
);

final customerSearchResultsProvider = Provider<List<Customer>>((ref) {
  return ref.watch(customerProvider).customers;
});

final selectedCustomerProvider = Provider<Customer?>((ref) {
  return null;
});
