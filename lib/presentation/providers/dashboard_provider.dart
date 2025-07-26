import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/dashboard_service.dart';

// Dashboard Providers
final dashboardServiceProvider = Provider<DashboardService>((ref) {
  return DashboardService();
});

final cashierDashboardProvider = FutureProvider<Map<String, dynamic>>((
  ref,
) async {
  final dashboardService = ref.read(dashboardServiceProvider);
  return await dashboardService.getCashierDashboard();
});

final mechanicDashboardProvider = FutureProvider<Map<String, dynamic>>((
  ref,
) async {
  final dashboardService = ref.read(dashboardServiceProvider);
  return await dashboardService.getMechanicDashboard();
});

final todayStatsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final dashboardService = ref.read(dashboardServiceProvider);
  return await dashboardService.getTodayTransactions();
});

final dashboardStatsProvider = FutureProvider<Map<String, dynamic>>((
  ref,
) async {
  final dashboardService = ref.read(dashboardServiceProvider);
  return await dashboardService.getDashboardStats();
});
