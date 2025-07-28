import 'package:flutter_test/flutter_test.dart';
import 'package:vehicle_showroom_flutter/data/models/payment_method_model.dart';
import 'package:vehicle_showroom_flutter/data/models/installment_model.dart';

void main() {
  group('Payment Method Model Tests', () {
    test('should create payment method from JSON', () {
      final json = {
        'id': 'credit',
        'name': 'Credit Card',
        'description': 'Pay with credit card',
        'icon': 'credit',
        'supports_installments': true,
        'is_active': true,
        'color': '#9C27B0',
      };

      final paymentMethod = PaymentMethod.fromJson(json);

      expect(paymentMethod.id, 'credit');
      expect(paymentMethod.name, 'Credit Card');
      expect(paymentMethod.supportsInstallments, true);
      expect(paymentMethod.isActive, true);
    });

    test('should return default payment methods', () {
      final defaultMethods = PaymentMethod.defaultPaymentMethods;

      expect(defaultMethods.length, 4);
      expect(defaultMethods[0].id, 'cash');
      expect(defaultMethods[3].supportsInstallments, true);
    });
  });

  group('Installment Model Tests', () {
    test('should create installment from JSON', () {
      final json = {
        'id': 1,
        'transaction_id': 100,
        'installment_number': 1,
        'due_date': '2024-02-01T00:00:00Z',
        'amount': 1000000.0,
        'paid_amount': 0.0,
        'status': 'pending',
        'principal_amount': 900000.0,
        'interest_amount': 100000.0,
        'created_at': '2024-01-01T00:00:00Z',
        'updated_at': '2024-01-01T00:00:00Z',
      };

      final installment = Installment.fromJson(json);

      expect(installment.id, 1);
      expect(installment.transactionId, 100);
      expect(installment.installmentNumber, 1);
      expect(installment.amount, 1000000.0);
      expect(installment.status, 'pending');
      expect(installment.remainingAmount, 1000000.0);
    });

    test('should calculate remaining amount correctly', () {
      final installment = Installment(
        id: 1,
        transactionId: 100,
        installmentNumber: 1,
        dueDate: DateTime.now().add(Duration(days: 30)),
        amount: 1000000.0,
        paidAmount: 300000.0,
        status: 'partially_paid',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(installment.remainingAmount, 700000.0);
      expect(installment.isPartiallyPaid, true);
      expect(installment.isPaid, false);
    });

    test('should detect overdue installments', () {
      final overdueInstallment = Installment(
        id: 1,
        transactionId: 100,
        installmentNumber: 1,
        dueDate: DateTime.now().subtract(Duration(days: 5)),
        amount: 1000000.0,
        status: 'pending',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(overdueInstallment.isOverdue, true);
      expect(overdueInstallment.statusDisplayName, 'Overdue');
    });
  });

  group('Installment Preview Tests', () {
    test('should create installment preview from JSON', () {
      final json = {
        'monthly_payment': 500000.0,
        'total_interest': 200000.0,
        'total_amount': 1200000.0,
        'installment_count': 12,
        'interest_rate': 0.12,
        'schedule': [],
      };

      final preview = InstallmentPreview.fromJson(json);

      expect(preview.monthlyPayment, 500000.0);
      expect(preview.totalInterest, 200000.0);
      expect(preview.installmentCount, 12);
      expect(preview.interestRate, 0.12);
    });
  });

  group('Request Models Tests', () {
    test('should create payment preview request', () {
      final request = PaymentPreviewRequest(
        principal: 10000000.0,
        installmentCount: 24,
        downPayment: 2000000.0,
        paymentMethodId: 'credit',
      );

      final json = request.toJson();

      expect(json['principal'], 10000000.0);
      expect(json['installment_count'], 24);
      expect(json['down_payment'], 2000000.0);
      expect(json['payment_method_id'], 'credit');
    });

    test('should create pay installment request', () {
      final request = PayInstallmentRequest(
        amount: 500000.0,
        paymentMethod: 'cash',
        paymentReference: 'REF123',
        notes: 'Monthly payment',
      );

      final json = request.toJson();

      expect(json['amount'], 500000.0);
      expect(json['payment_method'], 'cash');
      expect(json['payment_reference'], 'REF123');
      expect(json['notes'], 'Monthly payment');
    });
  });
}