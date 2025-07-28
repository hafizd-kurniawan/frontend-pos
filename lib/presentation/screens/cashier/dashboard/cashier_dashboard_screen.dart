import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../data/models/user_model.dart';
import '../../../../presentation/providers/auth_provider.dart';
import '../vehicles/vehicle_list_screen.dart';
import '../sales/sales_create_screen.dart';

class CashierDashboardScreen extends ConsumerWidget {
  const CashierDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Row(
          children: [
            // Sidebar
            _buildSidebar(context, ref, currentUser),

            // Main Content
            Expanded(
              child: Column(
                children: [
                  _buildTopBar(context, currentUser),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildWelcomeSection(context, currentUser),
                          const SizedBox(height: 40),
                          _buildQuickStats(context),
                          const SizedBox(height: 40),
                          _buildQuickActions(context),
                          const SizedBox(height: 40),
                          _buildTodayActivity(context),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToSales(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SalesCreateScreen()),
    );
  }

  // Update the Quick Action Card for New Sale:
  // Expanded(
  //   child: _buildQuickActionCard(
  //     title: 'New Sale',
  //     subtitle: 'Create transaction',
  //     icon: IconsaxPlusBold.add_circle,
  //     color: AppColors.success,
  //     onTap: _navigateToNewSale, // ✅ Use method instead of inline
  //   ),
  // )

  void _navigateToCustomers(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _buildPlaceholderScreen(
          'Customer Management',
          IconsaxPlusBold.people,
          AppColors.customer,
          'Manage customer information and history',
        ),
      ),
    );
  }

  Widget _buildPlaceholderScreen(
    String title,
    IconData icon,
    Color color,
    String subtitle,
  ) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              IconsaxPlusBold.arrow_left,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        title: Text(
          title,
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
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 64, color: color),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: AppTextStyles.headlineLarge.copyWith(
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            const SizedBox(height: 16),
            Text('🚧 Coming Soon!', style: AppTextStyles.headlineMedium),
            const SizedBox(height: 8),
            Text(
              subtitle,
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

  Widget _buildSidebar(BuildContext context, WidgetRef ref, User? currentUser) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: AppColors.cashierPrimary,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    IconsaxPlusBold.car,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Vehicle Showroom',
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Cashier Dashboard',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Navigation Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildNavItem(
                  icon: IconsaxPlusBold.grid_1,
                  title: 'Dashboard',
                  isActive: true,
                  onTap: () {},
                ),
                _buildNavItem(
                  icon: IconsaxPlusBold.car,
                  title: 'Vehicles',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const VehicleListScreen(),
                    ),
                  ),
                ),
                _buildNavItem(
                  icon: IconsaxPlusBold.people,
                  title: 'Customers',
                  onTap: () => _navigateToCustomers(context),
                ),
                _buildNavItem(
                  icon: IconsaxPlusBold.receipt_item,
                  title: 'Sales',
                  onTap: () => _navigateToSales(context),
                ),
                _buildNavItem(
                  icon: IconsaxPlusBold.shopping_cart,
                  title: 'Purchase',
                  onTap: () => _showComingSoon(context, 'Purchase Management'),
                ),
                _buildNavItem(
                  icon: IconsaxPlusBold.chart,
                  title: 'Reports',
                  onTap: () => _showComingSoon(context, 'Reports & Analytics'),
                ),
              ],
            ),
          ),

          // User Profile & Logout
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        child: Icon(
                          IconsaxPlusBold.user,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentUser?.name ?? 'Unknown User',
                              style: AppTextStyles.titleMedium.copyWith(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Cashier',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: () => _showLogoutDialog(context, ref),
                  icon: Icon(
                    IconsaxPlusBold.logout,
                    color: Colors.white.withOpacity(0.8),
                    size: 20,
                  ),
                  label: Text(
                    'Logout',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 16,
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

  Widget _buildNavItem({
    required IconData icon,
    required String title,
    bool isActive = false,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? Colors.white : Colors.white.withOpacity(0.7),
          size: 24,
        ),
        title: Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isActive ? Colors.white : Colors.white.withOpacity(0.7),
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            fontSize: 16,
          ),
        ),
        selected: isActive,
        selectedTileColor: Colors.white.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onTap: onTap,
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, User? currentUser) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good ${_getTimeOfDay()}, ${currentUser?.name ?? 'User'}! 👋',
                  style: AppTextStyles.headlineMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 28,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  DateFormat('EEEE, MMMM d, y').format(DateTime.now()),
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),

          // Time & Status
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.success.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Online • ${DateFormat('HH:mm').format(DateTime.now())}',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context, User? currentUser) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.cashierPrimary, Color(0xFF1D4ED8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.cashierPrimary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🚗 Ready to make some sales today?',
                  style: AppTextStyles.displaySmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 32,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Your dashboard is loaded with all the tools you need to manage vehicles, customers, and transactions efficiently.',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: Colors.white.withOpacity(0.9),
                    height: 1.5,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _navigateToSales(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.cashierPrimary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      icon: Icon(IconsaxPlusBold.add_circle, size: 24),
                      label: Text(
                        'Create New Sale',
                        style: AppTextStyles.buttonMedium.copyWith(
                          color: AppColors.cashierPrimary,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    OutlinedButton.icon(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const VehicleListScreen(),
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white, width: 2),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      icon: Icon(IconsaxPlusBold.car, size: 24),
                      label: Text(
                        'View Vehicles',
                        style: AppTextStyles.buttonMedium.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 40),
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 2,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  IconsaxPlusBold.receipt_item,
                  color: Colors.white,
                  size: 56,
                ),
                const SizedBox(height: 12),
                Text(
                  'Cashier',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                Text(
                  'System',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '📊 Today\'s Performance',
          style: AppTextStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 24,
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: "Today's Sales",
                value: '5',
                subtitle: 'Transactions completed',
                icon: IconsaxPlusBold.receipt_item,
                color: AppColors.sales,
                amount: 'Rp 750M',
                onTap: () => _navigateToSales(context),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _buildStatCard(
                title: "Vehicle Purchases",
                value: '2',
                subtitle: 'Vehicles acquired',
                icon: IconsaxPlusBold.shopping_cart,
                color: AppColors.purchase,
                amount: 'Rp 300M',
                onTap: () => _showComingSoon(context, 'Purchase Management'),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _buildStatCard(
                title: 'Revenue Today',
                value: 'Rp 750M',
                subtitle: 'Net earnings',
                icon: IconsaxPlusBold.dollar_circle,
                color: AppColors.success,
                onTap: () => _showComingSoon(context, 'Revenue Details'),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _buildStatCard(
                title: 'Active Session',
                value: DateFormat('HH:mm').format(DateTime.now()),
                subtitle: 'Since login today',
                icon: IconsaxPlusBold.clock,
                color: AppColors.info,
                amount: '8h 30m',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    String? amount,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: color, size: 24),
                  ),
                  if (onTap != null)
                    Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.textTertiary,
                      size: 16,
                    ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                value,
                style: AppTextStyles.displaySmall.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  fontSize: 32,
                ),
              ),
              if (amount != null) ...[
                const SizedBox(height: 8),
                Text(
                  amount,
                  style: AppTextStyles.labelMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: color,
                    fontSize: 14,
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Text(
                title,
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  fontSize: 18,
                ),
              ),
              Text(
                subtitle,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '⚡ Quick Actions',
          style: AppTextStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 24,
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                title: 'New Sale',
                subtitle: 'Create sales transaction',
                icon: IconsaxPlusBold.receipt_item,
                color: AppColors.sales,
                onTap: () => _navigateToSales(context),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _buildActionCard(
                title: 'Add Customer',
                subtitle: 'Register new customer',
                icon: IconsaxPlusBold.user_add,
                color: AppColors.customer,
                onTap: () => _navigateToCustomers(context),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _buildActionCard(
                title: 'Browse Vehicles',
                subtitle: 'View available vehicles',
                icon: IconsaxPlusBold.car,
                color: AppColors.primary,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VehicleListScreen(),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _buildActionCard(
                title: 'Purchase Vehicle',
                subtitle: 'Buy from customer',
                icon: IconsaxPlusBold.shopping_cart,
                color: AppColors.purchase,
                onTap: () => _showComingSoon(context, 'Purchase Vehicle'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: AppTextStyles.titleLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    'Get started',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(IconsaxPlusBold.arrow_right, color: color, size: 16),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTodayActivity(BuildContext context) {
    final mockTransactions = [
      {
        'type': 'sale',
        'time': '10:30',
        'customer': 'John Doe',
        'vehicle': 'Toyota Avanza 2023',
        'amount': 250000000,
        'status': 'completed',
      },
      {
        'type': 'purchase',
        'time': '14:15',
        'customer': 'Jane Smith',
        'vehicle': 'Honda Civic 2022',
        'amount': 180000000,
        'status': 'completed',
      },
      {
        'type': 'sale',
        'time': '16:45',
        'customer': 'Mike Johnson',
        'vehicle': 'Suzuki Ertiga 2023',
        'amount': 220000000,
        'status': 'pending',
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '📈 Today\'s Activity',
                      style: AppTextStyles.headlineSmall.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${mockTransactions.length} transactions today',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: () =>
                      _showComingSoon(context, 'Transaction History'),
                  icon: Icon(IconsaxPlusBold.arrow_right, size: 20),
                  label: Text('View All', style: TextStyle(fontSize: 16)),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),

          Divider(color: AppColors.divider, height: 1),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: mockTransactions.length,
            separatorBuilder: (context, index) => Divider(
              color: AppColors.divider.withOpacity(0.5),
              height: 1,
              indent: 32,
              endIndent: 32,
            ),
            itemBuilder: (context, index) {
              final transaction = mockTransactions[index];
              return _buildActivityItem(transaction);
            },
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> transaction) {
    final isSale = transaction['type'] == 'sale';
    final isCompleted = transaction['status'] == 'completed';

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      leading: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: (isSale ? AppColors.sales : AppColors.purchase).withOpacity(
            0.1,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          isSale ? IconsaxPlusBold.receipt_item : IconsaxPlusBold.shopping_cart,
          color: isSale ? AppColors.sales : AppColors.purchase,
          size: 24,
        ),
      ),
      title: Text(
        '${isSale ? 'Sale' : 'Purchase'} - ${transaction['customer']}',
        style: AppTextStyles.titleMedium.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            transaction['vehicle'],
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                IconsaxPlusBold.clock,
                size: 16,
                color: AppColors.textTertiary,
              ),
              const SizedBox(width: 8),
              Text(
                transaction['time'],
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textTertiary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isCompleted
                      ? AppColors.success.withOpacity(0.1)
                      : AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  transaction['status'],
                  style: AppTextStyles.labelSmall.copyWith(
                    color: isCompleted ? AppColors.success : AppColors.warning,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'Rp ${_formatCurrency(transaction['amount'].toDouble())}',
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: isSale ? AppColors.sales : AppColors.purchase,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isSale ? '+' : '-',
            style: AppTextStyles.bodySmall.copyWith(
              color: isSale ? AppColors.sales : AppColors.purchase,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(IconsaxPlusBold.info_circle, color: Colors.white, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                '$feature will be implemented next!',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.info,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
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
            child: const Text('Logout'),
          ),
        ],
      ),
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

  String _getTimeOfDay() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Morning';
    if (hour < 17) return 'Afternoon';
    return 'Evening';
  }
}

// Import the login screen
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Login Screen', style: AppTextStyles.headlineLarge),
      ),
    );
  }
}
