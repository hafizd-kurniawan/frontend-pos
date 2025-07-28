import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../data/models/installment_model.dart';
import '../../../../data/models/payment_method_model.dart';
import '../../../providers/installment_provider.dart';
import '../../widgets/installment/payment_method_card.dart';

class InstallmentPaymentScreen extends ConsumerStatefulWidget {
  final Installment installment;

  const InstallmentPaymentScreen({
    super.key,
    required this.installment,
  });

  @override
  ConsumerState<InstallmentPaymentScreen> createState() => _InstallmentPaymentScreenState();
}

class _InstallmentPaymentScreenState extends ConsumerState<InstallmentPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _referenceController = TextEditingController();
  final _notesController = TextEditingController();

  PaymentMethod? _selectedPaymentMethod;
  bool _isProcessing = false;

  bool get isTablet => MediaQuery.of(context).size.width >= 768;
  bool get isLargeTablet => MediaQuery.of(context).size.width >= 1024;

  EdgeInsets get responsivePadding => EdgeInsets.all(isTablet ? 24.0 : 16.0);
  double get responsiveSpacing => isTablet ? 20.0 : 16.0;
  double get responsiveCardPadding => isTablet ? 20.0 : 16.0;

  @override
  void initState() {
    super.initState();
    _amountController.text = widget.installment.remainingAmount.toStringAsFixed(0);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(installmentProvider.notifier).loadPaymentMethods();
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _referenceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildFormContent()),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
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
        child: Row(
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
                    '💳 Pay Installment',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: isTablet ? 28 : 20,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Process installment payment',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w500,
                      fontSize: isTablet ? 16 : 14,
                    ),
                  ),
                ],
              ),
            ),
            if (isTablet) _buildInstallmentInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildInstallmentInfo() {
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
            '#${widget.installment.installmentNumber}',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          Text(
            'Installment',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormContent() {
    return SingleChildScrollView(
      padding: responsivePadding,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildInstallmentDetailsCard(),
            SizedBox(height: responsiveSpacing),
            _buildPaymentMethodSection(),
            SizedBox(height: responsiveSpacing),
            _buildPaymentDetailsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildInstallmentDetailsCard() {
    final statusColor = _getStatusColor();
    
    return Container(
      padding: EdgeInsets.all(responsiveCardPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor.withOpacity(0.3)),
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
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(isTablet ? 12 : 8),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  IconsaxPlusBold.receipt_minus,
                  color: statusColor,
                  size: isTablet ? 24 : 20,
                ),
              ),
              SizedBox(width: responsiveSpacing),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Installment #${widget.installment.installmentNumber}',
                      style: TextStyle(
                        fontSize: isTablet ? 20 : 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Transaction #${widget.installment.transactionId}',
                      style: TextStyle(
                        fontSize: isTablet ? 14 : 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
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
                  widget.installment.statusDisplayName,
                  style: TextStyle(
                    fontSize: isTablet ? 12 : 10,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: responsiveSpacing),
          
          // Amount details
          Row(
            children: [
              Expanded(
                child: _buildDetailItem(
                  icon: IconsaxPlusBold.money_recive,
                  label: 'Total Amount',
                  value: 'Rp ${widget.installment.amount.toStringAsFixed(0)}',
                ),
              ),
              SizedBox(width: responsiveSpacing),
              Expanded(
                child: _buildDetailItem(
                  icon: IconsaxPlusBold.calendar,
                  label: 'Due Date',
                  value: DateFormat('dd MMM yyyy').format(widget.installment.dueDate),
                  isOverdue: widget.installment.isOverdue,
                ),
              ),
            ],
          ),
          
          if (widget.installment.paidAmount > 0) ...[
            SizedBox(height: responsiveSpacing),
            Row(
              children: [
                Expanded(
                  child: _buildDetailItem(
                    icon: IconsaxPlusBold.tick_circle,
                    label: 'Paid Amount',
                    value: 'Rp ${widget.installment.paidAmount.toStringAsFixed(0)}',
                  ),
                ),
                SizedBox(width: responsiveSpacing),
                Expanded(
                  child: _buildDetailItem(
                    icon: IconsaxPlusBold.money_send,
                    label: 'Remaining',
                    value: 'Rp ${widget.installment.remainingAmount.toStringAsFixed(0)}',
                    highlight: true,
                  ),
                ),
              ],
            ),
          ],
          
          // Overdue warning
          if (widget.installment.isOverdue) ...[
            SizedBox(height: responsiveSpacing),
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
                    size: isTablet ? 20 : 16,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'This installment is overdue by ${DateTime.now().difference(widget.installment.dueDate).inDays} days',
                      style: TextStyle(
                        fontSize: isTablet ? 14 : 12,
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
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
    bool isOverdue = false,
    bool highlight = false,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: isOverdue ? AppColors.error : 
                 highlight ? AppColors.primary : AppColors.textSecondary,
          size: isTablet ? 20 : 16,
        ),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: isTablet ? 12 : 10,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: isTablet ? 16 : 14,
                  fontWeight: FontWeight.w600,
                  color: isOverdue ? AppColors.error :
                         highlight ? AppColors.primary : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodSection() {
    final paymentMethods = ref.watch(paymentMethodsProvider);
    
    return Container(
      padding: EdgeInsets.all(responsiveCardPadding),
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
      child: PaymentMethodSelector(
        paymentMethods: paymentMethods.where((method) => !method.supportsInstallments).toList(),
        selectedPaymentMethodId: _selectedPaymentMethod?.id,
        onPaymentMethodSelected: (method) {
          setState(() {
            _selectedPaymentMethod = method;
          });
        },
        isTablet: isTablet,
        title: 'Select Payment Method',
      ),
    );
  }

  Widget _buildPaymentDetailsSection() {
    return Container(
      padding: EdgeInsets.all(responsiveCardPadding),
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
          Text(
            '💰 Payment Details',
            style: TextStyle(
              fontSize: isTablet ? 20 : 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: responsiveSpacing),
          
          // Payment amount
          CustomTextField(
            controller: _amountController,
            label: 'Payment Amount (Rp)',
            hint: 'Enter payment amount',
            prefixIcon: IconsaxPlusBold.money_recive,
            required: true,
            size: TextFieldSize.large,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: _validatePaymentAmount,
            helperText: 'Maximum: Rp ${widget.installment.remainingAmount.toStringAsFixed(0)}',
          ),
          
          SizedBox(height: responsiveSpacing),
          
          // Payment reference
          CustomTextField(
            controller: _referenceController,
            label: 'Payment Reference',
            hint: 'Receipt number, transaction ID, etc.',
            prefixIcon: IconsaxPlusBold.receipt,
            size: TextFieldSize.medium,
            helperText: 'Optional reference for tracking',
          ),
          
          SizedBox(height: responsiveSpacing),
          
          // Notes
          CustomTextField(
            controller: _notesController,
            label: 'Payment Notes',
            hint: 'Additional notes about this payment...',
            prefixIcon: IconsaxPlusBold.note,
            size: TextFieldSize.medium,
            maxLines: 3,
            helperText: 'Optional notes or comments',
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    final installmentState = ref.watch(installmentProvider);
    final canProcess = _selectedPaymentMethod != null && 
                      _amountController.text.isNotEmpty &&
                      !installmentState.isProcessingPayment;

    return Container(
      padding: responsivePadding,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: buildSecondaryButton(
                text: 'Cancel',
                onPressed: installmentState.isProcessingPayment
                    ? null
                    : () => Navigator.pop(context),
                icon: IconsaxPlusBold.close_circle,
                size: ButtonSize.large,
                isFullWidth: true,
              ),
            ),
            SizedBox(width: responsiveSpacing),
            Expanded(
              flex: 2,
              child: buildPrimaryButton(
                text: installmentState.isProcessingPayment
                    ? 'Processing...'
                    : 'Process Payment',
                onPressed: canProcess ? _processPayment : null,
                icon: IconsaxPlusBold.card,
                size: ButtonSize.large,
                isLoading: installmentState.isProcessingPayment,
                isFullWidth: true,
                backgroundColor: AppColors.success,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor() {
    try {
      return Color(int.parse(widget.installment.statusColor.replaceAll('#', '0xFF')));
    } catch (e) {
      switch (widget.installment.status) {
        case 'paid':
          return AppColors.success;
        case 'pending':
          return widget.installment.isOverdue ? AppColors.error : AppColors.warning;
        case 'overdue':
          return AppColors.error;
        case 'partially_paid':
          return AppColors.primary;
        default:
          return AppColors.textSecondary;
      }
    }
  }

  String? _validatePaymentAmount(String? value) {
    if (value?.isEmpty == true) return 'Payment amount is required';

    final amount = double.tryParse(value!);
    if (amount == null || amount <= 0) {
      return 'Please enter a valid amount';
    }

    if (amount > widget.installment.remainingAmount) {
      return 'Amount cannot exceed remaining balance';
    }

    return null;
  }

  Future<void> _processPayment() async {
    if (!_formKey.currentState!.validate()) {
      _showErrorSnackBar('Please fill all required fields correctly');
      return;
    }

    if (_selectedPaymentMethod == null) {
      _showErrorSnackBar('Please select a payment method');
      return;
    }

    final amount = double.tryParse(_amountController.text) ?? 0;
    
    final request = PayInstallmentRequest(
      amount: amount,
      paymentMethod: _selectedPaymentMethod!.id,
      paymentReference: _referenceController.text.trim().isEmpty 
          ? null 
          : _referenceController.text.trim(),
      notes: _notesController.text.trim().isEmpty 
          ? null 
          : _notesController.text.trim(),
    );

    final success = await ref.read(installmentProvider.notifier).payInstallment(
      widget.installment.transactionId,
      widget.installment.id,
      request,
    );

    if (success) {
      _showSuccessSnackBar('💰 Payment processed successfully!');
      Navigator.pop(context, true);
    } else {
      _showErrorSnackBar('❌ Failed to process payment. Please try again.');
    }
  }

  void _showSuccessSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(IconsaxPlusBold.tick_circle, color: Colors.white),
            SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(IconsaxPlusBold.warning_2, color: Colors.white),
            SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }
}