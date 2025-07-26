import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class QuickActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool isLoading;
  final String? badge;
  final Widget? trailing;

  const QuickActionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
    this.isLoading = false,
    this.badge,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: isLoading ? _buildLoadingState() : _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon and badge
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(icon, color: color, size: 24.sp),
                ),
                if (badge != null)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        badge!,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: Colors.white,
                          fontSize: 8.sp,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            if (trailing != null) trailing!,
          ],
        ),
        Gap(16.h),

        // Title
        Text(
          title,
          style: AppTextStyles.titleLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        Gap(4.h),

        // Subtitle
        Text(
          subtitle,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Gap(16.h),

        // Action indicator
        Row(
          children: [
            Text(
              'Get started',
              style: AppTextStyles.labelMedium.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
            Gap(4.w),
            Icon(Icons.arrow_forward_ios, color: color, size: 12.sp),
          ],
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon placeholder
        Container(
          width: 48.w,
          height: 48.h,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        Gap(16.h),

        // Title placeholder
        Container(
          width: 100.w,
          height: 18.h,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
        Gap(8.h),

        // Subtitle placeholder
        Container(
          width: 120.w,
          height: 14.h,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
        Gap(16.h),

        // Action placeholder
        Container(
          width: 80.w,
          height: 12.h,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
      ],
    );
  }
}

// Specialized action cards
class CreateSaleActionCard extends StatelessWidget {
  final VoidCallback onTap;
  final int? pendingSales;

  const CreateSaleActionCard({
    super.key,
    required this.onTap,
    this.pendingSales,
  });

  @override
  Widget build(BuildContext context) {
    return QuickActionCard(
      title: 'New Sale',
      subtitle: 'Create sales transaction',
      icon: Icons.receipt_outlined,
      color: AppColors.sales,
      onTap: onTap,
      badge: pendingSales?.toString(),
      trailing: Icon(
        Icons.add_circle_outline,
        color: AppColors.sales,
        size: 18.sp,
      ),
    );
  }
}

class AddCustomerActionCard extends StatelessWidget {
  final VoidCallback onTap;

  const AddCustomerActionCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return QuickActionCard(
      title: 'Add Customer',
      subtitle: 'Register new customer',
      icon: Icons.person_add_outlined,
      color: AppColors.customer,
      onTap: onTap,
      trailing: Icon(
        Icons.person_outline,
        color: AppColors.customer,
        size: 18.sp,
      ),
    );
  }
}

class PurchaseVehicleActionCard extends StatelessWidget {
  final VoidCallback onTap;

  const PurchaseVehicleActionCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return QuickActionCard(
      title: 'Purchase Vehicle',
      subtitle: 'Buy from customer',
      icon: Icons.shopping_cart_outlined,
      color: AppColors.purchase,
      onTap: onTap,
      trailing: Icon(
        Icons.shopping_bag_outlined,
        color: AppColors.purchase,
        size: 18.sp,
      ),
    );
  }
}

class ViewReportsActionCard extends StatelessWidget {
  final VoidCallback onTap;

  const ViewReportsActionCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return QuickActionCard(
      title: 'Daily Report',
      subtitle: 'View today\'s summary',
      icon: Icons.bar_chart_outlined,
      color: AppColors.info,
      onTap: onTap,
      trailing: Icon(
        Icons.analytics_outlined,
        color: AppColors.info,
        size: 18.sp,
      ),
    );
  }
}

// Grid layout for multiple action cards
class QuickActionGrid extends StatelessWidget {
  final List<QuickActionCard> actions;
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;

  const QuickActionGrid({
    super.key,
    required this.actions,
    this.crossAxisCount = 2,
    this.crossAxisSpacing = 16.0,
    this.mainAxisSpacing = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
        childAspectRatio: 1.2,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) => actions[index],
    );
  }
}
