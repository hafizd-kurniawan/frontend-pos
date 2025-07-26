import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Simulate initialization
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120.w,
              height: 120.h,
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: Icon(
                Icons.directions_car,
                size: 64.sp,
                color: AppColors.white,
              ),
            ),
            SizedBox(height: 32.h),
            Text(
              'Vehicle Showroom',
              style: AppTextStyles.displayMedium.copyWith(
                color: AppColors.white,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Management System',
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.white.withOpacity(0.8),
              ),
            ),
            SizedBox(height: 48.h),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
            ),
          ],
        ),
      ),
    );
  }
}
