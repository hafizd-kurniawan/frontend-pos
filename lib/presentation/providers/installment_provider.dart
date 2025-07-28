import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/installment_model.dart';
import '../../data/models/payment_method_model.dart';
import '../../data/services/installment_service.dart';

class InstallmentState {
  final List<Installment> installments;
  final List<PaymentMethod> paymentMethods;
  final InstallmentPreview? currentPreview;
  final Map<String, dynamic> stats;
  final bool isLoading;
  final bool isLoadingPreview;
  final bool isProcessingPayment;
  final String? error;
  final String selectedFilter;

  InstallmentState({
    this.installments = const [],
    this.paymentMethods = const [],
    this.currentPreview,
    this.stats = const {},
    this.isLoading = false,
    this.isLoadingPreview = false,
    this.isProcessingPayment = false,
    this.error,
    this.selectedFilter = 'all',
  });

  InstallmentState copyWith({
    List<Installment>? installments,
    List<PaymentMethod>? paymentMethods,
    InstallmentPreview? currentPreview,
    Map<String, dynamic>? stats,
    bool? isLoading,
    bool? isLoadingPreview,
    bool? isProcessingPayment,
    String? error,
    String? selectedFilter,
  }) {
    return InstallmentState(
      installments: installments ?? this.installments,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      currentPreview: currentPreview ?? this.currentPreview,
      stats: stats ?? this.stats,
      isLoading: isLoading ?? this.isLoading,
      isLoadingPreview: isLoadingPreview ?? this.isLoadingPreview,
      isProcessingPayment: isProcessingPayment ?? this.isProcessingPayment,
      error: error,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }

  // Computed properties
  List<Installment> get filteredInstallments {
    switch (selectedFilter.toLowerCase()) {
      case 'pending':
        return installments.where((i) => i.status == 'pending' && !i.isOverdue).toList();
      case 'overdue':
        return installments.where((i) => i.status == 'pending' && i.isOverdue || i.status == 'overdue').toList();
      case 'paid':
        return installments.where((i) => i.status == 'paid').toList();
      case 'partially_paid':
        return installments.where((i) => i.status == 'partially_paid').toList();
      default:
        return installments;
    }
  }

  int get pendingCount => installments.where((i) => i.status == 'pending' && !i.isOverdue).length;
  int get overdueCount => installments.where((i) => i.isOverdue || i.status == 'overdue').length;
  int get paidCount => installments.where((i) => i.status == 'paid').length;
  
  double get totalPendingAmount => installments
      .where((i) => i.status == 'pending' && !i.isOverdue)
      .fold(0.0, (sum, i) => sum + i.remainingAmount);
      
  double get totalOverdueAmount => installments
      .where((i) => i.isOverdue || i.status == 'overdue')
      .fold(0.0, (sum, i) => sum + i.remainingAmount);
}

class InstallmentNotifier extends StateNotifier<InstallmentState> {
  final InstallmentService _installmentService = InstallmentService();

  InstallmentNotifier() : super(InstallmentState());

  /// Load payment methods
  Future<void> loadPaymentMethods() async {
    try {
      final paymentMethods = await _installmentService.getPaymentMethods();
      state = state.copyWith(paymentMethods: paymentMethods);
    } catch (e) {
      print('❌ Error loading payment methods: $e');
      state = state.copyWith(error: e.toString());
    }
  }

  /// Calculate payment preview
  Future<void> calculatePaymentPreview(PaymentPreviewRequest request) async {
    state = state.copyWith(isLoadingPreview: true, error: null);
    
    try {
      final preview = await _installmentService.getPaymentPreview(request);
      state = state.copyWith(
        currentPreview: preview,
        isLoadingPreview: false,
      );
    } catch (e) {
      print('❌ Error calculating payment preview: $e');
      state = state.copyWith(
        isLoadingPreview: false,
        error: e.toString(),
      );
    }
  }

  /// Load installments with optional filter
  Future<void> loadInstallments({String? filter}) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final installments = await _installmentService.getAllInstallments(
        status: filter,
      );
      
