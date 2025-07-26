import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../providers/auth_provider.dart';
import '../../screens/auth/login_screen.dart';

class NavigationSidebar extends ConsumerWidget {
  final String currentRoute;
  final List<NavigationItem> items;
  final Color primaryColor;
  final String roleTitle;

  const NavigationSidebar({
    super.key,
    required this.currentRoute,
    required this.items,
    required this.primaryColor,
    required this.roleTitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

    return Container(
      width: 280.w,
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24.r),
          bottomRight: Radius.circular(24.r),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(24.w),
            child: Column(
              children: [
                Container(
                  width: 64.w,
                  height: 64.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Icon(
                    IconsaxPlusLinear.car,
                    color: Colors.white,
                    size: 32.sp,
                  ),
                ),
                Gap(16.h),
                Text(
                  'Vehicle Showroom',
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  roleTitle,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Navigation Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              children: items
                  .map(
                    (item) => _buildNavItem(
                      context,
                      item,
                      currentRoute == item.route,
                    ),
                  )
                  .toList(),
            ),
          ),

          // User Profile & Logout
          Container(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20.r,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        child: Icon(
                          IconsaxPlusLinear.user,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                      ),
                      Gap(12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentUser?.name ?? 'Unknown User',
                              style: AppTextStyles.titleMedium.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              currentUser?.role.toUpperCase() ?? '',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(12.h),
                TextButton.icon(
                  onPressed: () => _showLogoutDialog(context, ref),
                  icon: Icon(
                    IconsaxPlusLinear.logout,
                    color: Colors.white.withOpacity(0.8),
                    size: 18.sp,
                  ),
                  label: Text(
                    'Logout',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    NavigationItem item,
    bool isActive,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      child: ListTile(
        leading: Icon(
          item.icon,
          color: isActive ? Colors.white : Colors.white.withOpacity(0.7),
          size: 20.sp,
        ),
        title: Text(
          item.title,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isActive ? Colors.white : Colors.white.withOpacity(0.7),
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        selected: isActive,
        selectedTileColor: Colors.white.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        onTap: () => item.onTap(context),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }
}

class NavigationItem {
  final String title;
  final IconData icon;
  final String route;
  final void Function(BuildContext) onTap;

  const NavigationItem({
    required this.title,
    required this.icon,
    required this.route,
    required this.onTap,
  });
}
