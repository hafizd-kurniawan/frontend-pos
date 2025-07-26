import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/theme/app_theme.dart';
import 'presentation/screens/auth/splash_screen.dart';

class VehicleShowroomApp extends StatelessWidget {
  const VehicleShowroomApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(
        1920,
        1080,
      ), // FIXED: Normal desktop size instead of 1440x900
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Vehicle Showroom',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          home: const SplashScreen(),
        );
      },
    );
  }
}
