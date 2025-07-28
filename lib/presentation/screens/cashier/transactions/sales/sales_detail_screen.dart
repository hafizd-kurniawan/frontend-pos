import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/constants/ui_constants.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../data/models/sale_model.dart';
import '../../../../providers/sales_provider.dart';

class SalesDetailScreen extends ConsumerStatefulWidget {
  final int saleId;

  const SalesDetailScreen({super.key, required this.saleId});

  @override
  ConsumerState<SalesDetailScreen> createState() => _SalesDetailScreenState();
}

class _SalesDetailScreenState extends ConsumerState<SalesDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(salesProvider.notifier).loadSaleById(widget.saleId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final salesState = ref.watch(salesProvider);
    final sale = salesState.currentSale;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Sale Details',
          style: AppTextStyles.titleLarge.copyWith(fontWeight: FontWeight.w700),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        actions: [
          if (sale != null)
            PopupMenuButton<String>(
              onSelected: (value) {
                _handleMenuAction(value, sale);
              },
              itemBuilder: (context) => [
                if (sale.status.toLowerCase() != 'cancelled')
                  const PopupMenuItem(
                    value: 'cancel',
                    child: Row(
                      children: [
                        Icon(IconsaxPlusBold.close_circle, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Cancel Sale'),
                      ],
                    ),
                  ),
                const PopupMenuItem(
                  value: 'receipt',
                  child: Row(
                    children: [
                      Icon(IconsaxPlusBold.receipt, color: Colors.blue),
                      SizedBox(width: 8),
                      Text('Generate Receipt'),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
      body: salesState.isLoading && sale == null
          ? const Center(child: CircularProgressIndicator())
          : sale == null
          ? _buildErrorState()
          : _buildSaleDetails(sale),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(IconsaxPlusBold.warning_2, size: 64.w, color: AppColors.error),
          SizedBox(height: UiConstants.spacingLarge),
          Text('Sale not found', style: AppTextStyles.titleMedium),
          SizedBox(height: UiConstants.spacingSmall),
          Text(
            'The sale you\'re looking for doesn\'t exist',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: UiConstants.spacingLarge),
          CustomButton(
            text: 'Go Back',
            onPressed: () => Navigator.pop(context),
            variant: CustomButtonVariant.outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildSaleDetails(Sale sale) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(UiConstants.spacingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSaleHeader(sale),
          SizedBox(height: UiConstants.spacingLarge),
          _buildCustomerSection(sale),
          SizedBox(height: UiConstants.spacingLarge),
          _buildVehicleSection(sale),
          SizedBox(height: UiConstants.spacingLarge),
          _buildPaymentSection(sale),
          SizedBox(height: UiConstants.spacingLarge),
          _buildNotesSection(sale),
        ],
      ),
    );
  }

  Widget _buildSaleHeader(Sale sale) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(UiConstants.spacingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sale #${sale.id}',
                  style: AppTextStyles.headlineSmall.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                _buildStatusChip(sale.status),
              ],
            ),
            SizedBox(height: UiConstants.spacingMedium),
            Row(
              children: [
                Icon(
                  IconsaxPlusBold.calendar,
                  size: 16.w,
                  color: AppColors.textSecondary,
                ),
                SizedBox(width: UiConstants.spacingSmall),
                Text(
                  'Sale Date: ${_formatDate(sale.saleDate)}',
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ),
            SizedBox(height: UiConstants.spacingSmall),
            Row(
              children: [
                Icon(
                  IconsaxPlusBold.clock,
                  size: 16.w,
                  color: AppColors.textSecondary,
                ),
                SizedBox(width: UiConstants.spacingSmall),
                Text(
                  'Created: ${_formatDateTime(sale.createdAt)}',
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerSection(Sale sale) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(UiConstants.spacingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(IconsaxPlusBold.user, color: AppColors.primary),
                SizedBox(width: UiConstants.spacingSmall),
                Text(
                  'Customer Information',
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            SizedBox(height: UiConstants.spacingMedium),
            if (sale.customer != null) ...[
              _buildInfoRow('Name', sale.customer!.name),
              _buildInfoRow('Phone', sale.customer!.phone),
              _buildInfoRow('Email', sale.customer!.email),
              _buildInfoRow('Address', sale.customer!.address),
            ] else
              Text(
                'Customer ID: ${sale.customerId}',
                style: AppTextStyles.bodyMedium,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleSection(Sale sale) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(UiConstants.spacingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(IconsaxPlusBold.car, color: AppColors.primary),
                SizedBox(width: UiConstants.spacingSmall),
                Text(
                  'Vehicle Information',
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            SizedBox(height: UiConstants.spacingMedium),
            if (sale.vehicle != null) ...[
              _buildInfoRow('Vehicle', sale.vehicle!.name),
              _buildInfoRow('Brand', sale.vehicle!.brand),
              _buildInfoRow('Model', sale.vehicle!.model),
              _buildInfoRow('Year', sale.vehicle!.year.toString()),
              _buildInfoRow('Color', sale.vehicle!.color),
              _buildInfoRow('License Plate', sale.vehicle!.licensePlate ?? '-'),
            ] else
              Text(
                'Vehicle ID: ${sale.vehicleId}',
                style: AppTextStyles.bodyMedium,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentSection(Sale sale) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(UiConstants.spacingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(IconsaxPlusBold.money, color: AppColors.success),
                SizedBox(width: UiConstants.spacingSmall),
                Text(
                  'Payment Information',
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            SizedBox(height: UiConstants.spacingMedium),
            _buildInfoRow(
              'Total Amount',
              'Rp ${_formatCurrency(sale.totalAmount)}',
            ),
            _buildInfoRow(
              'Down Payment',
              'Rp ${_formatCurrency(sale.downPayment)}',
            ),
            _buildInfoRow(
              'Remaining Amount',
              'Rp ${_formatCurrency(sale.remainingAmount)}',
            ),
            _buildInfoRow('Payment Method', sale.paymentMethod),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesSection(Sale sale) {
    if (sale.notes.isEmpty) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: EdgeInsets.all(UiConstants.spacingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(IconsaxPlusBold.note, color: AppColors.warning),
                SizedBox(width: UiConstants.spacingSmall),
                Text(
                  'Notes',
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            SizedBox(height: UiConstants.spacingMedium),
            Text(sale.notes, style: AppTextStyles.bodyMedium),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: UiConstants.spacingSmall),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120.w,
            child: Text(
              '$label:',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'completed':
        color = AppColors.success;
        break;
      case 'pending':
        color = AppColors.warning;
        break;
      case 'cancelled':
        color = AppColors.error;
        break;
      default:
        color = AppColors.textSecondary;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: UiConstants.spacingMedium,
        vertical: UiConstants.spacingTiny,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        status.toUpperCase(),
        style: AppTextStyles.labelSmall.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _handleMenuAction(String action, Sale sale) {
    switch (action) {
      case 'cancel':
        _showCancelDialog(sale);
        break;
      case 'receipt':
        _generateReceipt(sale);
        break;
    }
  }

  void _showCancelDialog(Sale sale) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Sale'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Are you sure you want to cancel this sale?'),
            SizedBox(height: UiConstants.spacingMedium),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Cancellation Reason',
                hintText: 'Enter reason for cancellation',
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (reasonController.text.trim().isNotEmpty) {
                Navigator.pop(context);
                ref
                    .read(salesProvider.notifier)
                    .cancelSale(sale.id, reasonController.text.trim());
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Confirm Cancel'),
          ),
        ],
      ),
    );
  }

  void _generateReceipt(Sale sale) {
    ref.read(salesProvider.notifier).generateReceipt(sale.id);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Receipt generated successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }

  String _formatCurrency(double amount) {
    return amount
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateStr;
    }
  }

  String _formatDateTime(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateStr;
    }
  }
}
