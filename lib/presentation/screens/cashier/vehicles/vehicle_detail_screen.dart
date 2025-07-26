import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../data/models/vehicle_model.dart';
import '../../../../core/widgets/custom_button.dart';

class VehicleDetailScreen extends ConsumerWidget {
  final Vehicle vehicle;

  const VehicleDetailScreen({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildVehicleHeader(),
            _buildVehicleDetails(),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(IconsaxPlusBold.arrow_left, color: AppColors.textPrimary),
      ),
      title: Text(
        '${vehicle.make} ${vehicle.model}',
        style: AppTextStyles.headlineMedium.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () => _showEditDialog(context),
          icon: Icon(IconsaxPlusBold.edit, color: AppColors.warning),
        ),
        IconButton(
          onPressed: () => _showDeleteDialog(context),
          icon: Icon(IconsaxPlusBold.trash, color: AppColors.error),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildVehicleHeader() {
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
          // Vehicle Image Placeholder
          Container(
            width: 200,
            height: 150,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(IconsaxPlusBold.car, color: AppColors.primary, size: 64),
                const SizedBox(height: 8),
                Text(
                  'No Image',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 32),

          // Vehicle Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${vehicle.make} ${vehicle.model}',
                        style: AppTextStyles.displaySmall.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    _buildStatusBadge(vehicle.status),
                  ],
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    _buildInfoChip(
                      IconsaxPlusBold.calendar,
                      vehicle.year.toString(),
                      AppColors.info,
                    ),
                    const SizedBox(width: 16),
                    _buildInfoChip(
                      IconsaxPlusBold.location,
                      '${vehicle.mileage.toStringAsFixed(0)} km',
                      AppColors.warning,
                    ),
                    const SizedBox(width: 16),
                    _buildConditionChip(vehicle.condition),
                  ],
                ),

                const SizedBox(height: 24),

                Text(
                  'Rp ${NumberFormat('#,###').format(vehicle.price)}',
                  style: AppTextStyles.displayMedium.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.success,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Added on ${DateFormat('MMMM dd, yyyy').format(vehicle.createdAt)}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleDetails() {
    return Container(
      margin: const EdgeInsets.all(32),
      padding: const EdgeInsets.all(32),
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
          Text(
            'Vehicle Details',
            style: AppTextStyles.headlineMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(child: _buildDetailItem('Make', vehicle.make)),
              Expanded(child: _buildDetailItem('Model', vehicle.model)),
              Expanded(
                child: _buildDetailItem('Year', vehicle.year.toString()),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: _buildDetailItem(
                  'Price',
                  'Rp ${NumberFormat('#,###').format(vehicle.price)}',
                ),
              ),
              Expanded(
                child: _buildDetailItem(
                  'Mileage',
                  '${vehicle.mileage.toStringAsFixed(0)} km',
                ),
              ),
              Expanded(
                child: _buildDetailItem(
                  'Condition',
                  vehicle.condition.toUpperCase(),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: _buildDetailItem('Status', vehicle.status.toUpperCase()),
              ),
              Expanded(
                child: _buildDetailItem(
                  'Last Updated',
                  DateFormat('MMM dd, yyyy').format(vehicle.updatedAt),
                ),
              ),
              const Expanded(child: SizedBox()),
            ],
          ),

          const SizedBox(height: 32),

          Text(
            'Description',
            style: AppTextStyles.titleLarge.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 12),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Text(
              vehicle.description.isNotEmpty
                  ? vehicle.description
                  : 'No description available for this vehicle.',
              style: AppTextStyles.bodyLarge.copyWith(
                color: vehicle.description.isNotEmpty
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          if (vehicle.status == 'available') ...[
            Expanded(
              child: CustomButton(
                onPressed: () => _showSellDialog(context),
                text: 'Sell Vehicle',
                icon: IconsaxPlusBold.money_send,
                backgroundColor: AppColors.sales,
              ),
            ),
            const SizedBox(width: 20),
          ],

          Expanded(
            child: CustomButton(
              onPressed: () => _showEditDialog(context),
              text: 'Edit Vehicle',
              icon: IconsaxPlusBold.edit,
              variant: ButtonVariant.outlined,
            ),
          ),

          const SizedBox(width: 20),

          if (vehicle.status == 'available')
            Expanded(
              child: CustomButton(
                onPressed: () => _showMaintenanceDialog(context),
                text: 'Send to Maintenance',
                icon: IconsaxPlusBold.setting_2,
                backgroundColor: AppColors.warning,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String label;
    IconData icon;

    switch (status.toLowerCase()) {
      case 'available':
        color = AppColors.success;
        label = 'Available';
        icon = IconsaxPlusBold.tick_circle;
        break;
      case 'sold':
        color = AppColors.sales;
        label = 'Sold';
        icon = IconsaxPlusBold.money_send;
        break;
      case 'maintenance':
        color = AppColors.warning;
        label = 'Maintenance';
        icon = IconsaxPlusBold.setting_2;
        break;
      default:
        color = AppColors.textTertiary;
        label = status;
        icon = IconsaxPlusBold.info_circle;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 8),
          Text(
            label,
            style: AppTextStyles.labelLarge.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: AppTextStyles.labelMedium.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConditionChip(String condition) {
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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            condition[0].toUpperCase() + condition.substring(1),
            style: AppTextStyles.labelMedium.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Edit Vehicle feature coming next!'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Vehicle'),
        content: Text(
          'Are you sure you want to delete ${vehicle.make} ${vehicle.model}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Vehicle deleted successfully'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  void _showSellDialog(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sell Vehicle feature coming next!'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _showMaintenanceDialog(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Maintenance feature coming next!'),
        backgroundColor: AppColors.info,
      ),
    );
  }
}
