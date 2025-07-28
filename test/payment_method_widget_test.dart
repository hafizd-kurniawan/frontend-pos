import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vehicle_showroom_flutter/data/models/payment_method_model.dart';
import 'package:vehicle_showroom_flutter/presentation/widgets/installment/payment_method_card.dart';

void main() {
  group('Payment Method Card Widget Tests', () {
    testWidgets('should display payment method information', (WidgetTester tester) async {
      final paymentMethod = PaymentMethod(
        id: 'cash',
        name: 'Cash Payment',
        description: 'Direct cash payment',
        icon: Icons.money,
        supportsInstallments: false,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PaymentMethodCard(
              paymentMethod: paymentMethod,
              isSelected: false,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Cash Payment'), findsOneWidget);
      expect(find.text('Direct cash payment'), findsOneWidget);
    });

    testWidgets('should show installment indicator for installment-supported methods', (WidgetTester tester) async {
      final paymentMethod = PaymentMethod(
        id: 'credit',
        name: 'Credit/Financing',
        description: 'Installment payment plan',
        icon: Icons.credit_card,
        supportsInstallments: true,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PaymentMethodCard(
              paymentMethod: paymentMethod,
              isSelected: false,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Credit/Financing'), findsOneWidget);
      expect(find.text('Installments'), findsOneWidget);
    });

    testWidgets('should handle tap events', (WidgetTester tester) async {
      bool tapped = false;
      final paymentMethod = PaymentMethod(
        id: 'cash',
        name: 'Cash Payment',
        description: 'Direct cash payment',
        icon: Icons.money,
        supportsInstallments: false,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PaymentMethodCard(
              paymentMethod: paymentMethod,
              isSelected: false,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(PaymentMethodCard));
      expect(tapped, true);
    });
  });

  group('Payment Method Grid Widget Tests', () {
    testWidgets('should display multiple payment methods', (WidgetTester tester) async {
      final paymentMethods = PaymentMethod.defaultPaymentMethods;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PaymentMethodGrid(
              paymentMethods: paymentMethods,
              onPaymentMethodSelected: (method) {},
            ),
          ),
        ),
      );

      expect(find.text('Cash Payment'), findsOneWidget);
      expect(find.text('Bank Transfer'), findsOneWidget);
      expect(find.text('Check Payment'), findsOneWidget);
      expect(find.text('Credit/Financing'), findsOneWidget);
    });

    testWidgets('should call selection callback when method is tapped', (WidgetTester tester) async {
      PaymentMethod? selectedMethod;
      final paymentMethods = PaymentMethod.defaultPaymentMethods;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PaymentMethodGrid(
              paymentMethods: paymentMethods,
              onPaymentMethodSelected: (method) => selectedMethod = method,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Cash Payment'));
      
      expect(selectedMethod, isNotNull);
      expect(selectedMethod!.id, 'cash');
    });
  });
}