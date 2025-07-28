import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/installment_model.dart';
import '../../../providers/installment_provider.dart';
import '../../widgets/installment/installment_card.dart';
import 'installment_payment_screen.dart';

class InstallmentListScreen extends ConsumerStatefulWidget {
  const InstallmentListScreen({super.key});

  @override
  ConsumerState<InstallmentListScreen> createState() => _InstallmentListScreenState();
}

class _InstallmentListScreenState extends ConsumerState<InstallmentListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  
  final List<String> _filterTabs = ['all', 'pending', 'overdue', 'paid'];
  final Map<String, String> _tabLabels = {
    'all': 'All',
    'pending': 'Pending',
    'overdue': 'Overdue',
    'paid': 'Paid',
  };

  bool get isTablet => MediaQuery.of(context).size.width >= 768;
  bool get isLargeTablet => MediaQuery.of(context).size.width >= 1024;

  EdgeInsets get responsivePadding => EdgeInsets.all(isTablet ? 24.0 : 16.0);
  double get responsiveSpacing => isTablet ? 20.0 : 16.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _filterTabs.length, vsync: this);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(installmentProvider.notifier).loadInstallments();
      ref.read(installmentProvider.notifier).loadInstallmentStats();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildHeader(),
          _buildFilterTabs(),
          _buildSearchBar(),
          Expanded(child: _buildInstallmentList()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final stats = ref.watch(installmentStatsProvider);
    
    return Container(
      padding: responsivePadding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      IconsaxPlusBold.arrow_left,
                      color: Colors.white,
                      size: isTablet ? 28 : 24,
                    ),
                    padding: EdgeInsets.all(isTablet ? 16 : 12),
                  ),
                ),
                SizedBox(width: responsiveSpacing),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '📋 Installment Management',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: isTablet ? 28 : 20,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Track and manage all installment payments',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w500,
                          fontSize: isTablet ? 16 : 14,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isTablet) _buildStatsCard(stats),
              ],
            ),
            if (!isTablet && stats.isNotEmpty) ...[
              SizedBox(height: responsiveSpacing),
              _buildStatsRow(stats),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard(Map<String, dynamic> stats) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(IconsaxPlusBold.receipt_minus, size: 24, color: Colors.white),
          SizedBox(height: 8),
          Text(
            '${stats['pending_count'] ?? 0}',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          Text(
            'Pending',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(Map<String, dynamic> stats) {
    return Row(
      children: [
        Expanded(child: _buildStatItem('Pending', '${stats['pending_count'] ?? 0}', AppColors.warning)),
        SizedBox(width: 12),
        Expanded(child: _buildStatItem('Overdue', '${stats['overdue_count'] ?? 0}', AppColors.error)),
        SizedBox(width: 12),
        Expanded(child: _buildStatItem('Paid', '${stats['paid_count'] ?? 0}', AppColors.success)),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    final installmentState = ref.watch(installmentProvider);
    
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        onTap: (index) {
          final filter = _filterTabs[index];
          ref.read(installmentProvider.notifier).loadInstallments(filter: filter);
        },
        isScrollable: !isTablet,
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSecondary,
        indicatorColor: AppColors.primary,
        labelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: isTablet ? 16 : 14,
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: isTablet ? 16 : 14,
        ),
        tabs: _filterTabs.map((filter) {
          final count = _getFilterCount(filter, installmentState);
          return Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_tabLabels[filter] ?? filter),
                if (count > 0) ...[
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: _getFilterColor(filter),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$count',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  int _getFilterCount(String filter, InstallmentState state) {
    switch (filter) {
      case 'pending':
        return state.pendingCount;
      case 'overdue':
        return state.overdueCount;
      case 'paid':
        return state.paidCount;
      default:
        return state.installments.length;
    }
  }

  Color _getFilterColor(String filter) {
    switch (filter) {
      case 'pending':
        return AppColors.warning;
      case 'overdue':
        return AppColors.error;
      case 'paid':
        return AppColors.success;
      default:
        return AppColors.primary;
    }
  }

  Widget _buildSearchBar() {
    return Container(
      padding: responsivePadding,
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48,
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.withOpacity(0.05),
              ),
              child: Row(
                children: [
                  Icon(
                    IconsaxPlusBold.search_normal,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search installments...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: isTablet ? 16 : 14,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: isTablet ? 16 : 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 12),
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              onPressed: () {
                ref.read(installmentProvider.notifier).refreshAll();
              },
              icon: Icon(
                IconsaxPlusBold.refresh,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstallmentList() {
    final installmentState = ref.watch(installmentProvider);
    
    if (installmentState.isLoading) {
      return _buildLoadingState();
    }
    
    if (installmentState.error != null) {
      return _buildErrorState(installmentState.error!);
    }
    
    final filteredInstallments = ref.watch(filteredInstallmentsProvider);
    
    return RefreshIndicator(
      onRefresh: () => ref.read(installmentProvider.notifier).refreshAll(),
      child: Container(
        color: AppColors.background,
        child: filteredInstallments.isEmpty
            ? _buildEmptyState()
            : Padding(
                padding: responsivePadding,
                child: InstallmentListView(
                  installments: filteredInstallments,
                  onInstallmentTap: _onInstallmentTap,
                  onPayTap: _onPayTap,
                  isTablet: isTablet,
                ),
              ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Loading installments...',
            style: TextStyle(
              fontSize: isTablet ? 16 : 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: responsivePadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              IconsaxPlusBold.warning_2,
              size: isTablet ? 64 : 48,
              color: AppColors.error,
            ),
            SizedBox(height: 16),
            Text(
              'Error loading installments',
              style: TextStyle(
                fontSize: isTablet ? 20 : 18,
                fontWeight: FontWeight.w600,
                color: AppColors.error,
              ),
            ),
            SizedBox(height: 8),
            Text(
              error,
              style: TextStyle(
                fontSize: isTablet ? 16 : 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => ref.read(installmentProvider.notifier).refreshAll(),
              icon: Icon(IconsaxPlusBold.refresh),
              label: Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: responsivePadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              IconsaxPlusBold.receipt_minus,
              size: isTablet ? 64 : 48,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: 16),
            Text(
              'No installments found',
              style: TextStyle(
                fontSize: isTablet ? 20 : 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'There are no installments to display for the selected filter',
              style: TextStyle(
                fontSize: isTablet ? 16 : 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _onInstallmentTap(Installment installment) {
    // Navigate to installment details or show details dialog
    _showInstallmentDetails(installment);
  }

  void _onPayTap(Installment installment) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InstallmentPaymentScreen(installment: installment),
      ),
    ).then((result) {
      if (result == true) {
        // Refresh data after successful payment
        ref.read(installmentProvider.notifier).refreshAll();
      }
    });
  }

  void _showInstallmentDetails(Installment installment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Installment #${installment.installmentNumber}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Transaction ID: ${installment.transactionId}'),
            Text('Amount: Rp ${installment.amount.toStringAsFixed(0)}'),
            Text('Status: ${installment.statusDisplayName}'),
            Text('Due Date: ${installment.dueDate.toString().substring(0, 10)}'),
            if (installment.paidAmount > 0)
              Text('Paid Amount: Rp ${installment.paidAmount.toStringAsFixed(0)}'),
            if (installment.notes?.isNotEmpty == true)
              Text('Notes: ${installment.notes}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
          if (!installment.isPaid)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _onPayTap(installment);
              },
              child: Text('Pay Now'),
            ),
        ],
      ),
    );
  }
}