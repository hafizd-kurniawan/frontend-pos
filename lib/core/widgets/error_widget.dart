import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'custom_button.dart';

class AppErrorWidget extends StatelessWidget {
  final String title;
  final String message;
  final IconData? icon;
  final VoidCallback? onRetry;
  final String? retryText;
  final Widget? customAction;

  const AppErrorWidget({
    super.key,
    required this.title,
    required this.message,
    this.icon,
    this.onRetry,
    this.retryText,
    this.customAction,
  });

  factory AppErrorWidget.network({
    VoidCallback? onRetry,
    String? customMessage,
  }) {
    return AppErrorWidget(
      title: 'Connection Error',
      message:
          customMessage ??
          'Please check your internet connection and try again.',
      icon: Icons.wifi_off_outlined,
      onRetry: onRetry,
      retryText: 'Retry',
    );
  }

  factory AppErrorWidget.serverError({
    VoidCallback? onRetry,
    String? customMessage,
  }) {
    return AppErrorWidget(
      title: 'Server Error',
      message:
          customMessage ??
          'Something went wrong on our end. Please try again later.',
      icon: Icons.error_outline,
      onRetry: onRetry,
      retryText: 'Try Again',
    );
  }

  factory AppErrorWidget.notFound({
    String? resourceName,
    VoidCallback? onAction,
    String? actionText,
  }) {
    return AppErrorWidget(
      title: '${resourceName ?? 'Data'} Not Found',
      message:
          'The ${resourceName?.toLowerCase() ?? 'data'} you\'re looking for doesn\'t exist or has been removed.',
      icon: Icons.search_off_outlined,
      onRetry: onAction,
      retryText: actionText ?? 'Go Back',
    );
  }

  factory AppErrorWidget.unauthorized({VoidCallback? onLogin}) {
    return AppErrorWidget(
      title: 'Access Denied',
      message:
          'You don\'t have permission to access this resource. Please login again.',
      icon: Icons.lock_outline,
      onRetry: onLogin,
      retryText: 'Login',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(32.w),
        margin: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Error Icon
            if (icon != null)
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon!, size: 48.sp, color: AppColors.error),
              ),

            Gap(24.h),

            // Title
            Text(
              title,
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),

            Gap(12.h),

            // Message
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),

            Gap(32.h),

            // Actions
            if (customAction != null)
              customAction!
            else if (onRetry != null)
              CustomButton(
                onPressed: onRetry,
                text: retryText ?? 'Retry',
                variant: ButtonVariant.filled,
                backgroundColor: AppColors.primary,
                // isExpanded: false,
              ),
          ],
        ),
      ),
    );
  }
}

// Inline error widget for smaller spaces
class InlineErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final IconData? icon;

  const InlineErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.error.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            icon ?? Icons.error_outline,
            color: AppColors.error,
            size: 20.sp,
          ),
          Gap(12.w),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
            ),
          ),
          if (onRetry != null) ...[
            Gap(12.w),
            TextButton(
              onPressed: onRetry,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.error,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              ),
              child: Text(
                'Retry',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
