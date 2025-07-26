import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../data/models/vehicle_model.dart';
import '../../../../data/models/customer_model.dart';
import '../../../../data/models/sales_model.dart';
import '../../../../presentation/providers/vehicle_provider.dart';
import '../../../../presentation/providers/sales_provider.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';

class SalesCreateScreen extends ConsumerStatefulWidget {
  const SalesCreateScreen({super.key});

  @override
  ConsumerState<SalesCreateScreen> createState() => _SalesCreateScreenState();
}

class _SalesCreateScreenState extends ConsumerState<SalesCreateScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _saleCodeController = TextEditingController();
  final _customerNameController = TextEditingController();
  final _customerPhoneController = TextEditingController();
  final _customerEmailController = TextEditingController();
  final _customerAddressController = TextEditingController();
  final _sellingPriceController = TextEditingController();
  final _downPaymentController = TextEditingController();
  final _notesController = TextEditingController();

  // Selected values
  Vehicle? _selectedVehicle;
  String _paymentMethod = 'cash';
  String _saleStatus = 'pending';
  DateTime _saleDate = DateTime.now();

  bool _isLoading = false;
  bool _isCustomerNew = true;

  @override
  void initState() {
    super.initState();
    _generateSaleCode();
    // Load available vehicles
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(vehicleListProvider.notifier).loadVehicles();
    });
  }

  void _generateSaleCode() {
    final now = DateTime.now();
    final code =
        'SAL${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${now.millisecond.toString().padLeft(3, '0')}';
    _saleCodeController.text = code;
  }

  @override
  void dispose() {
    _saleCodeController.dispose();
    _customerNameController.dispose();
    _customerPhoneController.dispose();
    _customerEmailController.dispose();
    _customerAddressController.dispose();
    _sellingPriceController.dispose();
    _downPaymentController.dispose();
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
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.sales, AppColors.sales.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.sales.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              IconsaxPlusBold.arrow_left,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '💰 Create New Sale',
                  style: AppTextStyles.displaySmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 32,
                  ),
                ),
                Text(
                  'Complete a vehicle sale transaction',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Icon(
                  IconsaxPlusBold.receipt_item,
                  color: Colors.white,
                  size: 32,
                ),
                const SizedBox(height: 8),
                Text(
                  'Sale Transaction',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection('📋 Sale Information', [
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _saleCodeController,
                      label: 'Sale Code',
                      hint: 'SAL202501001',
                      prefixIcon: IconsaxPlusBold.code,
                      enabled: false,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _buildDateField(
                      label: 'Sale Date',
                      value: _saleDate,
                      onChanged: (date) => setState(() => _saleDate = date),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildVehicleSelector(),
            ]),

            const SizedBox(height: 32),

            _buildSection('👤 Customer Information', [
              Row(
                children: [
                  Text(
                    'Customer Type:',
                    style: AppTextStyles.labelLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Row(
                    children: [
                      Radio<bool>(
                        value: true,
                        groupValue: _isCustomerNew,
                        onChanged: (value) =>
                            setState(() => _isCustomerNew = value!),
                      ),
                      Text('New Customer'),
                      const SizedBox(width: 16),
                      Radio<bool>(
                        value: false,
                        groupValue: _isCustomerNew,
                        onChanged: (value) =>
                            setState(() => _isCustomerNew = value!),
                      ),
                      Text('Existing Customer'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _customerNameController,
                      label: 'Customer Name',
                      hint: 'John Doe',
                      prefixIcon: IconsaxPlusBold.user,
                      validator: (value) => value?.isEmpty == true
                          ? 'Customer name is required'
                          : null,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _buildTextField(
                      controller: _customerPhoneController,
                      label: 'Phone Number',
                      hint: '+62812345678',
                      prefixIcon: IconsaxPlusBold.call,
                      keyboardType: TextInputType.phone,
                      validator: (value) => value?.isEmpty == true
                          ? 'Phone number is required'
                          : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _customerEmailController,
                      label: 'Email (Optional)',
                      hint: 'john@example.com',
                      prefixIcon: IconsaxPlusBold.sms,
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _buildTextField(
                      controller: _customerAddressController,
                      label: 'Address',
                      hint: 'Customer address...',
                      prefixIcon: IconsaxPlusBold.location,
                      validator: (value) =>
                          value?.isEmpty == true ? 'Address is required' : null,
                    ),
                  ),
                ],
              ),
            ]),

            const SizedBox(height: 32),

            _buildSection('💳 Payment Information', [
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _sellingPriceController,
                      label: 'Selling Price',
                      hint: '250000000',
                      prefixIcon: IconsaxPlusBold.money_send,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value?.isEmpty == true)
                          return 'Selling price is required';
                        final price = double.tryParse(value!);
                        if (price == null || price <= 0)
                          return 'Enter valid price';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _buildTextField(
                      controller: _downPaymentController,
                      label: 'Down Payment',
                      hint: '50000000',
                      prefixIcon: IconsaxPlusBold.money_recive,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value?.isEmpty == true)
                          return 'Down payment is required';
                        final downPayment = double.tryParse(value!);
                        if (downPayment == null || downPayment < 0)
                          return 'Enter valid down payment';

                        final sellingPrice = double.tryParse(
                          _sellingPriceController.text,
                        );
                        if (sellingPrice != null &&
                            downPayment > sellingPrice) {
                          return 'Down payment cannot exceed selling price';
                        }

                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildDropdown(
                      label: 'Payment Method',
                      value: _paymentMethod,
                      items: [
                        {'value': 'cash', 'label': 'Cash'},
                        {'value': 'financing', 'label': 'Financing'},
                        {'value': 'installment', 'label': 'Installment'},
                        {'value': 'trade_in', 'label': 'Trade In'},
                      ],
                      onChanged: (value) =>
                          setState(() => _paymentMethod = value!),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _buildDropdown(
                      label: 'Sale Status',
                      value: _saleStatus,
                      items: [
                        {'value': 'pending', 'label': 'Pending'},
                        {'value': 'completed', 'label': 'Completed'},
                        {'value': 'cancelled', 'label': 'Cancelled'},
                      ],
                      onChanged: (value) =>
                          setState(() => _saleStatus = value!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (_paymentMethod == 'cash' &&
                  _sellingPriceController.text.isNotEmpty &&
                  _downPaymentController.text.isNotEmpty)
                _buildPaymentSummary(),
            ]),

            const SizedBox(height: 32),

            _buildSection('📝 Additional Notes', [
              _buildTextField(
                controller: _notesController,
                label: 'Notes (Optional)',
                hint: 'Additional notes about the sale...',
                prefixIcon: IconsaxPlusBold.document_text,
                maxLines: 4,
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Vehicle',
          style: AppTextStyles.labelLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        Consumer(
          builder: (context, ref, child) {
            final vehicleState = ref.watch(vehicleListProvider);

            return vehicleState.when(
              data: (vehicles) {
                final availableVehicles = vehicles
                    .where((v) => v.availabilityStatus == 'available')
                    .toList();

                if (availableVehicles.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.warning.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          IconsaxPlusBold.warning_2,
                          color: AppColors.warning,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'No available vehicles for sale',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.warning,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(IconsaxPlusBold.car, color: AppColors.primary),
                            const SizedBox(width: 12),
                            Text(
                              _selectedVehicle != null
                                  ? '${_selectedVehicle!.brand} ${_selectedVehicle!.model} (${_selectedVehicle!.year})'
                                  : 'Select a vehicle to sell',
                              style: AppTextStyles.titleMedium.copyWith(
                                fontWeight: FontWeight.w600,
                                color: _selectedVehicle != null
                                    ? AppColors.primary
                                    : AppColors.textSecondary,
                              ),
                            ),
                            const Spacer(),
                            if (_selectedVehicle != null)
                              Text(
                                'Rp ${NumberFormat('#,###').format(_selectedVehicle!.sellingPrice)}',
                                style: AppTextStyles.titleMedium.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.success,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Container(
                        height: 200,
                        child: ListView.builder(
                          itemCount: availableVehicles.length,
                          itemBuilder: (context, index) {
                            final vehicle = availableVehicles[index];
                            final isSelected =
                                _selectedVehicle?.id == vehicle.id;

                            return ListTile(
                              selected: isSelected,
                              selectedTileColor: AppColors.primary.withOpacity(
                                0.1,
                              ),
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  IconsaxPlusBold.car,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                              ),
                              title: Text(
                                '${vehicle.brand} ${vehicle.model}',
                                style: AppTextStyles.titleMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                '${vehicle.year} • ${vehicle.color} • ${vehicle.vehicleCode}',
                                style: AppTextStyles.bodySmall,
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Rp ${NumberFormat('#,###').format(vehicle.sellingPrice)}',
                                    style: AppTextStyles.titleMedium.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.success,
                                    ),
                                  ),
                                  Text(
                                    vehicle.conditionStatus.toUpperCase(),
                                    style: AppTextStyles.labelSmall.copyWith(
                                      color: _getConditionColor(
                                        vehicle.conditionStatus,
                                      ),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                setState(() {
                                  _selectedVehicle = vehicle;
                                  _sellingPriceController.text = vehicle
                                      .sellingPrice
                                      .toString();
                                });
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
              loading: () => Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(child: CircularProgressIndicator()),
              ),
              error: (error, stack) => Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.error.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(IconsaxPlusBold.warning_2, color: AppColors.error),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Failed to load vehicles: ${error.toString()}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPaymentSummary() {
    final sellingPrice = double.tryParse(_sellingPriceController.text) ?? 0;
    final downPayment = double.tryParse(_downPaymentController.text) ?? 0;
    final remaining = sellingPrice - downPayment;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.success.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '💰 Payment Summary',
            style: AppTextStyles.titleLarge.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.success,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Selling Price:', style: AppTextStyles.bodyMedium),
              Text(
                'Rp ${NumberFormat('#,###').format(sellingPrice)}',
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Down Payment:', style: AppTextStyles.bodyMedium),
              Text(
                'Rp ${NumberFormat('#,###').format(downPayment)}',
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.info,
                ),
              ),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Remaining:',
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Rp ${NumberFormat('#,###').format(remaining)}',
                style: AppTextStyles.titleLarge.copyWith(
                  fontWeight: FontWeight.w700,
                  color: remaining > 0 ? AppColors.warning : AppColors.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getConditionColor(String condition) {
    switch (condition.toLowerCase()) {
      case 'excellent':
        return AppColors.success;
      case 'good':
        return AppColors.info;
      case 'fair':
        return AppColors.warning;
      case 'poor':
        return AppColors.error;
      default:
        return AppColors.textTertiary;
    }
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.headlineMedium.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 24,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 20),
        ...children,
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData prefixIcon,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          enabled: enabled,
          style: AppTextStyles.bodyLarge.copyWith(fontSize: 16),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(prefixIcon, color: AppColors.textTertiary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.error, width: 2),
            ),
            filled: true,
            fillColor: enabled ? Colors.white : AppColors.background,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<Map<String, String>> items,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Container(
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
              onChanged: onChanged,
              style: AppTextStyles.bodyLarge.copyWith(
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
              items: items.map((item) {
                return DropdownMenuItem<String>(
                  value: item['value'],
                  child: Text(item['label']!),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime value,
    required void Function(DateTime) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final selectedDate = await showDatePicker(
              context: context,
              initialDate: value,
              firstDate: DateTime.now().subtract(const Duration(days: 30)),
              lastDate: DateTime.now().add(const Duration(days: 30)),
            );
            if (selectedDate != null) {
              onChanged(selectedDate);
            }
          },
          child: Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Icon(IconsaxPlusBold.calendar, color: AppColors.textTertiary),
                const SizedBox(width: 12),
                Text(
                  DateFormat('dd MMM yyyy').format(value),
                  style: AppTextStyles.bodyLarge.copyWith(fontSize: 16),
                ),
                const Spacer(),
                Icon(
                  IconsaxPlusBold.arrow_down_1,
                  color: AppColors.textTertiary,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _isLoading ? null : () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                side: BorderSide(color: AppColors.border, width: 2),
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'Cancel',
                style: AppTextStyles.buttonLarge.copyWith(
                  fontSize: 18,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),

          const SizedBox(width: 20),

          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: _isLoading || _selectedVehicle == null
                  ? null
                  : _createSale,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.sales,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: _isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 2,
                      ),
                    )
                  : Icon(IconsaxPlusBold.money_send, size: 24),
              label: Text(
                _isLoading ? 'Creating Sale...' : 'Create Sale',
                style: AppTextStyles.buttonLarge.copyWith(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _createSale() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all required fields correctly'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_selectedVehicle == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a vehicle to sell'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Here you would create the sale via API
      // For now, just show success message

      await Future.delayed(const Duration(seconds: 2)); // Simulate API call

      // Update vehicle status to sold
      final updatedVehicle = _selectedVehicle!.copyWith(
        availabilityStatus: 'sold',
      );

      await ref
          .read(vehicleListProvider.notifier)
          .updateVehicle(updatedVehicle);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sale created successfully! Vehicle marked as sold.'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create sale: ${e.toString()}'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
