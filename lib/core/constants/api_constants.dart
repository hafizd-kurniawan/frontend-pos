class ApiConstants {
  ApiConstants._();

  // Base URLs
  static const String baseUrl = 'http://localhost:8080';
  static const String apiVersion = '/api';
  static const String fullBaseUrl = '$baseUrl$apiVersion';

  // Auth Endpoints
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String currentUser = '/auth/me';

  // Dashboard Endpoints
  static const String dashboardStats = '/statistics/dashboard';
  static const String vehicleStats = '/statistics/vehicles';
  static const String customerStats = '/statistics/customers';

  // Vehicle Endpoints
  static const String vehicles = '/vehicles';
  static const String vehicleSearch = '/vehicles/search';
  static const String vehicleById = '/vehicles/{id}';
  static const String updateVehicleStatus = '/vehicles/{id}/status';
  static const String updateVehicleCondition = '/vehicles/{id}/condition';

  // Customer Endpoints
  static const String customers = '/customers';
  static const String customerSearch = '/customers/search';
  static const String customerById = '/customers/{id}';

  // Transaction Endpoints
  static const String salesTransactions = '/sales/transactions';
  static const String salesTransactionById = '/sales/transactions/{id}';
  static const String generateReceipt = '/sales/transactions/{id}/receipt';
  static const String purchaseTransactions = '/purchase/transactions';
  static const String purchaseTransactionById = '/purchase/transactions/{id}';

  // Cashier Endpoints
  static const String cashierDashboard = '/cashier/dashboard';
  static const String cashierDailyReport = '/cashier/reports/daily/{date}';
  static const String cashierPerformance = '/cashier/reports/performance';
  static const String cashierSummary = '/cashier/reports/summary';
  static const String todayTransactions = '/cashier/transactions/today';

  // Mechanic Endpoints
  static const String mechanicDashboard = '/mechanic/dashboard';
  static const String maintenanceVehicles = '/mechanic/vehicles/maintenance';
  static const String mechanicWorkSummary = '/mechanic/work-summary';

  // Photo Endpoints
  static const String vehiclePhotos = '/photos/vehicles/{vehicleId}';
  static const String uploadPhoto = '/photos/vehicles/{vehicleId}';
  static const String deletePhoto = '/photos/{photoId}';

  // Categories
  static const String categories = '/categories';

  // Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
}
