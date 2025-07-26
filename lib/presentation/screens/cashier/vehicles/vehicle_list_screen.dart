import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../data/models/vehicle_model.dart';
import '../../../../presentation/providers/vehicle_provider.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import 'vehicle_detail_screen.dart';
import 'vehicle_form_screen.dart';

class VehicleListScreen extends ConsumerStatefulWidget {
  const VehicleListScreen({super.key});

  @override
  ConsumerState<VehicleListScreen> createState() => _VehicleListScreenState();
}

class _VehicleListScreenState extends ConsumerState<VehicleListScreen> {
  final _searchController = TextEditingController();
  String _selectedCondition = 'all';
  String _selectedStatus = 'all';
  String _sortBy = 'created_at';
  String _sortOrder = 'desc';

  @override
  void initState() {
    super.initState();
    // Load vehicles when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(vehicleListProvider.notifier).loadVehicles();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    ref
        .read(vehicleListProvider.notifier)
        .searchVehicles(
          query: _searchController.text,
          condition: _selectedCondition == 'all' ? null : _selectedCondition,
          status: _selectedStatus == 'all' ? null : _selectedStatus,
          sortBy: _sortBy,
          sortOrder: _sortOrder,
        );
  }

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _selectedCondition = 'all';
      _selectedStatus = 'all';
      _sortBy = 'created_at';
      _sortOrder = 'desc';
    });
    ref.read(vehicleListProvider.notifier).loadVehicles();
  }

  @override
  Widget build(BuildContext context) {
    final vehicleState = ref.watch(vehicleListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildHeader(),
          _buildToolbar(),
          Expanded(child: _buildVehicleArchive(vehicleState)),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(32),
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
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              IconsaxPlusBold.arrow_left,
              color: AppColors.textPrimary,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🚗 Vehicle Archive',
                  style: AppTextStyles.displaySmall.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 32,
                  ),
                ),
                Text(
                  'Manage your vehicle inventory',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          // Stats Summary
          Consumer(
            builder: (context, ref, child) {
              final vehicleState = ref.watch(vehicleListProvider);
              return vehicleState.when(
                data: (vehicles) => _buildQuickStats(vehicles),
                loading: () => const CircularProgressIndicator(),
                error: (_, __) => const Icon(Icons.error),
              );
            },
          ),
          const SizedBox(width: 32),
          // Add Vehicle Button
          ElevatedButton.icon(
            onPressed: () => _navigateToAddVehicle(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            icon: Icon(IconsaxPlusBold.add, size: 24),
            label: Text(
              'Add Vehicle',
              style: AppTextStyles.buttonMedium.copyWith(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(List<Vehicle> vehicles) {
    final available = vehicles
        .where((v) => v.availabilityStatus == 'available')
        .length;
    final sold = vehicles.where((v) => v.availabilityStatus == 'sold').length;
    final maintenance = vehicles
        .where((v) => v.availabilityStatus == 'maintenance')
        .length;

    return Row(
      children: [
        _buildStatChip('Total', vehicles.length.toString(), AppColors.primary),
        const SizedBox(width: 12),
        _buildStatChip('Available', available.toString(), AppColors.success),
        const SizedBox(width: 12),
        _buildStatChip('Sold', sold.toString(), AppColors.sales),
        const SizedBox(width: 12),
        _buildStatChip(
          'Maintenance',
          maintenance.toString(),
          AppColors.warning,
        ),
      ],
    );
  }

  Widget _buildStatChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.titleLarge.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(color: color, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Row(
        children: [
          // Search
          Expanded(
            flex: 3,
            child: SizedBox(
              height: 56,
              child: CustomTextField(
                controller: _searchController,
                hint: 'Search by brand, model, year, or code...',
                prefixIcon: IconsaxPlusBold.search_normal,
                onChanged: (value) {
                  if (value.isEmpty) {
                    ref.read(vehicleListProvider.notifier).loadVehicles();
                  }
                },
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Filters
          Expanded(
            child: _buildDropdownFilter(
              'Condition',
              _selectedCondition,
              [
                {'value': 'all', 'label': 'All Conditions'},
                {'value': 'excellent', 'label': 'Excellent'},
                {'value': 'good', 'label': 'Good'},
                {'value': 'fair', 'label': 'Fair'},
                {'value': 'poor', 'label': 'Poor'},
              ],
              (value) => setState(() => _selectedCondition = value!),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: _buildDropdownFilter(
              'Status',
              _selectedStatus,
              [
                {'value': 'all', 'label': 'All Status'},
                {'value': 'available', 'label': 'Available'},
                {'value': 'sold', 'label': 'Sold'},
                {'value': 'maintenance', 'label': 'Maintenance'},
              ],
              (value) => setState(() => _selectedStatus = value!),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: _buildDropdownFilter('Sort', _sortBy, [
              {'value': 'created_at', 'label': 'Date Added'},
              {'value': 'selling_price', 'label': 'Price'},
              {'value': 'year', 'label': 'Year'},
              {'value': 'brand', 'label': 'Brand'},
            ], (value) => setState(() => _sortBy = value!)),
          ),

          const SizedBox(width: 16),

          // Action Buttons
          SizedBox(
            height: 56,
            child: ElevatedButton.icon(
              onPressed: _performSearch,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: Icon(IconsaxPlusBold.search_normal, size: 20),
              label: Text('Search'),
            ),
          ),

          const SizedBox(width: 12),

          SizedBox(
            height: 56,
            child: OutlinedButton.icon(
              onPressed: _resetFilters,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                side: BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: Icon(IconsaxPlusBold.refresh, size: 20),
              label: Text('Reset'),
            ),
          ),

          const SizedBox(width: 12),

          // Refresh Button
          SizedBox(
            height: 56,
            width: 56,
            child: IconButton(
              onPressed: () =>
                  ref.read(vehicleListProvider.notifier).loadVehicles(),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.info.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: Icon(
                IconsaxPlusBold.refresh,
                color: AppColors.info,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownFilter(
    String label,
    String value,
    List<Map<String, String>> options,
    void Function(String?) onChanged,
  ) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
          onChanged: onChanged,
          style: AppTextStyles.bodyMedium.copyWith(fontSize: 16),
          items: options.map((option) {
            return DropdownMenuItem<String>(
              value: option['value'],
              child: Text(
                option['label']!,
                style: AppTextStyles.bodyMedium.copyWith(fontSize: 16),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildVehicleArchive(AsyncValue<List<Vehicle>> vehicleState) {
    return vehicleState.when(
      data: (vehicles) {
        if (vehicles.isEmpty) {
          return _buildEmptyState();
        }

        return Padding(
          padding: const EdgeInsets.all(24),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, // 4 columns for archive layout
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
              childAspectRatio: 0.75, // Card height vs width ratio
            ),
            itemCount: vehicles.length,
            itemBuilder: (context, index) {
              final vehicle = vehicles[index];
              return _buildVehicleArchiveCard(vehicle);
            },
          ),
        );
      },
      loading: () => _buildLoadingGrid(),
      error: (error, stack) => _buildErrorState(error.toString()),
    );
  }

  Widget _buildVehicleArchiveCard(Vehicle vehicle) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _navigateToVehicleDetail(vehicle),
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Vehicle Image & Quick Actions
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          IconsaxPlusBold.car,
                          color: AppColors.primary,
                          size: 48,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            vehicle.category?.name ?? 'Vehicle',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Status Badge
                  Positioned(
                    top: 12,
                    left: 12,
                    child: _buildStatusBadge(vehicle.availabilityStatus),
                  ),

                  // Quick Actions
                  Positioned(
                    top: 8,
                    right: 8,
                    child: PopupMenuButton<String>(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          IconsaxPlusBold.more,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      onSelected: (value) => _handleQuickAction(value, vehicle),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'view',
                          child: Row(
                            children: [
                              Icon(
                                IconsaxPlusBold.eye,
                                size: 16,
                                color: AppColors.info,
                              ),
                              const SizedBox(width: 12),
                              Text('View Details'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(
                                IconsaxPlusBold.edit,
                                size: 16,
                                color: AppColors.warning,
                              ),
                              const SizedBox(width: 12),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        if (vehicle.availabilityStatus == 'available')
                          PopupMenuItem(
                            value: 'sell',
                            child: Row(
                              children: [
                                Icon(
                                  IconsaxPlusBold.money_send,
                                  size: 16,
                                  color: AppColors.sales,
                                ),
                                const SizedBox(width: 12),
                                Text('Mark as Sold'),
                              ],
                            ),
                          ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(
                                IconsaxPlusBold.trash,
                                size: 16,
                                color: AppColors.error,
                              ),
                              const SizedBox(width: 12),
                              Text('Delete'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Vehicle Information
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Brand & Model
                    Text(
                      '${vehicle.brand} ${vehicle.model}',
                      style: AppTextStyles.titleLarge.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),

                    // Year & Color
                    Row(
                      children: [
                        Icon(
                          IconsaxPlusBold.calendar,
                          size: 14,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${vehicle.year}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: _getColorFromName(vehicle.color),
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.border),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          vehicle.color,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Condition & Mileage
                    Row(
                      children: [
                        _buildConditionDot(vehicle.conditionStatus),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${vehicle.mileage.toStringAsFixed(0)} km',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    // Price
                    Text(
                      'Rp ${NumberFormat('#,###').format(vehicle.sellingPrice)}',
                      style: AppTextStyles.titleLarge.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.success,
                        fontSize: 16,
                      ),
                    ),

                    // Vehicle Code
                    Text(
                      vehicle.vehicleCode,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textTertiary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String label;

    switch (status.toLowerCase()) {
      case 'available':
        color = AppColors.success;
        label = 'Available';
        break;
      case 'sold':
        color = AppColors.sales;
        label = 'Sold';
        break;
      case 'maintenance':
        color = AppColors.warning;
        label = 'Maintenance';
        break;
      default:
        color = AppColors.textTertiary;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSmall.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildConditionDot(String condition) {
    Color color;
    switch (condition.toLowerCase()) {
      case 'excellent':
        color = AppColors.success;
        break;
      case 'good':
        color = AppColors.info;
        break;
      case 'fair':
        color = AppColors.warning;
        break;
      case 'poor':
        color = AppColors.error;
        break;
      default:
        color = AppColors.textTertiary;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          condition[0].toUpperCase() + condition.substring(1),
          style: AppTextStyles.bodySmall.copyWith(
            color: color,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Color _getColorFromName(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'yellow':
        return Colors.yellow;
      case 'orange':
        return Colors.orange;
      case 'purple':
        return Colors.purple;
      case 'black':
        return Colors.black;
      case 'white':
        return Colors.white;
      case 'silver':
        return Colors.grey.shade400;
      case 'gray':
      case 'grey':
        return Colors.grey;
      default:
        return AppColors.primary;
    }
  }

  Widget _buildLoadingGrid() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 24,
          mainAxisSpacing: 24,
          childAspectRatio: 0.75,
        ),
        itemCount: 8,
        itemBuilder: (context, index) => Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(48),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              IconsaxPlusBold.car,
              size: 80,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            '🚗 No Vehicles in Archive',
            style: AppTextStyles.headlineLarge.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 32,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Start building your vehicle inventory',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => _navigateToAddVehicle(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            icon: Icon(IconsaxPlusBold.add, size: 24),
            label: Text(
              'Add First Vehicle',
              style: AppTextStyles.buttonLarge.copyWith(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    String errorMessage;
    String actionText;
    VoidCallback? action;

    if (error.contains('Connection timeout') ||
        error.contains('Network error')) {
      errorMessage =
          '🌐 Connection Error\n\nPlease check your internet connection and try again.';
      actionText = 'Retry Connection';
      action = () => ref.read(vehicleListProvider.notifier).loadVehicles();
    } else if (error.contains('not found') || error.contains('404')) {
      errorMessage =
          '🔍 API Endpoint Not Found\n\nThe vehicle API endpoint is not available. Please contact support.';
      actionText = 'Contact Support';
      action = null;
    } else if (error.contains('Server error') || error.contains('500')) {
      errorMessage =
          '⚠️ Server Error\n\nThe server is experiencing issues. Please try again later.';
      actionText = 'Try Again';
      action = () => ref.read(vehicleListProvider.notifier).loadVehicles();
    } else {
      errorMessage = '❌ Error Loading Vehicles\n\n$error';
      actionText = 'Retry';
      action = () => ref.read(vehicleListProvider.notifier).loadVehicles();
    }

    return Center(
      child: Container(
        padding: const EdgeInsets.all(40),
        margin: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.error.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: AppColors.error.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                IconsaxPlusBold.warning_2,
                size: 64,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              errorMessage,
              style: AppTextStyles.headlineMedium.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (action != null) ...[
                  ElevatedButton.icon(
                    onPressed: action,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: Icon(IconsaxPlusBold.refresh, size: 20),
                    label: Text(
                      actionText,
                      style: AppTextStyles.buttonMedium.copyWith(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
                OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                    side: BorderSide(color: AppColors.border, width: 2),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: Icon(IconsaxPlusBold.arrow_left, size: 20),
                  label: Text(
                    'Go Back',
                    style: AppTextStyles.buttonMedium.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Navigation & Actions
  void _navigateToVehicleDetail(Vehicle vehicle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VehicleDetailScreen(vehicle: vehicle),
      ),
    );
  }

  void _navigateToAddVehicle() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const VehicleFormScreen()),
    ).then((result) {
      if (result == true) {
        // Refresh list after adding
        ref.read(vehicleListProvider.notifier).loadVehicles();
      }
    });
  }

  void _navigateToEditVehicle(Vehicle vehicle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VehicleFormScreen(vehicle: vehicle),
      ),
    ).then((result) {
      if (result == true) {
        // Refresh list after editing
        ref.read(vehicleListProvider.notifier).loadVehicles();
      }
    });
  }

  void _handleQuickAction(String action, Vehicle vehicle) {
    switch (action) {
      case 'view':
        _navigateToVehicleDetail(vehicle);
        break;
      case 'edit':
        _navigateToEditVehicle(vehicle);
        break;
      case 'sell':
        _markAsSold(vehicle);
        break;
      case 'delete':
        _showDeleteConfirmation(vehicle);
        break;
    }
  }

  void _markAsSold(Vehicle vehicle) {
    final updatedVehicle = vehicle.copyWith(availabilityStatus: 'sold');
    ref.read(vehicleListProvider.notifier).updateVehicle(updatedVehicle);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${vehicle.brand} ${vehicle.model} marked as sold'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showDeleteConfirmation(Vehicle vehicle) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Vehicle',
          style: AppTextStyles.headlineMedium.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'Are you sure you want to delete ${vehicle.brand} ${vehicle.model}?\n\nThis action cannot be undone.',
          style: AppTextStyles.bodyLarge,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTextStyles.buttonMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(vehicleListProvider.notifier).deleteVehicle(vehicle.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${vehicle.brand} ${vehicle.model} deleted successfully',
                  ),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: Text(
              'Delete',
              style: AppTextStyles.buttonMedium.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
