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
import '../../../providers/sales_provider.dart';

class SalesListScreen extends ConsumerStatefulWidget {
  const SalesListScreen({super.key});

  @override
  ConsumerState<SalesListScreen> createState() => _SalesListScreenState();
}

class _SalesListScreenState extends ConsumerState<SalesListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedStatus = 'All';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(salesProvider.notifier).loadSales();
    });
  }

  @override
  Widget build(BuildContext context) {
    final salesState = ref.watch(salesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          '🛒 Sales Management',
          style: AppTextStyles.titleLarge.copyWith(fontWeight: FontWeight.w700),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              ref.read(salesProvider.notifier).loadSales();
            },
            icon: Icon(IconsaxPlusBold.refresh, color: AppColors.primary),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildHeader(),
          _buildFilters(),
          Expanded(child: _buildSalesList(salesState)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SalesCreateScreen()),
          );
        },
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(IconsaxPlusBold.add),
        label: const Text('New Sale'),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(UiConstants.spacingLarge),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Search Bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search by customer name, vehicle...',
              prefixIcon: Icon(
                IconsaxPlusBold.search_normal,
                color: AppColors.textSecondary,
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        _searchController.clear();
                        setState(() {});
                      },
                      icon: Icon(
                        IconsaxPlusBold.close_circle,
                        color: AppColors.textSecondary,
                      ),
                    )
                  : null,
            ),
            onChanged: (value) {
              setState(() {});
              // TODO: Implement search
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    final statuses = ['All', 'Pending', 'Completed', 'Cancelled'];

    return Container(
      height: 60.h,
      padding: EdgeInsets.symmetric(horizontal: UiConstants.spacingLarge),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: statuses.length,
        itemBuilder: (context, index) {
          final status = statuses[index];
          final isSelected = _selectedStatus == status;

          return Padding(
            padding: EdgeInsets.only(right: UiConstants.spacingMedium),
            child: FilterChip(
              label: Text(status),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedStatus = status;
                });
                // TODO: Implement filter
              },
              backgroundColor: Colors.white,
              selectedColor: AppColors.primary.withValues(alpha: 0.1),
              labelStyle: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSalesList(SalesState state) {
    if (state.isLoading && state.sales.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(IconsaxPlusBold.warning_2, size: 64.w, color: AppColors.error),
            SizedBox(height: UiConstants.spacingLarge),
            Text('Error loading sales', style: AppTextStyles.titleMedium),
            SizedBox(height: UiConstants.spacingSmall),
            Text(
              state.error!,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: UiConstants.spacingLarge),
            CustomButton(
              text: 'Retry',
              onPressed: () {
                ref.read(salesProvider.notifier).loadSales();
              },
              variant: CustomButtonVariant.outlined,
            ),
          ],
        ),
      );
    }

    if (state.sales.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              IconsaxPlusBold.receipt,
              size: 64.w,
              color: AppColors.textTertiary,
            ),
            SizedBox(height: UiConstants.spacingLarge),
            Text('No sales transactions yet', style: AppTextStyles.titleMedium),
            SizedBox(height: UiConstants.spacingSmall),
            Text(
              'Create your first sale to get started',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: UiConstants.spacingLarge),
            CustomButton(
              text: 'Create Sale',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SalesCreateScreen(),
                  ),
                );
              },
              icon: IconsaxPlusBold.add,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.read(salesProvider.notifier).loadSales();
      },
      child: ListView.builder(
        padding: EdgeInsets.all(UiConstants.spacingLarge),
        itemCount: state.sales.length,
        itemBuilder: (context, index) {
          final sale = state.sales[index];
          return _buildSaleCard(sale);
        },
      ),
    );
  }

  Widget _buildSaleCard(Sale sale) {
    return Card(
      margin: EdgeInsets.only(bottom: UiConstants.spacingMedium),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SalesDetailScreen(saleId: sale.id),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12.r),
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
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  _buildStatusChip(sale.status),
                ],
              ),
              SizedBox(height: UiConstants.spacingMedium),

              // Customer info
              Row(
                children: [
                  Icon(
                    IconsaxPlusBold.user,
                    size: 16.w,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(width: UiConstants.spacingSmall),
                  Expanded(
                    child: Text(
                      sale.customer?.name ?? 'Customer #${sale.customerId}',
                      style: AppTextStyles.bodyMedium,
                    ),
                  ),
                ],
              ),
              SizedBox(height: UiConstants.spacingSmall),

              // Vehicle info
              Row(
                children: [
                  Icon(
                    IconsaxPlusBold.car,
                    size: 16.w,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(width: UiConstants.spacingSmall),
                  Expanded(
                    child: Text(
                      sale.vehicle?.name ?? 'Vehicle #${sale.vehicleId}',
                      style: AppTextStyles.bodyMedium,
                    ),
                  ),
                ],
              ),
              SizedBox(height: UiConstants.spacingMedium),

              // Amount and date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Amount',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        'Rp ${_formatCurrency(sale.totalAmount)}',
                        style: AppTextStyles.titleMedium.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Sale Date',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        _formatDate(sale.saleDate),
                        style: AppTextStyles.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
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

  String _formatCurrency(double amount) {
    // Simple formatting, you can use intl package for better formatting
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
