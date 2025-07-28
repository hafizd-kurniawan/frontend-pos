import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/installment_model.dart';

class InstallmentCalculator extends StatefulWidget {
  final double vehiclePrice;
  final double downPayment;
  final List<int> installmentOptions;
  final int? selectedInstallmentCount;
  final Function(int) onInstallmentCountChanged;
  final InstallmentPreview? preview;
  final bool isLoading;
  final bool isTablet;

  const InstallmentCalculator({
    super.key,
    required this.vehiclePrice,
    required this.downPayment,
    required this.installmentOptions,
    this.selectedInstallmentCount,
    required this.onInstallmentCountChanged,
    this.preview,
    this.isLoading = false,
    this.isTablet = false,
  });

  @override
  State<InstallmentCalculator> createState() => _InstallmentCalculatorState();
}

class _InstallmentCalculatorState extends State<InstallmentCalculator> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(widget.isTablet ? 20 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          SizedBox(height: widget.isTablet ? 20 : 16),
          _buildInstallmentOptions(),
          if (widget.selectedInstallmentCount != null) ...[
            SizedBox(height: widget.isTablet ? 20 : 16),
            _buildPreviewSection(),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(widget.isTablet ? 12 : 8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            IconsaxPlusBold.calculator,
            color: AppColors.primary,
            size: widget.isTablet ? 24 : 20,
          ),
        ),
        SizedBox(width: widget.isTablet ? 16 : 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '💰 Installment Calculator',
                style: TextStyle(
                  fontSize: widget.isTablet ? 20 : 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Choose your payment plan',
                style: TextStyle(
                  fontSize: widget.isTablet ? 14 : 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInstallmentOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Installment Period',
          style: TextStyle(
            fontSize: widget.isTablet ? 16 : 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: widget.isTablet ? 12 : 8),
        Wrap(
          spacing: widget.isTablet ? 12 : 8,
          runSpacing: widget.isTablet ? 12 : 8,
          children: widget.installmentOptions.map((months) {
            final isSelected = widget.selectedInstallmentCount == months;
            return _buildInstallmentChip(months, isSelected);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildInstallmentChip(int months, bool isSelected) {
    return GestureDetector(
      onTap: () => widget.onInstallmentCountChanged(months),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: widget.isTablet ? 20 : 16,
          vertical: widget.isTablet ? 12 : 10,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            if (isSelected) ...[
              BoxShadow(
                color: AppColors.primary.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              IconsaxPlusBold.calendar,
              color: isSelected ? Colors.white : AppColors.textSecondary,
              size: widget.isTablet ? 18 : 16,
            ),
            SizedBox(width: 8),
            Text(
              '$months Months',
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: widget.isTablet ? 16 : 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewSection() {
    if (widget.isLoading) {
      return _buildLoadingPreview();
    }

    if (widget.preview == null) {
      return _buildEmptyPreview();
    }

    return _buildPreviewContent(widget.preview!);
  }

  Widget _buildLoadingPreview() {
    return Container(
      padding: EdgeInsets.all(widget.isTablet ? 20 : 16),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          SizedBox(
            width: widget.isTablet ? 24 : 20,
            height: widget.isTablet ? 24 : 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: widget.isTablet ? 16 : 12),
          Text(
            'Calculating installment preview...',
            style: TextStyle(
              fontSize: widget.isTablet ? 16 : 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyPreview() {
    return Container(
      padding: EdgeInsets.all(widget.isTablet ? 20 : 16),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(
            IconsaxPlusBold.info_circle,
            color: AppColors.textSecondary,
            size: widget.isTablet ? 24 : 20,
          ),
          SizedBox(width: widget.isTablet ? 16 : 12),
          Expanded(
            child: Text(
              'Select installment period to see preview',
              style: TextStyle(
                fontSize: widget.isTablet ? 16 : 14,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewContent(InstallmentPreview preview) {
    return Container(
      padding: EdgeInsets.all(widget.isTablet ? 20 : 16),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.success.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                IconsaxPlusBold.money_recive,
                color: AppColors.success,
                size: widget.isTablet ? 24 : 20,
              ),
              SizedBox(width: widget.isTablet ? 12 : 8),
              Text(
                'Installment Preview',
                style: TextStyle(
                  fontSize: widget.isTablet ? 18 : 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.success,
                ),
              ),
            ],
          ),
          SizedBox(height: widget.isTablet ? 16 : 12),
          _buildPreviewGrid(preview),
        ],
      ),
    );
  }

  Widget _buildPreviewGrid(InstallmentPreview preview) {
    final items = [
      {
        'label': 'Monthly Payment',
        'value': 'Rp ${preview.monthlyPayment.toStringAsFixed(0)}',
        'icon': IconsaxPlusBold.card,
        'highlight': true,
      },
      {
        'label': 'Total Interest',
        'value': 'Rp ${preview.totalInterest.toStringAsFixed(0)}',
        'icon': IconsaxPlusBold.percentage_circle,
        'highlight': false,
      },
      {
        'label': 'Total Amount',
        'value': 'Rp ${preview.totalAmount.toStringAsFixed(0)}',
        'icon': IconsaxPlusBold.receipt,
        'highlight': false,
      },
      {
        'label': 'Interest Rate',
        'value': '${(preview.interestRate * 100).toStringAsFixed(1)}% p.a.',
        'icon': IconsaxPlusBold.chart,
        'highlight': false,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.isTablet ? 2 : 1,
        childAspectRatio: widget.isTablet ? 3.5 : 4.5,
        crossAxisSpacing: widget.isTablet ? 16 : 12,
        mainAxisSpacing: widget.isTablet ? 12 : 8,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isHighlight = item['highlight'] as bool;

        return Container(
          padding: EdgeInsets.all(widget.isTablet ? 12 : 10),
          decoration: BoxDecoration(
            color: isHighlight
                ? AppColors.success.withOpacity(0.1)
                : Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isHighlight
                  ? AppColors.success.withOpacity(0.3)
                  : Colors.transparent,
            ),
          ),
          child: Row(
            children: [
              Icon(
                item['icon'] as IconData,
                color: isHighlight
                    ? AppColors.success
                    : AppColors.textSecondary,
                size: widget.isTablet ? 20 : 18,
              ),
              SizedBox(width: widget.isTablet ? 12 : 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item['label'] as String,
                      style: TextStyle(
                        fontSize: widget.isTablet ? 12 : 10,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      item['value'] as String,
                      style: TextStyle(
                        fontSize: widget.isTablet ? 14 : 12,
                        fontWeight: FontWeight.w600,
                        color: isHighlight
                            ? AppColors.success
                            : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