      state = state.copyWith(
        installments: installments,
        isLoading: false,
        selectedFilter: filter ?? 'all',
      );
    } catch (e) {
      print('❌ Error loading installments: $e');
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Load installments for a specific transaction
  Future<void> loadTransactionInstallments(int transactionId) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final installments = await _installmentService.getTransactionInstallments(transactionId);
      state = state.copyWith(
        installments: installments,
        isLoading: false,
      );
    } catch (e) {
      print('❌ Error loading transaction installments: $e');
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Pay an installment
  Future<bool> payInstallment(
    int transactionId,
    int installmentId,
    PayInstallmentRequest request,
  ) async {
    state = state.copyWith(isProcessingPayment: true, error: null);
    
    try {
      final success = await _installmentService.payInstallment(
        transactionId,
        installmentId,
        request,
      );
      
      if (success) {
        // Reload installments to get updated status
        await loadInstallments(filter: state.selectedFilter);
        await loadInstallmentStats();
      }
      
      state = state.copyWith(isProcessingPayment: false);
      return success;
    } catch (e) {
      print('❌ Error paying installment: $e');
      state = state.copyWith(
        isProcessingPayment: false,
        error: e.toString(),
      );
      return false;
    }
  }

  /// Load overdue installments
  Future<void> loadOverdueInstallments() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final overdueInstallments = await _installmentService.getOverdueInstallments();
      state = state.copyWith(
        installments: overdueInstallments,
        isLoading: false,
        selectedFilter: 'overdue',
      );
    } catch (e) {
      print('❌ Error loading overdue installments: $e');
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Update installment status
  Future<bool> updateInstallmentStatus(int installmentId, String status) async {
    try {
      final success = await _installmentService.updateInstallmentStatus(installmentId, status);
      
      if (success) {
        // Update local state
        final updatedInstallments = state.installments.map((installment) {
          if (installment.id == installmentId) {
            return installment.copyWith(status: status);
          }
          return installment;
        }).toList();
        
        state = state.copyWith(installments: updatedInstallments);
        await loadInstallmentStats();
      }
      
      return success;
    } catch (e) {
      print('❌ Error updating installment status: $e');
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  /// Load installment statistics
  Future<void> loadInstallmentStats() async {
    try {
      final stats = await _installmentService.getInstallmentStats();
      state = state.copyWith(stats: stats);
    } catch (e) {
      print('❌ Error loading installment stats: $e');
      state = state.copyWith(error: e.toString());
    }
  }

  /// Filter installments by status
  void filterInstallments(String filter) {
    state = state.copyWith(selectedFilter: filter);
  }

  /// Clear current preview
  void clearPreview() {
    state = state.copyWith(currentPreview: null);
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Refresh all data
  Future<void> refreshAll() async {
    await Future.wait([
      loadPaymentMethods(),
      loadInstallments(filter: state.selectedFilter),
      loadInstallmentStats(),
    ]);
  }

  /// Get installment by ID
  Installment? getInstallmentById(int id) {
    try {
      return state.installments.firstWhere((installment) => installment.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Check if payment method supports installments
  bool paymentMethodSupportsInstallments(String paymentMethodId) {
    try {
      final paymentMethod = state.paymentMethods.firstWhere(
        (method) => method.id == paymentMethodId,
      );
      return paymentMethod.supportsInstallments;
    } catch (e) {
      return false;
    }
  }
}

// Provider
final installmentProvider = StateNotifierProvider<InstallmentNotifier, InstallmentState>((ref) {
  return InstallmentNotifier();
});

// Helper providers for specific data
final paymentMethodsProvider = Provider<List<PaymentMethod>>((ref) {
  return ref.watch(installmentProvider).paymentMethods;
});

final installmentPreviewProvider = Provider<InstallmentPreview?>((ref) {
  return ref.watch(installmentProvider).currentPreview;
});

final filteredInstallmentsProvider = Provider<List<Installment>>((ref) {
  return ref.watch(installmentProvider).filteredInstallments;
});

final installmentStatsProvider = Provider<Map<String, dynamic>>((ref) {
  return ref.watch(installmentProvider).stats;
});

// Quick installment options provider
final quickInstallmentOptionsProvider = Provider<List<int>>((ref) {
  return [6, 12, 24, 36]; // months
});