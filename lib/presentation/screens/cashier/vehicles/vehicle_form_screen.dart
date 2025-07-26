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
import '../../../../presentation/providers/vehicle_provider.dart';

class VehicleFormScreen extends ConsumerStatefulWidget {
  final Vehicle? vehicle;

  const VehicleFormScreen({super.key, this.vehicle});

  @override
  ConsumerState<VehicleFormScreen> createState() => _VehicleFormScreenState();
}

class _VehicleFormScreenState extends ConsumerState<VehicleFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers - ORGANIZED
  final _vehicleCodeController = TextEditingController();
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();
  final _colorController = TextEditingController();
  final _engineTypeController = TextEditingController();
  final _chassisNumberController = TextEditingController();
  final _engineNumberController = TextEditingController();
  final _licensePlateController = TextEditingController();
  final _purchasePriceController = TextEditingController();
  final _sellingPriceController = TextEditingController();
  final _locationController = TextEditingController();
  final _mileageController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _featuresController = TextEditingController();

  // Dropdown values
  String _selectedTransmission = 'automatic';
  String _selectedFuelType = 'gasoline';
  String _selectedCondition = 'excellent';
  String _selectedStatus = 'available';
  int _selectedCategoryId = 1;

  bool _isLoading = false;
  bool get _isEditMode => widget.vehicle != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      _populateFields();
    } else {
      _generateVehicleCode();
    }
  }

  void _populateFields() {
    final vehicle = widget.vehicle!;
    _vehicleCodeController.text = vehicle.vehicleCode;
    _brandController.text = vehicle.brand;
    _modelController.text = vehicle.model;
    _yearController.text = vehicle.year.toString();
    _colorController.text = vehicle.color;
    _engineTypeController.text = vehicle.engineType;
    _chassisNumberController.text = vehicle.chassisNumber;
    _engineNumberController.text = vehicle.engineNumber;
    _licensePlateController.text = vehicle.licensePlate;
    _purchasePriceController.text = vehicle.purchasePrice.toString();
    _sellingPriceController.text = vehicle.sellingPrice.toString();
    _locationController.text = vehicle.location;
    _mileageController.text = vehicle.mileage.toString();
    _descriptionController.text = vehicle.description;
    _featuresController.text = vehicle.features?.join(', ') ?? '';

    _selectedTransmission = vehicle.transmission;
    _selectedFuelType = vehicle.fuelType;
    _selectedCondition = vehicle.conditionStatus;
    _selectedStatus = vehicle.availabilityStatus;
    _selectedCategoryId = vehicle.categoryId;
  }

  void _generateVehicleCode() {
    final now = DateTime.now();
    final code =
        'VHC${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${now.millisecond.toString().padLeft(3, '0')}';
    _vehicleCodeController.text = code;
  }

  @override
  void dispose() {
    // Dispose all controllers
    _vehicleCodeController.dispose();
    _brandController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _colorController.dispose();
    _engineTypeController.dispose();
    _chassisNumberController.dispose();
    _engineNumberController.dispose();
    _licensePlateController.dispose();
    _purchasePriceController.dispose();
    _sellingPriceController.dispose();
    _locationController.dispose();
    _mileageController.dispose();
    _descriptionController.dispose();
    _featuresController.dispose();
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
      padding: EdgeInsets.all(UiConstants.spacingMassive),
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
      child: Row(
        children: [
          _buildBackButton(),
          SizedBox(width: UiConstants.spacingLarge),
          Expanded(child: _buildHeaderText()),
          _buildModeIndicator(),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(UiConstants.radiusMedium),
      ),
      child: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(
          IconsaxPlusBold.arrow_left,
          color: Colors.white,
          size: UiConstants.iconLarge,
        ),
        padding: EdgeInsets.all(UiConstants.spacingMedium),
      ),
    );
  }

  Widget _buildHeaderText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _isEditMode ? '✏️ Edit Vehicle' : '➕ Add New Vehicle',
          style: AppTextStyles.displayMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: UiConstants.spacingTiny),
        Text(
          _isEditMode
              ? 'Update vehicle information in your inventory'
              : 'Add a new vehicle to your inventory system',
          style: AppTextStyles.bodyLarge.copyWith(
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildModeIndicator() {
    if (!_isEditMode) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: UiConstants.spacingLarge,
        vertical: UiConstants.spacingMedium,
      ),
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.15),
        borderRadius: BorderRadius.circular(UiConstants.radiusLarge),
        border: Border.all(
          color: AppColors.warning.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            IconsaxPlusBold.edit,
            size: UiConstants.iconMedium,
            color: AppColors.warning,
          ),
          SizedBox(width: UiConstants.spacingSmall),
          Text(
            'Edit Mode',
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.warning,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(UiConstants.spacingMassive),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBasicInfoSection(),
            SizedBox(height: UiConstants.sectionSpacing),
            _buildTechnicalSpecsSection(),
            SizedBox(height: UiConstants.sectionSpacing),
            _buildPricingStatusSection(),
            SizedBox(height: UiConstants.sectionSpacing),
            _buildLocationDetailsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return _buildFormSection(
      title: UiConstants.sectionTitles['basicInfo']!,
      children: [
        Row(
          children: [
            Expanded(
              child: buildStandardTextField(
                controller: _vehicleCodeController,
                label: 'Vehicle Code',
                placeholder: UiConstants.placeholders['vehicleCode']!,
                icon: IconsaxPlusBold.code,
                required: true,
                enabled: false, // Auto-generated
                size: TextFieldSize.medium,
                helperText: 'Automatically generated unique identifier',
              ),
            ),
            SizedBox(width: UiConstants.fieldSpacing),
            Expanded(child: _buildCategoryDropdown()),
          ],
        ),
        SizedBox(height: UiConstants.fieldSpacing),
        Row(
          children: [
            Expanded(
              child: buildStandardTextField(
                controller: _brandController,
                label: 'Vehicle Brand',
                placeholder: UiConstants.placeholders['vehicleBrand']!,
                icon: IconsaxPlusBold.car,
                required: true,
                size: TextFieldSize.medium,
                validator: (value) => value?.isEmpty == true
                    ? UiConstants.errorMessages['required']
                    : null,
              ),
            ),
            SizedBox(width: UiConstants.fieldSpacing),
            Expanded(
              child: buildStandardTextField(
                controller: _modelController,
                label: 'Vehicle Model',
                placeholder: UiConstants.placeholders['vehicleModel']!,
                icon: IconsaxPlusBold.car,
                required: true,
                size: TextFieldSize.medium,
                validator: (value) => value?.isEmpty == true
                    ? UiConstants.errorMessages['required']
                    : null,
              ),
            ),
          ],
        ),
        SizedBox(height: UiConstants.fieldSpacing),
        Row(
          children: [
            Expanded(
              child: buildStandardTextField(
                controller: _yearController,
                label: 'Manufacturing Year',
                placeholder: UiConstants.placeholders['vehicleYear']!,
                icon: IconsaxPlusBold.calendar,
                required: true,
                size: TextFieldSize.medium,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
                validator: _validateYear,
              ),
            ),
            SizedBox(width: UiConstants.fieldSpacing),
            Expanded(
              child: buildStandardTextField(
                controller: _colorController,
                label: 'Vehicle Color',
                placeholder: UiConstants.placeholders['vehicleColor']!,
                icon: IconsaxPlusBold.colorfilter,
                required: true,
                size: TextFieldSize.medium,
                validator: (value) => value?.isEmpty == true
                    ? UiConstants.errorMessages['required']
                    : null,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTechnicalSpecsSection() {
    return _buildFormSection(
      title: UiConstants.sectionTitles['technicalSpecs']!,
      children: [
        Row(
          children: [
            Expanded(
              child: buildStandardTextField(
                controller: _engineTypeController,
                label: 'Engine Type',
                placeholder: UiConstants.placeholders['engineType']!,
                icon: IconsaxPlusBold.setting_2,
                required: true,
                size: TextFieldSize.medium,
                validator: (value) => value?.isEmpty == true
                    ? UiConstants.errorMessages['required']
                    : null,
              ),
            ),
            SizedBox(width: UiConstants.fieldSpacing),
            Expanded(child: _buildTransmissionDropdown()),
            SizedBox(width: UiConstants.fieldSpacing),
            Expanded(child: _buildFuelTypeDropdown()),
          ],
        ),
        SizedBox(height: UiConstants.fieldSpacing),
        Row(
          children: [
            Expanded(
              child: buildStandardTextField(
                controller: _chassisNumberController,
                label: 'Chassis Number',
                placeholder: UiConstants.placeholders['chassisNumber']!,
                icon: IconsaxPlusBold.code,
                required: true,
                size: TextFieldSize.medium,
                validator: (value) => value?.isEmpty == true
                    ? UiConstants.errorMessages['required']
                    : null,
              ),
            ),
            SizedBox(width: UiConstants.fieldSpacing),
            Expanded(
              child: buildStandardTextField(
                controller: _engineNumberController,
                label: 'Engine Number',
                placeholder: UiConstants.placeholders['engineNumber']!,
                icon: IconsaxPlusBold.code,
                required: true,
                size: TextFieldSize.medium,
                validator: (value) => value?.isEmpty == true
                    ? UiConstants.errorMessages['required']
                    : null,
              ),
            ),
          ],
        ),
        SizedBox(height: UiConstants.fieldSpacing),
        buildStandardTextField(
          controller: _licensePlateController,
          label: 'License Plate Number',
          placeholder: UiConstants.placeholders['licensePlate']!,
          icon: IconsaxPlusBold.card,
          required: true,
          size: TextFieldSize.medium,
          validator: (value) => value?.isEmpty == true
              ? UiConstants.errorMessages['required']
              : null,
        ),
      ],
    );
  }

  Widget _buildPricingStatusSection() {
    return _buildFormSection(
      title: UiConstants.sectionTitles['pricingStatus']!,
      children: [
        Row(
          children: [
            Expanded(
              child: buildStandardTextField(
                controller: _purchasePriceController,
                label: 'Purchase Price (Rp)',
                placeholder: UiConstants.placeholders['purchasePrice']!,
                icon: IconsaxPlusBold.money_recive,
                required: true,
                size: TextFieldSize.medium,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: _validatePrice,
                helperText: 'Enter the amount paid to acquire this vehicle',
              ),
            ),
            SizedBox(width: UiConstants.fieldSpacing),
            Expanded(
              child: buildStandardTextField(
                controller: _sellingPriceController,
                label: 'Selling Price (Rp)',
                placeholder: UiConstants.placeholders['sellingPrice']!,
                icon: IconsaxPlusBold.money_send,
                required: true,
                size: TextFieldSize.medium,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: _validatePrice,
                helperText: 'Set the target selling price for customers',
              ),
            ),
          ],
        ),
        SizedBox(height: UiConstants.fieldSpacing),
        Row(
          children: [
            Expanded(child: _buildConditionDropdown()),
            SizedBox(width: UiConstants.fieldSpacing),
            Expanded(child: _buildStatusDropdown()),
          ],
        ),
      ],
    );
  }

  Widget _buildLocationDetailsSection() {
    return _buildFormSection(
      title: UiConstants.sectionTitles['locationDetails']!,
      children: [
        Row(
          children: [
            Expanded(
              child: buildStandardTextField(
                controller: _locationController,
                label: 'Storage Location',
                placeholder: UiConstants.placeholders['location']!,
                icon: IconsaxPlusBold.location,
                required: true,
                size: TextFieldSize.medium,
                validator: (value) => value?.isEmpty == true
                    ? UiConstants.errorMessages['required']
                    : null,
                helperText: 'Where is this vehicle currently stored?',
              ),
            ),
            SizedBox(width: UiConstants.fieldSpacing),
            Expanded(
              child: buildStandardTextField(
                controller: _mileageController,
                label: 'Odometer Reading (km)',
                placeholder: UiConstants.placeholders['mileage']!,
                icon: IconsaxPlusBold.speedometer,
                required: true,
                size: TextFieldSize.medium,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: _validateMileage,
                helperText: 'Current mileage shown on odometer',
              ),
            ),
          ],
        ),
        SizedBox(height: UiConstants.fieldSpacing),
        buildStandardTextField(
          controller: _featuresController,
          label: 'Vehicle Features',
          placeholder: UiConstants.placeholders['features']!,
          icon: IconsaxPlusBold.award,
          size: TextFieldSize.medium,
          maxLines: 2,
          helperText: 'List key features separated by commas',
        ),
        SizedBox(height: UiConstants.fieldSpacing),
        buildStandardTextField(
          controller: _descriptionController,
          label: 'Detailed Description',
          placeholder: UiConstants.placeholders['description']!,
          icon: IconsaxPlusBold.document_text,
          required: true,
          size: TextFieldSize.medium,
          maxLines: 4,
          maxLength: 500,
          showCounter: true,
          validator: (value) => value?.isEmpty == true
              ? UiConstants.errorMessages['required']
              : null,
          helperText:
              'Describe the vehicle condition, history, and notable details',
        ),
      ],
    );
  }

  Widget _buildFormSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(UiConstants.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(UiConstants.spacingHuge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTextStyles.sectionHeader),
            SizedBox(height: UiConstants.spacingXLarge),
            ...children,
          ],
        ),
      ),
    );
  }

  // Dropdown Builders
  Widget _buildCategoryDropdown() {
    return _buildStandardDropdown(
      label: 'Vehicle Category',
      value: _selectedCategoryId.toString(),
      items: [
        {'value': '1', 'label': 'Sedan'},
        {'value': '2', 'label': 'SUV'},
        {'value': '3', 'label': 'Hatchback'},
        {'value': '4', 'label': 'MPV'},
        {'value': '5', 'label': 'Pickup Truck'},
        {'value': '6', 'label': 'Convertible'},
        {'value': '7', 'label': 'Coupe'},
      ],
      onChanged: (value) =>
          setState(() => _selectedCategoryId = int.parse(value!)),
      icon: IconsaxPlusBold.category,
    );
  }

  Widget _buildTransmissionDropdown() {
    return _buildStandardDropdown(
      label: 'Transmission Type',
      value: _selectedTransmission,
      items: [
        {'value': 'automatic', 'label': 'Automatic'},
        {'value': 'manual', 'label': 'Manual'},
        {'value': 'cvt', 'label': 'CVT (Continuously Variable)'},
        {'value': 'semi_automatic', 'label': 'Semi-Automatic'},
      ],
      onChanged: (value) => setState(() => _selectedTransmission = value!),
      icon: IconsaxPlusBold.setting_2,
    );
  }

  Widget _buildFuelTypeDropdown() {
    return _buildStandardDropdown(
      label: 'Fuel Type',
      value: _selectedFuelType,
      items: [
        {'value': 'gasoline', 'label': 'Gasoline'},
        {'value': 'diesel', 'label': 'Diesel'},
        {'value': 'hybrid', 'label': 'Hybrid'},
        {'value': 'electric', 'label': 'Electric'},
        {'value': 'lpg', 'label': 'LPG'},
      ],
      onChanged: (value) => setState(() => _selectedFuelType = value!),
      icon: IconsaxPlusBold.gas_station,
    );
  }

  Widget _buildConditionDropdown() {
    return _buildStandardDropdown(
      label: 'Vehicle Condition',
      value: _selectedCondition,
      items: [
        {'value': 'excellent', 'label': 'Excellent - Like new condition'},
        {'value': 'good', 'label': 'Good - Minor wear, well maintained'},
        {'value': 'fair', 'label': 'Fair - Some wear, needs minor repairs'},
        {
          'value': 'poor',
          'label': 'Poor - Significant wear, needs major repairs',
        },
      ],
      onChanged: (value) => setState(() => _selectedCondition = value!),
      icon: IconsaxPlusBold.shield_tick,
    );
  }

  Widget _buildStatusDropdown() {
    return _buildStandardDropdown(
      label: 'Availability Status',
      value: _selectedStatus,
      items: [
        {'value': 'available', 'label': 'Available for Sale'},
        {'value': 'sold', 'label': 'Sold'},
        {'value': 'maintenance', 'label': 'Under Maintenance'},
        {'value': 'reserved', 'label': 'Reserved for Customer'},
        {'value': 'pending', 'label': 'Pending Documentation'},
      ],
      onChanged: (value) => setState(() => _selectedStatus = value!),
      icon: IconsaxPlusBold.status,
    );
  }

  Widget _buildStandardDropdown({
    required String label,
    required String value,
    required List<Map<String, String>> items,
    required void Function(String?) onChanged,
    required IconData icon,
    bool required = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: AppTextStyles.formLabel.copyWith(
                fontSize: UiConstants.textMedium,
              ),
            ),
            if (required) ...[
              SizedBox(width: UiConstants.spacingTiny),
              Text(
                '*',
                style: TextStyle(
                  color: AppColors.error,
                  fontSize: UiConstants.textMedium,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
        SizedBox(height: UiConstants.labelSpacing),
        Container(
          height: UiConstants.inputHeightMedium,
          padding: EdgeInsets.symmetric(horizontal: UiConstants.spacingLarge),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border, width: 1.5),
            borderRadius: BorderRadius.circular(UiConstants.radiusMedium),
            color: Colors.white,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: AppColors.textTertiary,
                size: UiConstants.iconMedium,
              ),
              SizedBox(width: UiConstants.spacingMedium),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: value,
                    isExpanded: true,
                    onChanged: onChanged,
                    style: AppTextStyles.inputText.copyWith(
                      fontSize: UiConstants.textMedium,
                    ),
                    icon: Icon(
                      IconsaxPlusBold.arrow_down_1,
                      color: AppColors.textTertiary,
                      size: UiConstants.iconSmall,
                    ),
                    items: items.map((item) {
                      return DropdownMenuItem<String>(
                        value: item['value'],
                        child: Text(
                          item['label']!,
                          style: AppTextStyles.inputText.copyWith(
                            fontSize: UiConstants.textMedium,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Validation Methods
  String? _validateYear(String? value) {
    if (value?.isEmpty == true) return UiConstants.errorMessages['required'];
    final year = int.tryParse(value!);
    if (year == null || year < 1980 || year > DateTime.now().year + 1) {
      return UiConstants.errorMessages['invalidYear'];
    }
    return null;
  }

  String? _validatePrice(String? value) {
    if (value?.isEmpty == true) return UiConstants.errorMessages['required'];
    final price = double.tryParse(value!);
    if (price == null || price <= 0)
      return UiConstants.errorMessages['invalidPrice'];
    return null;
  }

  String? _validateMileage(String? value) {
    if (value?.isEmpty == true) return UiConstants.errorMessages['required'];
    final mileage = double.tryParse(value!);
    if (mileage == null || mileage < 0)
      return UiConstants.errorMessages['invalidMileage'];
    return null;
  }

  Widget _buildActionButtons() {
    return Container(
      padding: EdgeInsets.all(UiConstants.spacingMassive),
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
      child: Row(
        children: [
          Expanded(
            child: buildSecondaryButton(
              text: UiConstants.buttons['cancel']!,
              onPressed: _isLoading ? null : () => Navigator.pop(context),
              icon: IconsaxPlusBold.arrow_left,
              size: ButtonSize.large,
              isFullWidth: true,
            ),
          ),
          SizedBox(width: UiConstants.spacingLarge),
          Expanded(
            flex: 2,
            child: buildPrimaryButton(
              text: _isLoading
                  ? (_isEditMode ? 'Updating Vehicle...' : 'Saving Vehicle...')
                  : (_isEditMode
                        ? UiConstants.buttons['update']!
                        : UiConstants.buttons['save']!),
              onPressed: _isLoading ? null : _saveVehicle,
              icon: _isEditMode ? IconsaxPlusBold.edit : IconsaxPlusBold.add,
              size: ButtonSize.large,
              isLoading: _isLoading,
              isFullWidth: true,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveVehicle() async {
    if (!_formKey.currentState!.validate()) {
      _showErrorSnackBar('Please fill all required fields correctly');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final features = _featuresController.text.isNotEmpty
          ? _featuresController.text.split(',').map((e) => e.trim()).toList()
          : <String>[];

      final vehicleData = Vehicle(
        id: _isEditMode ? widget.vehicle!.id : 0,
        vehicleCode: _vehicleCodeController.text,
        categoryId: _selectedCategoryId,
        category: null,
        brand: _brandController.text,
        model: _modelController.text,
        year: int.parse(_yearController.text),
        color: _colorController.text,
        engineType: _engineTypeController.text,
        transmission: _selectedTransmission,
        fuelType: _selectedFuelType,
        chassisNumber: _chassisNumberController.text,
        engineNumber: _engineNumberController.text,
        licensePlate: _licensePlateController.text,
        purchasePrice: double.parse(_purchasePriceController.text),
        sellingPrice: double.parse(_sellingPriceController.text),
        conditionStatus: _selectedCondition,
        availabilityStatus: _selectedStatus,
        location: _locationController.text,
        mileage: double.parse(_mileageController.text),
        description: _descriptionController.text,
        features: features,
        status: '',
        isActive: true,
        createdAt: _isEditMode ? widget.vehicle!.createdAt : DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (_isEditMode) {
        await ref.read(vehicleListProvider.notifier).updateVehicle(vehicleData);
        _showSuccessSnackBar(UiConstants.successMessages['vehicleUpdated']!);
      } else {
        await ref.read(vehicleListProvider.notifier).addVehicle(vehicleData);
        _showSuccessSnackBar(UiConstants.successMessages['vehicleCreated']!);
      }

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      _showErrorSnackBar('Failed to save vehicle: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSuccessSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(IconsaxPlusBold.tick_circle, color: Colors.white),
            SizedBox(width: UiConstants.spacingMedium),
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
            SizedBox(width: UiConstants.spacingMedium),
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
