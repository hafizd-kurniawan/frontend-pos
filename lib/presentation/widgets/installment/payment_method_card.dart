import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/payment_method_model.dart';

class PaymentMethodCard extends StatelessWidget {
  final PaymentMethod paymentMethod;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isTablet;

  const PaymentMethodCard({
    super.key,
    required this.paymentMethod,
    required this.isSelected,
    required this.onTap,
    this.isTablet = false,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = _getCardColor();
    
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(isTablet ? 16 : 12),
        decoration: BoxDecoration(
          color: isSelected ? cardColor.withOpacity(0.1) : Colors.white,
          border: Border.all(
            color: isSelected ? cardColor : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            if (isSelected) ...[
              BoxShadow(
                color: cardColor.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ] else ...[
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              padding: EdgeInsets.all(isTablet ? 12 : 8),
              decoration: BoxDecoration(
                color: cardColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                paymentMethod.icon,
                color: cardColor,
                size: isTablet ? 28 : 24,
              ),
            ),
            
            SizedBox(height: isTablet ? 12 : 8),
            
            // Name
            Text(
              paymentMethod.name,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: isTablet ? 16 : 14,
                color: isSelected ? cardColor : AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            
            SizedBox(height: 4),
            
            // Description
            Text(
              paymentMethod.description,
              style: TextStyle(
                fontSize: isTablet ? 12 : 10,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            
            // Installment support indicator
            if (paymentMethod.supportsInstallments) ...[
              SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Installments',
                  style: TextStyle(
                    fontSize: isTablet ? 10 : 8,
                    color: AppColors.success,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getCardColor() {
    if (paymentMethod.color != null) {
      try {
        return Color(int.parse(paymentMethod.color!.replaceAll('#', '0xFF')));
      } catch (e) {
        // Fallback to predefined colors
      }
    }
    
    // Fallback colors based on payment method ID
    switch (paymentMethod.id) {
      case 'cash':
        return Colors.green;
      case 'transfer':
        return Colors.blue;
      case 'check':
        return Colors.orange;
      case 'credit':
        return Colors.purple;
      default:
        return AppColors.primary;
    }
  }
}

class PaymentMethodGrid extends StatelessWidget {
  final List<PaymentMethod> paymentMethods;
  final String? selectedPaymentMethodId;
  final Function(PaymentMethod) onPaymentMethodSelected;
  final bool isTablet;

  const PaymentMethodGrid({
    super.key,
    required this.paymentMethods,
    this.selectedPaymentMethodId,
    required this.onPaymentMethodSelected,
    this.isTablet = false,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isTablet ? 4 : 2,
        childAspectRatio: isTablet ? 1.2 : 1.1,
        crossAxisSpacing: isTablet ? 16 : 12,
        mainAxisSpacing: isTablet ? 16 : 12,
      ),
      itemCount: paymentMethods.length,
      itemBuilder: (context, index) {
        final paymentMethod = paymentMethods[index];
        final isSelected = selectedPaymentMethodId == paymentMethod.id;
        
        return PaymentMethodCard(
          paymentMethod: paymentMethod,
          isSelected: isSelected,
          onTap: () => onPaymentMethodSelected(paymentMethod),
          isTablet: isTablet,
        );
      },
    );
  }
}

class PaymentMethodSelector extends StatelessWidget {
  final List<PaymentMethod> paymentMethods;
  final String? selectedPaymentMethodId;
  final Function(PaymentMethod) onPaymentMethodSelected;
  final bool isTablet;
  final String title;

  const PaymentMethodSelector({
    super.key,
    required this.paymentMethods,
    this.selectedPaymentMethodId,
    required this.onPaymentMethodSelected,
    this.isTablet = false,
    this.title = 'Payment Method',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isTablet ? 18 : 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: isTablet ? 16 : 12),
        PaymentMethodGrid(
          paymentMethods: paymentMethods,
          selectedPaymentMethodId: selectedPaymentMethodId,
          onPaymentMethodSelected: onPaymentMethodSelected,
          isTablet: isTablet,
        ),
      ],
    );
  }
}