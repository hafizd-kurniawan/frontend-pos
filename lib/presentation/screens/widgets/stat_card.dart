import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String? amount;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool isLoading;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.amount,
    this.onTap,
    this.trailing,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with icon and trailing
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(icon, color: color, size: 20.sp),
            ),
            if (trailing != null) trailing!,
          ],
        ),
        Gap(16.h),

        // Main value
        Text(
          value,
          style: AppTextStyles.displaySmall.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),

        // Amount if provided
        if (amount != null) ...[
          Gap(4.h),
          Text(
            amount!,
            style: AppTextStyles.labelMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],

        Gap(4.h),

        // Title and subtitle
        Text(
          title,
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          subtitle,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
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
          width: 36.w,
          height: 36.h,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        Gap(16.h),

        // Value placeholder
        Container(
          width: 80.w,
          height: 28.h,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
        Gap(8.h),

        // Title placeholder
        Container(
          width: 100.w,
          height: 16.h,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
        Gap(4.h),

        // Subtitle placeholder
        Container(
          width: 120.w,
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

// Specialized stat cards
class SalesStatCard extends StatelessWidget {
  final int salesCount;
  final double salesAmount;
  final VoidCallback? onTap;

  const SalesStatCard({
    super.key,
    required this.salesCount,
    required this.salesAmount,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return StatCard(
      title: "Today's Sales",
      value: salesCount.toString(),
      subtitle: 'Transactions completed',
      icon: Icons.receipt_outlined,
      color: AppColors.sales,
      amount: 'Rp ${_formatCurrency(salesAmount)}',
      onTap: onTap,
      trailing: Icon(Icons.trending_up, color: AppColors.sales, size: 16.sp),
    );
  }

  String _formatCurrency(double amount) {
    if (amount >= 1000000000) {
      return '${(amount / 1000000000).toStringAsFixed(1)}B';
    } else if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toStringAsFixed(0);
  }
}

class VehicleStatCard extends StatelessWidget {
  final int totalVehicles;
  final int availableVehicles;
  final VoidCallback? onTap;

  const VehicleStatCard({
    super.key,
    required this.totalVehicles,
    required this.availableVehicles,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return StatCard(
      title: "Available Vehicles",
      value: availableVehicles.toString(),
      subtitle: 'Out of $totalVehicles total',
      icon: Icons.directions_car_outlined,
      color: AppColors.primary,
      onTap: onTap,
      trailing: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: AppColors.success.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Text(
          '${((availableVehicles / totalVehicles) * 100).toInt()}%',
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.success,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class RevenueStatCard extends StatelessWidget {
  final double todayRevenue;
  final double monthlyRevenue;
  final VoidCallback? onTap;

  const RevenueStatCard({
    super.key,
    required this.todayRevenue,
    required this.monthlyRevenue,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return StatCard(
      title: "Today's Revenue",
      value: 'Rp ${_formatCurrency(todayRevenue)}',
      subtitle: 'Monthly: Rp ${_formatCurrency(monthlyRevenue)}',
      icon: Icons.attach_money_outlined,
      color: AppColors.success,
      onTap: onTap,
      trailing: Icon(Icons.show_chart, color: AppColors.success, size: 16.sp),
    );
  }

  String _formatCurrency(double amount) {
    if (amount >= 1000000000) {
      return '${(amount / 1000000000).toStringAsFixed(1)}B';
    } else if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toStringAsFixed(0);
  }
}
