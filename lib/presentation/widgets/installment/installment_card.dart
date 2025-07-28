import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/installment_model.dart';
import 'package:intl/intl.dart';

class InstallmentCard extends StatelessWidget {
  final Installment installment;
  final VoidCallback? onTap;
  final VoidCallback? onPayTap;
  final bool isTablet;
  final bool showPayButton;

  const InstallmentCard({
    super.key,
    required this.installment,
    this.onTap,
    this.onPayTap,
    this.isTablet = false,
    this.showPayButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: isTablet ? 12 : 8),
        padding: EdgeInsets.all(isTablet ? 16 : 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: statusColor.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildHeader(statusColor),
            SizedBox(height: isTablet ? 12 : 8),
            _buildContent(),
            if (showPayButton && !installment.isPaid) ...[
              SizedBox(height: isTablet ? 12 : 8),
              _buildActionButton(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Color statusColor) {
    return Row(
      children: [
        // Status indicator
        Container(
          padding: EdgeInsets.all(isTablet ? 8 : 6),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getStatusIcon(),
            color: statusColor,
            size: isTablet ? 20 : 18,
          ),
        ),
        
        SizedBox(width: isTablet ? 12 : 8),
        
        // Installment info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Installment #${installment.installmentNumber}',
                style: TextStyle(
                  fontSize: isTablet ? 16 : 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'Transaction #${installment.transactionId}',
                style: TextStyle(
                  fontSize: isTablet ? 12 : 10,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        
        // Status badge
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 12 : 8,
            vertical: isTablet ? 6 : 4,
          ),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            installment.statusDisplayName,
            style: TextStyle(
              fontSize: isTablet ? 12 : 10,
              fontWeight: FontWeight.w600,
              color: statusColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        // Amount and due date row
        Row(
          children: [
            Expanded(
              child: _buildInfoItem(
                icon: IconsaxPlusBold.money_recive,
                label: 'Amount',
                value: 'Rp ${installment.amount.toStringAsFixed(0)}',
              ),
            ),
            SizedBox(width: isTablet ? 16 : 12),
            Expanded(
              child: _buildInfoItem(
                icon: IconsaxPlusBold.calendar,
                label: 'Due Date',
                value: DateFormat('dd MMM yyyy').format(installment.dueDate),
                isOverdue: installment.isOverdue,
              ),
            ),
          ],
        ),
        
        if (installment.paidAmount > 0) ...[
          SizedBox(height: isTablet ? 12 : 8),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  icon: IconsaxPlusBold.tick_circle,
                  label: 'Paid Amount',
                  value: 'Rp ${installment.paidAmount.toStringAsFixed(0)}',
                ),
              ),
              SizedBox(width: isTablet ? 16 : 12),
              Expanded(
                child: _buildInfoItem(
                  icon: IconsaxPlusBold.money_send,
                  label: 'Remaining',
                  value: 'Rp ${installment.remainingAmount.toStringAsFixed(0)}',
                ),
              ),
            ],
          ),
        ],
        
        // Payment details if paid
        if (installment.isPaid && installment.paidAt != null) ...[
          SizedBox(height: isTablet ? 12 : 8),
          Container(
            padding: EdgeInsets.all(isTablet ? 12 : 8),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  IconsaxPlusBold.tick_circle,
                  color: AppColors.success,
                  size: isTablet ? 16 : 14,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Paid on ${DateFormat('dd MMM yyyy').format(installment.paidAt!)}',
                    style: TextStyle(
                      fontSize: isTablet ? 12 : 10,
                      color: AppColors.success,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (installment.paymentMethod != null) ...[
                  Text(
                    'via ${installment.paymentMethod}',
                    style: TextStyle(
                      fontSize: isTablet ? 12 : 10,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
        
        // Overdue warning
        if (installment.isOverdue) ...[
          SizedBox(height: isTablet ? 12 : 8),
          Container(
            padding: EdgeInsets.all(isTablet ? 12 : 8),
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  IconsaxPlusBold.warning_2,
                  color: AppColors.error,
                  size: isTablet ? 16 : 14,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Overdue by ${DateTime.now().difference(installment.dueDate).inDays} days',
                    style: TextStyle(
                      fontSize: isTablet ? 12 : 10,
                      color: AppColors.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    bool isOverdue = false,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: isOverdue ? AppColors.error : AppColors.textSecondary,
          size: isTablet ? 16 : 14,
        ),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: isTablet ? 10 : 8,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: isTablet ? 14 : 12,
                  fontWeight: FontWeight.w600,
                  color: isOverdue ? AppColors.error : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton() {
    if (installment.isPaid) return const SizedBox.shrink();
    
    final isOverdue = installment.isOverdue;
    final buttonColor = isOverdue ? AppColors.error : AppColors.primary;
    final buttonText = isOverdue ? 'Pay Overdue' : 'Pay Now';
    
    return SizedBox(
      width: double.infinity,
      height: isTablet ? 44 : 36,
      child: ElevatedButton.icon(
        onPressed: onPayTap,
        icon: Icon(
          IconsaxPlusBold.card,
          size: isTablet ? 18 : 16,
        ),
        label: Text(
          buttonText,
          style: TextStyle(
            fontSize: isTablet ? 14 : 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor() {
    try {
      return Color(int.parse(installment.statusColor.replaceAll('#', '0xFF')));
    } catch (e) {
      switch (installment.status) {
        case 'paid':
          return AppColors.success;
        case 'pending':
          return installment.isOverdue ? AppColors.error : AppColors.warning;
        case 'overdue':
          return AppColors.error;
        case 'partially_paid':
          return AppColors.primary;
        default:
          return AppColors.textSecondary;
      }
    }
  }

  IconData _getStatusIcon() {
    switch (installment.status) {
      case 'paid':
        return IconsaxPlusBold.tick_circle;
      case 'pending':
        return installment.isOverdue ? IconsaxPlusBold.warning_2 : IconsaxPlusBold.clock;
      case 'overdue':
        return IconsaxPlusBold.warning_2;
      case 'partially_paid':
        return IconsaxPlusBold.card;
      default:
        return IconsaxPlusBold.info_circle;
    }
  }
}

class InstallmentListView extends StatelessWidget {
  final List<Installment> installments;
  final Function(Installment)? onInstallmentTap;
  final Function(Installment)? onPayTap;
  final bool isTablet;
  final bool showPayButton;

  const InstallmentListView({
    super.key,
    required this.installments,
    this.onInstallmentTap,
    this.onPayTap,
    this.isTablet = false,
    this.showPayButton = true,
  });

  @override
  Widget build(BuildContext context) {
    if (installments.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: installments.length,
      itemBuilder: (context, index) {
        final installment = installments[index];
        return InstallmentCard(
          installment: installment,
          onTap: onInstallmentTap != null ? () => onInstallmentTap!(installment) : null,
          onPayTap: onPayTap != null ? () => onPayTap!(installment) : null,
          isTablet: isTablet,
          showPayButton: showPayButton,
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 48 : 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              IconsaxPlusBold.receipt_minus,
              size: isTablet ? 64 : 48,
              color: AppColors.textSecondary,
            ),
            SizedBox(height: isTablet ? 24 : 16),
            Text(
              'No installments found',
              style: TextStyle(
                fontSize: isTablet ? 20 : 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: isTablet ? 12 : 8),
            Text(
              'There are no installments to display',
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
}