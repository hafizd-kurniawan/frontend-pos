import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/ui_constants.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../data/models/vehicle_model.dart';
import '../../../../data/models/customer_model.dart';
import '../../../../data/models/payment_method_model.dart';
import '../../../../data/models/installment_model.dart';
import '../../../providers/sales_provider.dart';
import '../../../providers/customer_provider.dart';
import '../../../providers/vehicle_provider.dart';
import '../../../providers/installment_provider.dart';
import '../../widgets/installment/payment_method_card.dart';
import '../../widgets/installment/installment_calculator.dart';

class SalesCreateScreen extends ConsumerStatefulWidget {
  final Vehicle? preSelectedVehicle;

  const SalesCreateScreen({super.key, this.preSelectedVehicle});

  @override
  ConsumerState<SalesCreateScreen> createState() => _SalesCreateScreenState();
}

class _SalesCreateScreenState extends ConsumerState<SalesCreateScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _customerSearchController = TextEditingController();
  final _vehicleSearchController = TextEditingController();
  final _downPaymentController = TextEditingController();
  final _notesController = TextEditingController();

  // Selected data
  Vehicle? _selectedVehicle;
  Customer? _selectedCustomer;
  PaymentMethod? _selectedPaymentMethod;
  int? _selectedInstallmentCount;

  // UI state
  bool _showCustomerSearch = false;
  bool _showVehicleSearch = false;
  bool _showNewCustomerForm = false;
  bool _isCreatingCustomer = false;

  // New customer form controllers
  final _newCustomerNameController = TextEditingController();
  final _newCustomerPhoneController = TextEditingController();
  final _newCustomerEmailController = TextEditingController();
  final _newCustomerAddressController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.preSelectedVehicle != null) {
      _selectedVehicle = widget.preSelectedVehicle;
      _vehicleSearchController.text =
          '${widget.preSelectedVehicle!.brand} ${widget.preSelectedVehicle!.model} ${widget.preSelectedVehicle!.year}';
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(customerProvider.notifier).loadCustomers();
      ref.read(installmentProvider.notifier).loadPaymentMethods();
      if (_selectedVehicle == null) {
        ref.read(vehicleListProvider.notifier).loadVehicles();
      }
    });
  }

  @override
  void dispose() {
    _customerSearchController.dispose();
    _vehicleSearchController.dispose();
    _downPaymentController.dispose();
    _notesController.dispose();
    _newCustomerNameController.dispose();
    _newCustomerPhoneController.dispose();
    _newCustomerEmailController.dispose();
    _newCustomerAddressController.dispose();
    super.dispose();
  }

  // ✅ RESPONSIVE HELPER METHODS
  bool get isTablet => MediaQuery.of(context).size.width >= 768;
  bool get isLargeTablet => MediaQuery.of(context).size.width >= 1024;

  EdgeInsets get responsivePadding => EdgeInsets.all(isTablet ? 24.0 : 16.0);
  double get responsiveSpacing => isTablet ? 20.0 : 16.0;
  double get responsiveCardPadding => isTablet ? 20.0 : 16.0;

  @override
  Widget build(BuildContext context) {
    // Listen to sales creation result
    ref.listen<SalesState>(salesProvider, (previous, next) {
      if (previous?.isCreating == true && next.isCreating == false) {
        if (next.error != null) {
          _showErrorSnackBar(next.error!);
        } else {
          _showSuccessSnackBar('🎉 Sale transaction completed successfully!');
          Navigator.pop(context, true);
        }
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildResponsiveHeader(),
          Expanded(child: _buildResponsiveFormContent()),
          _buildResponsiveActionButtons(),
        ],
      ),
    );
  }

  // ✅ RESPONSIVE HEADER
  Widget _buildResponsiveHeader() {
    return Container(
      padding: responsivePadding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.sales, AppColors.sales.withOpacity(0.9)],
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
      child: SafeArea(
        child: Row(
          children: [
            _buildBackButton(),
            SizedBox(width: responsiveSpacing),
            Expanded(child: _buildHeaderText()),
            if (isTablet) _buildTransactionInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Container(
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
    );
  }

  Widget _buildHeaderText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '💰 Create Sale Transaction',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: isTablet ? 28 : 20,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Complete a vehicle sale to customer',
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.w500,
            fontSize: isTablet ? 16 : 14,
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionInfo() {
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
          Icon(IconsaxPlusBold.receipt, size: 24, color: Colors.white),
          SizedBox(height: 8),
          Text(
            'Transaction',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          Text(
            DateTime.now().toString().substring(0, 10),
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ✅ RESPONSIVE FORM CONTENT
  Widget _buildResponsiveFormContent() {
    return SingleChildScrollView(
      padding: responsivePadding,
      child: Form(
        key: _formKey,
        child: isLargeTablet
            ? _buildTwoColumnLayout()
            : _buildSingleColumnLayout(),
      ),
    );
  }

  // ✅ TWO COLUMN LAYOUT FOR LARGE TABLETS
  Widget _buildTwoColumnLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              _buildVehicleSelectionSection(),
              SizedBox(height: responsiveSpacing),
              _buildPaymentDetailsSection(),
            ],
          ),
        ),
        SizedBox(width: responsiveSpacing),
        Expanded(
          child: Column(
            children: [
              _buildCustomerSelectionSection(),
              SizedBox(height: responsiveSpacing),
              _buildTransactionSummary(),
            ],
          ),
        ),
      ],
    );
  }

  // ✅ SINGLE COLUMN LAYOUT FOR PHONES/TABLETS
  Widget _buildSingleColumnLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildVehicleSelectionSection(),
        SizedBox(height: responsiveSpacing),
        _buildCustomerSelectionSection(),
        SizedBox(height: responsiveSpacing),
        _buildPaymentDetailsSection(),
        SizedBox(height: responsiveSpacing),
        _buildTransactionSummary(),
      ],
    );
  }

  // ✅ RESPONSIVE FORM SECTIONS
  Widget _buildFormSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
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
      child: Padding(
        padding: EdgeInsets.all(responsiveCardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: isTablet ? 20 : 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: responsiveSpacing),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleSelectionSection() {
    return _buildFormSection(
      title: '🚗 Vehicle Selection',
      children: [
        if (_selectedVehicle == null) ...[
          CustomTextField(
            controller: _vehicleSearchController,
            label: 'Search Vehicle',
            hint: 'Search by brand, model, year, or code...',
            prefixIcon: IconsaxPlusBold.search_normal,
            size: TextFieldSize.large,
            onChanged: (value) {
              if (value.length >= 2) {
                setState(() => _showVehicleSearch = true);
                Future.delayed(Duration(milliseconds: 300), () {
                  if (_vehicleSearchController.text == value &&
                      value.length >= 2) {
                    ref.read(vehicleListProvider.notifier).searchVehicles();
                  }
                });
              } else {
                setState(() => _showVehicleSearch = false);
              }
            },
          ),
          if (_showVehicleSearch) ...[
            SizedBox(height: responsiveSpacing),
            _buildVehicleSearchResults(),
          ],
        ] else ...[
          _buildSelectedVehicleCard(),
        ],
      ],
    );
  }

  Widget _buildVehicleSearchResults() {
    final vehicles = ref.watch(vehicleListProvider);
    final searchQuery = _vehicleSearchController.text.toLowerCase();

    return vehicles.when(
      data: (vehicleList) {
        final filteredVehicles = vehicleList.where((vehicle) {
          final brand = vehicle.brand.toLowerCase();
          final model = vehicle.model.toLowerCase();
          final year = vehicle.year.toString();
          final code = vehicle.vehicleCode.toLowerCase();
          final color = vehicle.color.toLowerCase();

          final matchesSearch =
              brand.contains(searchQuery) ||
              model.contains(searchQuery) ||
              year.contains(searchQuery) ||
              code.contains(searchQuery) ||
              color.contains(searchQuery);

          final isAvailable = vehicle.availabilityStatus == 'available';

          return matchesSearch && isAvailable;
        }).toList();

        return Container(
          constraints: BoxConstraints(maxHeight: isTablet ? 400 : 300),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: filteredVehicles.isEmpty
              ? _buildEmptyState('No vehicles found', IconsaxPlusBold.car)
              : ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: filteredVehicles.length,
                  itemBuilder: (context, index) {
                    return _buildVehicleSearchItem(filteredVehicles[index]);
                  },
                ),
        );
      },
      loading: () => _buildLoadingState('Searching vehicles...'),
      error: (error, stack) => _buildErrorState('Error loading vehicles'),
    );
  }

  Widget _buildVehicleSearchItem(Vehicle vehicle) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: EdgeInsets.all(12),
        tileColor: Colors.grey.withOpacity(0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: AppColors.border),
        ),
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            IconsaxPlusBold.car,
            color: AppColors.primary,
            size: isTablet ? 24 : 20,
          ),
        ),
        title: Text(
          '${vehicle.brand} ${vehicle.model} ${vehicle.year}',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: isTablet ? 16 : 14,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Code: ${vehicle.vehicleCode} • ${vehicle.color}',
              style: TextStyle(fontSize: isTablet ? 14 : 12),
            ),
            Text(
              'Price: Rp ${vehicle.sellingPrice.toStringAsFixed(0)}',
              style: TextStyle(
                color: AppColors.success,
                fontWeight: FontWeight.w600,
                fontSize: isTablet ? 14 : 12,
              ),
            ),
          ],
        ),
        trailing: Icon(
          IconsaxPlusBold.add_circle,
          color: AppColors.primary,
          size: isTablet ? 24 : 20,
        ),
        onTap: () {
          setState(() {
            _selectedVehicle = vehicle;
            _vehicleSearchController.text =
                '${vehicle.brand} ${vehicle.model} ${vehicle.year}';
            _showVehicleSearch = false;
          });
        },
      ),
    );
  }

  Widget _buildSelectedVehicleCard() {
    if (_selectedVehicle == null) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(responsiveCardPadding),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              IconsaxPlusBold.car,
              color: AppColors.primary,
              size: isTablet ? 28 : 24,
            ),
          ),
          SizedBox(width: responsiveSpacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_selectedVehicle!.brand} ${_selectedVehicle!.model} ${_selectedVehicle!.year}',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: isTablet ? 18 : 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Code: ${_selectedVehicle!.vehicleCode}',
                  style: TextStyle(fontSize: isTablet ? 14 : 12),
                ),
                Text(
                  'Color: ${_selectedVehicle!.color}',
                  style: TextStyle(fontSize: isTablet ? 14 : 12),
                ),
                SizedBox(height: 4),
                Text(
                  'Rp ${_selectedVehicle!.sellingPrice.toStringAsFixed(0)}',
                  style: TextStyle(
                    color: AppColors.success,
                    fontWeight: FontWeight.w700,
                    fontSize: isTablet ? 16 : 14,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _selectedVehicle = null;
                _vehicleSearchController.clear();
              });
            },
            icon: Icon(
              IconsaxPlusBold.close_circle,
              color: AppColors.error,
              size: isTablet ? 24 : 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerSelectionSection() {
    return _buildFormSection(
      title: '👤 Customer Information',
      children: [
        if (_selectedCustomer == null) ...[
          isTablet
              ? Row(
                  children: [
                    Expanded(flex: 3, child: _buildCustomerSearchField()),
                    SizedBox(width: responsiveSpacing),
                    _buildNewCustomerButton(),
                  ],
                )
              : Column(
                  children: [
                    _buildCustomerSearchField(),
                    SizedBox(height: responsiveSpacing),
                    _buildNewCustomerButton(),
                  ],
                ),
          if (_showCustomerSearch) ...[
            SizedBox(height: responsiveSpacing),
            _buildCustomerSearchResults(),
          ],
          if (_showNewCustomerForm) ...[
            SizedBox(height: responsiveSpacing),
            _buildNewCustomerForm(),
          ],
        ] else ...[
          _buildSelectedCustomerCard(),
        ],
      ],
    );
  }

  Widget _buildCustomerSearchField() {
    return CustomTextField(
      controller: _customerSearchController,
      label: 'Search Customer',
      hint: 'Type name, phone, or email...',
      prefixIcon: IconsaxPlusBold.search_normal,
      size: TextFieldSize.large,
      onChanged: (value) {
        if (value.length >= 2) {
          setState(() => _showCustomerSearch = true);
          Future.delayed(Duration(milliseconds: 300), () {
            if (_customerSearchController.text == value && value.length >= 2) {
              ref.read(customerProvider.notifier).searchCustomers(value);
            }
          });
        } else {
          setState(() => _showCustomerSearch = false);
        }
      },
    );
  }

  Widget _buildNewCustomerButton() {
    return SizedBox(
      width: isTablet ? 180 : double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: () =>
            setState(() => _showNewCustomerForm = !_showNewCustomerForm),
        icon: Icon(IconsaxPlusBold.user_add, size: 16),
        label: Text('New Customer', style: TextStyle(fontSize: 14)),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.success,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget _buildCustomerSearchResults() {
    final customerState = ref.watch(customerProvider);
    final searchQuery = _customerSearchController.text.toLowerCase();

    final filteredCustomers = customerState.customers.where((customer) {
      final name = customer.fullName.toLowerCase();
      final phone = customer.phone.toLowerCase();
      final email = customer.email.toLowerCase();

      return name.contains(searchQuery) ||
          phone.contains(searchQuery) ||
          email.contains(searchQuery);
    }).toList();

    return Container(
      constraints: BoxConstraints(maxHeight: isTablet ? 300 : 200),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: filteredCustomers.isEmpty
          ? _buildEmptyState('No customers found', IconsaxPlusBold.user)
          : ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: filteredCustomers.length,
              itemBuilder: (context, index) {
                return _buildCustomerSearchItem(filteredCustomers[index]);
              },
            ),
    );
  }

  Widget _buildCustomerSearchItem(Customer customer) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: EdgeInsets.all(12),
        tileColor: Colors.grey.withOpacity(0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: AppColors.border),
        ),
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.sales.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            IconsaxPlusBold.user,
            color: AppColors.sales,
            size: isTablet ? 20 : 18,
          ),
        ),
        title: Text(
          customer.fullName,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: isTablet ? 16 : 14,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              customer.phone,
              style: TextStyle(fontSize: isTablet ? 14 : 12),
            ),
            if (customer.email.isNotEmpty)
              Text(
                customer.email,
                style: TextStyle(fontSize: isTablet ? 14 : 12),
              ),
          ],
        ),
        trailing: Icon(
          IconsaxPlusBold.add_circle,
          color: AppColors.sales,
          size: isTablet ? 20 : 18,
        ),
        onTap: () {
          setState(() {
            _selectedCustomer = customer;
            _customerSearchController.text = customer.fullName;
            _showCustomerSearch = false;
            _showNewCustomerForm = false;
          });
        },
      ),
    );
  }

  Widget _buildSelectedCustomerCard() {
    if (_selectedCustomer == null) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(responsiveCardPadding),
      decoration: BoxDecoration(
        color: AppColors.sales.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.sales.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.sales.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              IconsaxPlusBold.user,
              color: AppColors.sales,
              size: isTablet ? 28 : 24,
            ),
          ),
          SizedBox(width: responsiveSpacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selectedCustomer!.fullName,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: isTablet ? 18 : 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  _selectedCustomer!.phone,
                  style: TextStyle(fontSize: isTablet ? 14 : 12),
                ),
                if (_selectedCustomer!.email.isNotEmpty)
                  Text(
                    _selectedCustomer!.email,
                    style: TextStyle(fontSize: isTablet ? 14 : 12),
                  ),
                if (_selectedCustomer!.address.isNotEmpty)
                  Text(
                    _selectedCustomer!.address,
                    style: TextStyle(
                      fontSize: isTablet ? 14 : 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _selectedCustomer = null;
                _customerSearchController.clear();
              });
            },
            icon: Icon(
              IconsaxPlusBold.close_circle,
              color: AppColors.error,
              size: isTablet ? 24 : 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewCustomerForm() {
    return Container(
      padding: EdgeInsets.all(responsiveCardPadding),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(IconsaxPlusBold.user_add, color: Colors.green, size: 20),
              SizedBox(width: 8),
              Text(
                'Create New Customer',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.green,
                  fontSize: isTablet ? 18 : 16,
                ),
              ),
            ],
          ),
          SizedBox(height: responsiveSpacing),
          isTablet
              ? Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _newCustomerNameController,
                        label: 'Full Name',
                        hint: 'Enter customer full name',
                        prefixIcon: IconsaxPlusBold.user,
                        required: true,
                        size: TextFieldSize.medium,
                      ),
                    ),
                    SizedBox(width: responsiveSpacing),
                    Expanded(
                      child: CustomTextField(
                        controller: _newCustomerPhoneController,
                        label: 'Phone Number',
                        hint: '+62812345678',
                        prefixIcon: IconsaxPlusBold.call,
                        required: true,
                        size: TextFieldSize.medium,
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    CustomTextField(
                      controller: _newCustomerNameController,
                      label: 'Full Name',
                      hint: 'Enter customer full name',
                      prefixIcon: IconsaxPlusBold.user,
                      required: true,
                      size: TextFieldSize.medium,
                    ),
                    SizedBox(height: responsiveSpacing),
                    CustomTextField(
                      controller: _newCustomerPhoneController,
                      label: 'Phone Number',
                      hint: '+62812345678',
                      prefixIcon: IconsaxPlusBold.call,
                      required: true,
                      size: TextFieldSize.medium,
                      keyboardType: TextInputType.phone,
                    ),
                  ],
                ),
          SizedBox(height: responsiveSpacing),
          CustomTextField(
            controller: _newCustomerEmailController,
            label: 'Email Address',
            hint: 'customer@email.com',
            prefixIcon: IconsaxPlusBold.sms,
            size: TextFieldSize.medium,
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: responsiveSpacing),
          CustomTextField(
            controller: _newCustomerAddressController,
            label: 'Address',
            hint: 'Enter complete address',
            prefixIcon: IconsaxPlusBold.location,
            required: true,
            size: TextFieldSize.medium,
            maxLines: 2,
          ),
          SizedBox(height: responsiveSpacing),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => setState(() => _showNewCustomerForm = false),
                  icon: Icon(IconsaxPlusBold.close_circle, size: 16),
                  label: Text('Cancel', style: TextStyle(fontSize: 14)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isCreatingCustomer ? null : _createNewCustomer,
                  icon: _isCreatingCustomer
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Icon(IconsaxPlusBold.user_add, size: 16),
                  label: Text(
                    _isCreatingCustomer ? 'Creating...' : 'Create',
                    style: TextStyle(fontSize: 14),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentDetailsSection() {
    final paymentMethods = ref.watch(paymentMethodsProvider);
    final installmentOptions = ref.watch(quickInstallmentOptionsProvider);
    final installmentPreview = ref.watch(installmentPreviewProvider);
    final installmentState = ref.watch(installmentProvider);

    return _buildFormSection(
      title: '💳 Payment Details',
      children: [
        // Payment Method Selection
        PaymentMethodSelector(
          paymentMethods: paymentMethods,
          selectedPaymentMethodId: _selectedPaymentMethod?.id,
          onPaymentMethodSelected: _onPaymentMethodSelected,
          isTablet: isTablet,
          title: 'Select Payment Method',
        ),
        
        SizedBox(height: responsiveSpacing),
        
        // Down Payment Field
        _buildDownPaymentField(),
        
        // Installment Calculator (only for credit/financing)
        if (_selectedPaymentMethod?.supportsInstallments == true && _selectedVehicle != null) ...[
          SizedBox(height: responsiveSpacing),
          InstallmentCalculator(
            vehiclePrice: _selectedVehicle!.sellingPrice,
            downPayment: double.tryParse(_downPaymentController.text) ?? 0,
            installmentOptions: installmentOptions,
            selectedInstallmentCount: _selectedInstallmentCount,
            onInstallmentCountChanged: _onInstallmentCountChanged,
            preview: installmentPreview,
            isLoading: installmentState.isLoadingPreview,
            isTablet: isTablet,
          ),
        ],
        
        SizedBox(height: responsiveSpacing),
        
        // Transaction Notes
        CustomTextField(
          controller: _notesController,
          label: 'Transaction Notes',
          hint: 'Add any additional notes for this transaction...',
          prefixIcon: IconsaxPlusBold.note,
          size: TextFieldSize.medium,
          maxLines: 3,
          helperText:
              'Optional notes about payment, delivery, or special conditions',
        ),
      ],
    );
  }

  // ✅ PAYMENT METHOD AND INSTALLMENT HANDLERS
  void _onPaymentMethodSelected(PaymentMethod paymentMethod) {
    setState(() {
      _selectedPaymentMethod = paymentMethod;
      _selectedInstallmentCount = null; // Reset installment selection
    });
    
    // Clear installment preview when payment method changes
    ref.read(installmentProvider.notifier).clearPreview();
  }

  void _onInstallmentCountChanged(int installmentCount) {
    setState(() {
      _selectedInstallmentCount = installmentCount;
    });
    
    // Calculate installment preview
    _calculateInstallmentPreview();
  }

  void _calculateInstallmentPreview() {
    if (_selectedVehicle == null || _selectedPaymentMethod == null || _selectedInstallmentCount == null) {
      return;
    }
    
    final downPayment = double.tryParse(_downPaymentController.text) ?? 0;
    final request = PaymentPreviewRequest(
      principal: _selectedVehicle!.sellingPrice,
      installmentCount: _selectedInstallmentCount!,
      downPayment: downPayment,
      paymentMethodId: _selectedPaymentMethod!.id,
    );
    
    ref.read(installmentProvider.notifier).calculatePaymentPreview(request);
  }

  Widget _buildDownPaymentField() {
    return CustomTextField(
      controller: _downPaymentController,
      label: 'Down Payment (Rp)',
      hint: 'Enter down payment amount',
      prefixIcon: IconsaxPlusBold.money_recive,
      required: true,
      size: TextFieldSize.large,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: _validateDownPayment,
      helperText: 'Minimum 10% of vehicle price',
      onChanged: (value) {
        // Recalculate installment preview when down payment changes
        if (_selectedPaymentMethod?.supportsInstallments == true && _selectedInstallmentCount != null) {
          _calculateInstallmentPreview();
        }
      },
    );
  }

  Widget _buildTransactionSummary() {
    if (_selectedVehicle == null) return const SizedBox.shrink();

    final vehiclePrice = _selectedVehicle!.sellingPrice;
    final downPayment = double.tryParse(_downPaymentController.text) ?? 0;
    final remainingAmount = vehiclePrice - downPayment;

    return _buildFormSection(
      title: '📋 Transaction Summary',
      children: [
        Container(
          padding: EdgeInsets.all(responsiveCardPadding),
          decoration: BoxDecoration(
            color: AppColors.success.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.success.withOpacity(0.3)),
          ),
          child: Column(
            children: [
              _buildSummaryRow(
                'Vehicle Price:',
                'Rp ${vehiclePrice.toStringAsFixed(0)}',
              ),
              SizedBox(height: 12),
              _buildSummaryRow(
                'Down Payment:',
                'Rp ${downPayment.toStringAsFixed(0)}',
              ),
              SizedBox(height: 12),
              Divider(color: AppColors.success.withOpacity(0.3)),
              SizedBox(height: 12),
              _buildSummaryRow(
                'Remaining Amount:',
                'Rp ${remainingAmount.toStringAsFixed(0)}',
                isTotal: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            fontSize: isTablet ? 16 : 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: isTotal ? AppColors.success : AppColors.textPrimary,
            fontSize: isTablet ? 16 : 14,
          ),
        ),
      ],
    );
  }

  // ✅ RESPONSIVE ACTION BUTTONS
  Widget _buildResponsiveActionButtons() {
    final salesState = ref.watch(salesListProvider);
    final canCreateSale =
        _selectedVehicle != null &&
        _selectedCustomer != null &&
        _selectedPaymentMethod != null &&
        _downPaymentController.text.isNotEmpty;

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
                onPressed: salesState.isCreating
                    ? null
                    : () => Navigator.pop(context),
                icon: IconsaxPlusBold.arrow_left,
                size: ButtonSize.large,
                isFullWidth: true,
              ),
            ),
            SizedBox(width: responsiveSpacing),
            Expanded(
              flex: 2,
              child: buildPrimaryButton(
                text: salesState.isCreating
                    ? 'Creating Sale...'
                    : 'Complete Sale',
                onPressed: canCreateSale && !salesState.isCreating
                    ? _completeSale
                    : null,
                icon: IconsaxPlusBold.tick_circle,
                size: ButtonSize.large,
                isLoading: salesState.isCreating,
                isFullWidth: true,
                backgroundColor: AppColors.success,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ HELPER WIDGETS
  Widget _buildEmptyState(String message, IconData icon) {
    return Container(
      padding: EdgeInsets.all(responsiveCardPadding),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: isTablet ? 48 : 32, color: Colors.grey),
            SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(
                color: Colors.grey,
                fontSize: isTablet ? 16 : 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState(String message) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(
                color: Colors.grey,
                fontSize: isTablet ? 16 : 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.error),
        borderRadius: BorderRadius.circular(8),
        color: Colors.red.withOpacity(0.1),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(IconsaxPlusBold.warning_2, color: AppColors.error),
            SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(
                color: AppColors.error,
                fontSize: isTablet ? 16 : 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ FIXED CREATE CUSTOMER WITH BETTER ERROR HANDLING
  Future<void> _createNewCustomer() async {
    print('🚀 Create Customer button clicked!');

    if (_newCustomerNameController.text.trim().isEmpty ||
        _newCustomerPhoneController.text.trim().isEmpty ||
        _newCustomerAddressController.text.trim().isEmpty) {
      print('❌ Validation failed');
      _showErrorSnackBar('Please fill all required customer fields');
      return;
    }

    print('✅ Validation passed, creating customer...');

    setState(() {
      _isCreatingCustomer = true;
    });

    try {
      print('📤 Sending POST request to create customer...');

      final success = await ref
          .read(customerProvider.notifier)
          .createCustomer(
            name: _newCustomerNameController.text.trim(),
            phone: _newCustomerPhoneController.text.trim(),
            email: _newCustomerEmailController.text.trim(),
            address: _newCustomerAddressController.text.trim(),
            companyName: null,
          );

      if (success) {
        print('✅ Customer created successfully via POST API');

        await Future.delayed(Duration(milliseconds: 1000));
        await ref.read(customerProvider.notifier).loadCustomers();

        final customerState = ref.read(customerProvider);
        final newCustomer = customerState.customers.firstWhere(
          (c) =>
              c.fullName == _newCustomerNameController.text.trim() &&
              c.phone == _newCustomerPhoneController.text.trim(),
          orElse: () => Customer(
            id: DateTime.now().millisecondsSinceEpoch,
            fullName: _newCustomerNameController.text.trim(),
            name: _newCustomerNameController.text.trim(),
            phone: _newCustomerPhoneController.text.trim(),
            email: _newCustomerEmailController.text.trim(),
            address: _newCustomerAddressController.text.trim(),
            companyName: null,
            createdAt: DateTime.now().toIso8601String(),
            updatedAt: DateTime.now().toIso8601String(),
          ),
        );

        setState(() {
          _selectedCustomer = newCustomer;
          _customerSearchController.text = newCustomer.fullName;
          _showNewCustomerForm = false;
          _showCustomerSearch = false;
          _isCreatingCustomer = false;
        });

        // Clear form
        _newCustomerNameController.clear();
        _newCustomerPhoneController.clear();
        _newCustomerEmailController.clear();
        _newCustomerAddressController.clear();

        print('✅ Customer selected and form cleared');
        _showSuccessSnackBar(
          '✅ Customer "${newCustomer.fullName}" created and saved to database!',
        );
      } else {
        print('❌ Failed to create customer via POST API');
        setState(() {
          _isCreatingCustomer = false;
        });
        _showErrorSnackBar(
          '❌ Failed to create customer. Please check your input and try again.',
        );
      }
    } catch (e) {
      print('❌ Error creating customer: $e');

      setState(() {
        _isCreatingCustomer = false;
      });

      if (e.toString().contains('Authentication failed')) {
        _showErrorSnackBar('❌ Session expired. Please login again.');
      } else {
        _showErrorSnackBar('❌ Error creating customer: $e');
      }
    }
  }

  Future<void> _completeSale() async {
    if (!_formKey.currentState!.validate()) {
      _showErrorSnackBar('Please fill all required fields correctly');
      return;
    }

    if (_selectedVehicle == null) {
      _showErrorSnackBar('Please select a vehicle');
      return;
    }

    if (_selectedCustomer == null) {
      _showErrorSnackBar('Please select or create a customer');
      return;
    }

    if (_selectedPaymentMethod == null) {
      _showErrorSnackBar('Please select a payment method');
      return;
    }

    final downPayment = double.tryParse(_downPaymentController.text) ?? 0;
    final vehiclePrice = _selectedVehicle!.sellingPrice;

    print('🚀 Creating sale transaction...');
    print('Vehicle ID: ${_selectedVehicle!.id}');
    print('Customer ID: ${_selectedCustomer!.id}');
    print('Total Amount: $vehiclePrice');
    print('Down Payment: $downPayment');
    print('Payment Method: ${_selectedPaymentMethod!.id}');
    print('Installment Count: $_selectedInstallmentCount');

    await ref
        .read(salesProvider.notifier)
        .createSale(
          vehicleId: _selectedVehicle!.id,
          customerId: _selectedCustomer!.id,
          totalAmount: vehiclePrice,
          downPayment: downPayment,
          paymentMethod: _selectedPaymentMethod!.id,
          notes: _notesController.text,
        );
  }

  String? _validateDownPayment(String? value) {
    if (value?.isEmpty == true) return 'Down payment is required';

    final downPayment = double.tryParse(value!);
    if (downPayment == null || downPayment <= 0) {
      return 'Please enter a valid amount';
    }

    if (_selectedVehicle != null) {
      final vehiclePrice = _selectedVehicle!.sellingPrice;
      final minDownPayment = vehiclePrice * 0.1; // 10% minimum

      if (downPayment < minDownPayment) {
        return 'Minimum down payment is Rp ${minDownPayment.toStringAsFixed(0)}';
      }

      if (downPayment > vehiclePrice) {
        return 'Down payment cannot exceed vehicle price';
      }
    }

    return null;
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
