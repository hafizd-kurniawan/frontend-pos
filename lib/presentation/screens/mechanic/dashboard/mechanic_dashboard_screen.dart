import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class MechanicDashboardScreen extends ConsumerWidget {
  const MechanicDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.mechanicPrimary,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(32.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: AppColors.mechanicPrimary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Icon(
                        IconsaxPlusLinear.setting_2,
                        color: AppColors.mechanicPrimary,
                        size: 48.sp,
                      ),
                    ),
                    Gap(24.h),
                    Text(
                      'Mechanic Dashboard',
                      style: AppTextStyles.displaySmall.copyWith(
                        color: AppColors.mechanicPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Gap(16.h),
                    Text(
                      '🔧 Coming Soon!',
                      style: AppTextStyles.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    Gap(8.h),
                    Text(
                      'Mechanic dashboard will be implemented next with vehicle maintenance, condition tracking, and work management features.',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Gap(24.h),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.mechanicPrimary,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 16.h,
                        ),
                      ),
                      icon: Icon(IconsaxPlusLinear.arrow_left, size: 18.sp),
                      label: const Text('Back to Login'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
