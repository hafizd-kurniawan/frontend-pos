import 'dart:math' as math;
import '../models/installment_model.dart';
import '../models/payment_method_model.dart';
import '../../core/network/dio_client.dart';

class InstallmentService {
  static final InstallmentService _instance = InstallmentService._internal();
  factory InstallmentService() => _instance;
  InstallmentService._internal();

  /// Get available payment methods
  Future<List<PaymentMethod>> getPaymentMethods() async {
    try {
      print('🔍 Fetching payment methods...');

      final response = await DioClient.instance.get('/api/sales/payment-methods');

      print('✅ Payment methods response: ${response.data}');

      if (response.data['success'] == true) {
        final methodsData = response.data['data'] as List;
        return methodsData
            .map((item) => PaymentMethod.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(response.data['message'] ?? 'Failed to load payment methods');
      }
    } catch (e) {
      print('❌ Error loading payment methods: $e');
      // Return default payment methods as fallback
      return PaymentMethod.defaultPaymentMethods;
    }
  }

  /// Calculate installment preview
  Future<InstallmentPreview> getPaymentPreview(PaymentPreviewRequest request) async {
    try {
      print('🔍 Calculating payment preview...');
      print('📤 Request: ${request.toJson()}');

      final response = await DioClient.instance.post(
        '/api/sales/payment-preview',
        data: request.toJson(),
      );

      print('✅ Payment preview response: ${response.data}');

      if (response.data['success'] == true) {
        return InstallmentPreview.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to calculate payment preview');
      }
    } catch (e) {
      print('❌ Error calculating payment preview: $e');
      
      // Return a fallback calculation
      return _calculateFallbackPreview(request);
    }
  }

  /// Get installments for a specific transaction
  Future<List<Installment>> getTransactionInstallments(int transactionId) async {
    try {
      print('🔍 Fetching installments for transaction: $transactionId');

      final response = await DioClient.instance.get(
        '/api/sales/transactions/$transactionId/installments',
      );

      print('✅ Transaction installments response: ${response.data}');

      if (response.data['success'] == true) {
        final installmentsData = response.data['data'] as List;
        return installmentsData
            .map((item) => Installment.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(response.data['message'] ?? 'Failed to load installments');
      }
    } catch (e) {
      print('❌ Error loading transaction installments: $e');
      return [];
    }
  }

  /// Pay an installment
  Future<bool> payInstallment(
    int transactionId,
    int installmentId,
    PayInstallmentRequest request,
  ) async {
    try {
      print('💳 Processing installment payment...');
      print('📤 Transaction: $transactionId, Installment: $installmentId');
      print('📤 Payment data: ${request.toJson()}');

      final response = await DioClient.instance.post(
        '/api/sales/transactions/$transactionId/installments/$installmentId/pay',
        data: request.toJson(),
      );

      print('✅ Pay installment response: ${response.data}');

      return response.data['success'] == true;
    } catch (e) {
      print('❌ Error paying installment: $e');
      return false;
    }
  }

  /// Get overdue installments
  Future<List<Installment>> getOverdueInstallments() async {
    try {
      print('🔍 Fetching overdue installments...');

      final response = await DioClient.instance.get('/api/sales/installments/overdue');

      print('✅ Overdue installments response: ${response.data}');

      if (response.data['success'] == true) {
        final installmentsData = response.data['data'] as List;
        return installmentsData
            .map((item) => Installment.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(response.data['message'] ?? 'Failed to load overdue installments');
      }
    } catch (e) {
      print('❌ Error loading overdue installments: $e');
      return [];
    }
  }

  /// Update installment status
  Future<bool> updateInstallmentStatus(int installmentId, String status) async {
    try {
      print('📝 Updating installment status: $installmentId -> $status');

      final response = await DioClient.instance.patch(
        '/api/sales/installments/$installmentId/status',
        data: {'status': status},
      );

      print('✅ Update installment status response: ${response.data}');

      return response.data['success'] == true;
    } catch (e) {
      print('❌ Error updating installment status: $e');
      return false;
    }
  }

  /// Get all installments with filters and customer data
  Future<List<Installment>> getAllInstallments({
    String? status,
    int page = 1,
    int limit = 20,
    String? search,
  }) async {
    try {
      print('🔍 Fetching all installments with customer data...');

      final Map<String, dynamic> queryParams = {
        'page': page,
        'limit': limit,
      };

      if (status != null && status.isNotEmpty && status != 'all') {
        queryParams['status'] = status;
      }
      
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      // Try the new endpoint with customer data first
      try {
        final response = await DioClient.instance.get(
          '/api/sales/installments/with-customers',
          queryParameters: queryParams,
        );

        print('✅ Installments with customer data response: ${response.data}');

        if (response.data['success'] == true) {
          final installmentsData = response.data['data']['installments'] as List;
          return installmentsData
              .map((item) => Installment.fromJson(item as Map<String, dynamic>))
              .toList();
        } else {
          throw Exception(response.data['message'] ?? 'Failed to load installments with customer data');
        }
      } catch (e) {
        print('⚠️ Customer data endpoint not available, falling back to basic endpoint: $e');
        
        // Fallback to original endpoint
        final response = await DioClient.instance.get(
          '/api/sales/installments',
          queryParameters: queryParams,
        );

        print('✅ Basic installments response: ${response.data}');

        if (response.data['success'] == true) {
          final installmentsData = response.data['data']['installments'] as List;
          return installmentsData
              .map((item) => Installment.fromJson(item as Map<String, dynamic>))
              .toList();
        } else {
          throw Exception(response.data['message'] ?? 'Failed to load installments');
        }
      }
    } catch (e) {
      print('❌ Error loading all installments: $e');
      return [];
    }
  }
  
  /// Get customer installment details
  Future<Map<String, dynamic>> getCustomerInstallments(int customerId) async {
    try {
      print('🔍 Fetching customer installments: $customerId');

      final response = await DioClient.instance.get(
        '/api/sales/customers/$customerId/installments',
      );

      print('✅ Customer installments response: ${response.data}');

      if (response.data['success'] == true) {
        return response.data['data'] as Map<String, dynamic>;
      } else {
        throw Exception(response.data['message'] ?? 'Failed to load customer installments');
      }
    } catch (e) {
      print('❌ Error loading customer installments: $e');
      return {};
    }
  }
  
  /// Update customer information
  Future<bool> updateCustomerInfo(int customerId, Map<String, dynamic> customerData) async {
    try {
      print('📝 Updating customer info: $customerId');
      print('📤 Customer data: $customerData');

      final response = await DioClient.instance.patch(
        '/api/sales/customers/$customerId',
        data: customerData,
      );

      print('✅ Update customer response: ${response.data}');

      return response.data['success'] == true;
    } catch (e) {
      print('❌ Error updating customer info: $e');
      return false;
    }
  }
  
  /// Settle customer installments
  Future<Map<String, dynamic>?> settleCustomerInstallments(
    int customerId,
    Map<String, dynamic> settlementData,
  ) async {
    try {
      print('💰 Settling customer installments: $customerId');
      print('📤 Settlement data: $settlementData');

      final response = await DioClient.instance.post(
        '/api/sales/customers/$customerId/installments/settle',
        data: settlementData,
      );

      print('✅ Settlement response: ${response.data}');

      if (response.data['success'] == true) {
        return response.data['data'] as Map<String, dynamic>;
      } else {
        throw Exception(response.data['message'] ?? 'Failed to settle installments');
      }
    } catch (e) {
      print('❌ Error settling installments: $e');
      return null;
    }
  }
  
  /// Get overdue customers summary
  Future<Map<String, dynamic>> getOverdueCustomers() async {
    try {
      print('🔍 Fetching overdue customers...');

      final response = await DioClient.instance.get('/api/sales/installments/overdue-customers');

      print('✅ Overdue customers response: ${response.data}');

      if (response.data['success'] == true) {
        return response.data['data'] as Map<String, dynamic>;
      } else {
        throw Exception(response.data['message'] ?? 'Failed to load overdue customers');
      }
    } catch (e) {
      print('❌ Error loading overdue customers: $e');
      return {
        'customers': [],
        'summary': {
          'total_overdue_customers': 0,
          'total_overdue_amount': 0.0,
          'average_overdue_days': 0,
        }
      };
    }
  }

  /// Get installment statistics for dashboard
  Future<Map<String, dynamic>> getInstallmentStats() async {
    try {
      print('📊 Fetching installment statistics...');

      final response = await DioClient.instance.get('/api/sales/installments/stats');

      print('✅ Installment stats response: ${response.data}');

      if (response.data['success'] == true) {
        return response.data['data'] as Map<String, dynamic>;
      } else {
        throw Exception(response.data['message'] ?? 'Failed to load installment stats');
      }
    } catch (e) {
      print('❌ Error loading installment stats: $e');
      return {
        'total_installments': 0,
        'pending_count': 0,
        'overdue_count': 0,
        'paid_count': 0,
        'total_pending_amount': 0.0,
        'total_overdue_amount': 0.0,
      };
    }
  }

  /// Fallback calculation for payment preview when API is unavailable
  InstallmentPreview _calculateFallbackPreview(PaymentPreviewRequest request) {
    final principal = request.principal - request.downPayment;
    const double annualInterestRate = 0.12; // 12% annual rate
    final int months = request.installmentCount;

    // Simple interest calculation
    final monthlyInterestRate = annualInterestRate / 12;
    final monthlyPayment = principal * 
        (monthlyInterestRate * math.pow(1 + monthlyInterestRate, months)) /
        (math.pow(1 + monthlyInterestRate, months) - 1);

    final totalAmount = monthlyPayment * months;
    final totalInterest = totalAmount - principal;

    // Generate schedule
    final schedule = <InstallmentSchedule>[];
    for (int i = 1; i <= months; i++) {
      final dueDate = DateTime.now().add(Duration(days: 30 * i));
      final interestPortion = principal * monthlyInterestRate;
      final principalPortion = monthlyPayment - interestPortion;

      schedule.add(InstallmentSchedule(
        installmentNumber: i,
        dueDate: dueDate,
        amount: monthlyPayment,
        principalAmount: principalPortion,
        interestAmount: interestPortion,
      ));
    }

    return InstallmentPreview(
      monthlyPayment: monthlyPayment,
      totalInterest: totalInterest,
      totalAmount: totalAmount + request.downPayment,
      installmentCount: months,
      interestRate: annualInterestRate,
      schedule: schedule,
    );
  }
}