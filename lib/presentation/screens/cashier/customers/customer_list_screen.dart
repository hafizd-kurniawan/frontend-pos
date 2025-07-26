import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class CustomerListScreen extends StatelessWidget {
  const CustomerListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(IconsaxPlusBold.arrow_left, color: AppColors.textPrimary),
        ),
        title: Text(
          'Customer Management',
          style: AppTextStyles.headlineMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppColors.customer.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                IconsaxPlusBold.people,
                size: 64,
                color: AppColors.customer,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Customer Management',
              style: AppTextStyles.headlineLarge.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.customer,
              ),
            ),
            const SizedBox(height: 16),
            Text('🚧 Coming Soon!', style: AppTextStyles.headlineMedium),
            const SizedBox(height: 8),
            Text(
              'Customer management features will be implemented next.',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
