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
  String _searchQuery = '';
  
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
    
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
      _performSearch();
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
          ref.read(installmentProvider.notifier).loadInstallments(
            filter: filter,
            search: _searchQuery.isNotEmpty ? _searchQuery : null,
          );
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
                      onChanged: (value) {
                        // Search is handled by the controller listener
                      },
                      decoration: InputDecoration(
                        hintText: 'Search by customer name, phone, vehicle...',
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

  void _performSearch() {
    // Debounce search to avoid too many API calls
    Future.delayed(Duration(milliseconds: 500), () {
      if (_searchController.text == _searchQuery) {
        final currentFilter = ref.read(installmentProvider).selectedFilter;
        ref.read(installmentProvider.notifier).loadInstallments(
          filter: currentFilter,
          search: _searchQuery.isNotEmpty ? _searchQuery : null,
        );
      }
    });
  }

  void _showInstallmentDetails(Installment installment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Installment #${installment.installmentNumber}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Customer Information Section
              if (installment.hasCustomerInfo) ...[
                Text(
                  'Customer Information',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 8),
                _buildDetailRow('Name', installment.customerDisplayName),
                if (installment.customerPhone != null)
                  _buildDetailRow('Phone', installment.customerPhone!),
                if (installment.customerEmail != null)
                  _buildDetailRow('Email', installment.customerEmail!),
                if (installment.customerType != null)
                  _buildDetailRow('Type', installment.customerType!.toUpperCase()),
                SizedBox(height: 16),
              ],
              
              // Installment Information Section
              Text(
                'Installment Details',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: 8),
              _buildDetailRow('Transaction ID', installment.transactionId.toString()),
              _buildDetailRow('Amount', 'Rp ${installment.amount.toStringAsFixed(0)}'),
              _buildDetailRow('Status', installment.statusDisplayName),
              _buildDetailRow('Due Date', installment.dueDate.toString().substring(0, 10)),
              if (installment.paidAmount > 0)
                _buildDetailRow('Paid Amount', 'Rp ${installment.paidAmount.toStringAsFixed(0)}'),
              _buildDetailRow('Remaining', 'Rp ${installment.remainingAmount.toStringAsFixed(0)}'),
              
              // Transaction Information Section
              if (installment.vehicleInfo != null || installment.saleDate != null) ...[
                SizedBox(height: 16),
                Text(
                  'Transaction Details',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 8),
                if (installment.vehicleInfo != null)
                  _buildDetailRow('Vehicle', installment.vehicleInfo!),
                if (installment.saleDate != null)
                  _buildDetailRow('Sale Date', installment.saleDate!),
                if (installment.totalSaleAmount != null)
                  _buildDetailRow('Total Amount', 'Rp ${installment.totalSaleAmount!.toStringAsFixed(0)}'),
                if (installment.downPayment != null)
                  _buildDetailRow('Down Payment', 'Rp ${installment.downPayment!.toStringAsFixed(0)}'),
              ],
              
              if (installment.notes?.isNotEmpty == true) ...[
                SizedBox(height: 16),
                Text(
                  'Notes',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 8),
                Text(installment.notes!),
              ],
            ],
          ),
        ),
        actions: [
          if (installment.hasCustomerInfo)
            TextButton.icon(
              onPressed: () {
                Navigator.pop(context);
                _showCustomerManagement(installment);
              },
              icon: Icon(IconsaxPlusBold.user_edit),
              label: Text('Manage Customer'),
            ),
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
  
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  void _showCustomerManagement(Installment installment) {
    if (!installment.hasCustomerInfo) return;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Manage Customer: ${installment.customerDisplayName}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(IconsaxPlusBold.user),
              title: Text('View Customer Details'),
              subtitle: Text('See all installments for this customer'),
              onTap: () {
                Navigator.pop(context);
                _viewCustomerDetails(installment.customerId!);
              },
            ),
            ListTile(
              leading: Icon(IconsaxPlusBold.edit),
              title: Text('Update Customer Info'),
              subtitle: Text('Edit customer contact information'),
              onTap: () {
                Navigator.pop(context);
                _editCustomerInfo(installment);
              },
            ),
            if (installment.isOverdue)
              ListTile(
                leading: Icon(IconsaxPlusBold.message),
                title: Text('Send Reminder'),
                subtitle: Text('Send payment reminder to customer'),
                onTap: () {
                  Navigator.pop(context);
                  _sendPaymentReminder(installment);
                },
              ),
            ListTile(
              leading: Icon(IconsaxPlusBold.money_recive),
              title: Text('Settle All Installments'),
              subtitle: Text('Mark all customer installments as finished'),
              onTap: () {
                Navigator.pop(context);
                _settleCustomerInstallments(installment.customerId!);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
  
  void _viewCustomerDetails(int customerId) {
    // TODO: Navigate to customer detail screen or show customer details dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Customer details feature will be implemented')),
    );
  }
  
  void _editCustomerInfo(Installment installment) {
    // TODO: Show customer edit form
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit customer feature will be implemented')),
    );
  }
  
  void _sendPaymentReminder(Installment installment) {
    // TODO: Implement payment reminder functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment reminder feature will be implemented')),
    );
  }
  
  void _settleCustomerInstallments(int customerId) {
    // TODO: Show settlement dialog and process
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Settlement feature will be implemented')),
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
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Customer Information Section
              if (installment.hasCustomerInfo) ...[
                Text(
                  'Customer Information',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 8),
                _buildDetailRow('Name', installment.customerDisplayName),
                if (installment.customerPhone != null)
                  _buildDetailRow('Phone', installment.customerPhone!),
                if (installment.customerEmail != null)
                  _buildDetailRow('Email', installment.customerEmail!),
                if (installment.customerType != null)
                  _buildDetailRow('Type', installment.customerType!.toUpperCase()),
                SizedBox(height: 16),
              ],
              
              // Installment Information Section
              Text(
                'Installment Details',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: 8),
              _buildDetailRow('Transaction ID', installment.transactionId.toString()),
              _buildDetailRow('Amount', 'Rp ${installment.amount.toStringAsFixed(0)}'),
              _buildDetailRow('Status', installment.statusDisplayName),
              _buildDetailRow('Due Date', installment.dueDate.toString().substring(0, 10)),
              if (installment.paidAmount > 0)
                _buildDetailRow('Paid Amount', 'Rp ${installment.paidAmount.toStringAsFixed(0)}'),
              _buildDetailRow('Remaining', 'Rp ${installment.remainingAmount.toStringAsFixed(0)}'),
              
              // Transaction Information Section
              if (installment.vehicleInfo != null || installment.saleDate != null) ...[
                SizedBox(height: 16),
                Text(
                  'Transaction Details',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 8),
                if (installment.vehicleInfo != null)
                  _buildDetailRow('Vehicle', installment.vehicleInfo!),
                if (installment.saleDate != null)
                  _buildDetailRow('Sale Date', installment.saleDate!),
                if (installment.totalSaleAmount != null)
                  _buildDetailRow('Total Amount', 'Rp ${installment.totalSaleAmount!.toStringAsFixed(0)}'),
                if (installment.downPayment != null)
                  _buildDetailRow('Down Payment', 'Rp ${installment.downPayment!.toStringAsFixed(0)}'),
              ],
              
              if (installment.notes?.isNotEmpty == true) ...[
                SizedBox(height: 16),
                Text(
                  'Notes',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 8),
                Text(installment.notes!),
              ],
            ],
          ),
        ),
        actions: [
          if (installment.hasCustomerInfo)
            TextButton.icon(
              onPressed: () {
                Navigator.pop(context);
                _showCustomerManagement(installment);
              },
              icon: Icon(IconsaxPlusBold.user_edit),
              label: Text('Manage Customer'),
            ),
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