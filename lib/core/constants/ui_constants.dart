class UiConstants {
  UiConstants._();

  // Text Sizes - STANDARDIZED
  static const double textTiny = 10.0;
  static const double textSmall = 12.0;
  static const double textBody = 14.0;
  static const double textMedium = 16.0;
  static const double textLarge = 18.0;
  static const double textXLarge = 20.0;
  static const double textTitle = 24.0;
  static const double textHeading = 28.0;
  static const double textDisplay = 32.0;

  // Icon Sizes - CONSISTENT
  static const double iconTiny = 12.0;
  static const double iconSmall = 16.0;
  static const double iconMedium = 20.0;
  static const double iconLarge = 24.0;
  static const double iconXLarge = 28.0;
  static const double iconHuge = 32.0;
  static const double iconMassive = 48.0;

  // Spacing - SYSTEMATIC
  static const double spacingTiny = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 12.0;
  static const double spacingLarge = 16.0;
  static const double spacingXLarge = 20.0;
  static const double spacingHuge = 24.0;
  static const double spacingMassive = 32.0;
  static const double spacingGiant = 40.0;
  static const double spacingSuper = 48.0;

  // Component Heights - CONSISTENT
  static const double buttonHeightSmall = 40.0;
  static const double buttonHeightMedium = 48.0;
  static const double buttonHeightLarge = 56.0;
  static const double inputHeightSmall = 40.0;
  static const double inputHeightMedium = 48.0;
  static const double inputHeightLarge = 56.0;
  static const double cardMinHeight = 200.0;
  static const double appBarHeight = 60.0;
  static const double bottomNavHeight = 60.0;

  // Border Radius - UNIFORM
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 20.0;
  static const double radiusHuge = 24.0;

  // Form Section Spacing
  static const double sectionSpacing = 32.0;
  static const double fieldSpacing = 20.0;
  static const double labelSpacing = 8.0;

  // CONSISTENT PLACEHOLDER TEXTS
  static const Map<String, String> placeholders = {
    // Vehicle placeholders - PROFESSIONAL & CLEAR
    'vehicleBrand': 'Enter vehicle brand (e.g., Toyota, Honda, Suzuki)',
    'vehicleModel': 'Enter model name (e.g., Avanza, CR-V, Swift)',
    'vehicleYear': 'Enter manufacturing year (e.g., 2023)',
    'vehicleColor': 'Enter color (e.g., Silver, White, Black)',
    'vehicleCode': 'Auto-generated unique vehicle code',
    'engineType': 'Enter engine specification (e.g., 1.5L I4, 2.0L V6)',
    'chassisNumber': 'Enter chassis/VIN number',
    'engineNumber': 'Enter engine serial number',
    'licensePlate': 'Enter license plate number (e.g., B1234ABC)',
    'purchasePrice': 'Enter purchase price in Rupiah (numbers only)',
    'sellingPrice': 'Enter selling price in Rupiah (numbers only)',
    'location': 'Enter storage location (e.g., Showroom A-1, Lot B-2)',
    'mileage': 'Enter odometer reading in kilometers',
    'features': 'Enter features separated by commas (e.g., AC, Power Steering)',
    'description': 'Enter detailed description including condition notes',

    // Customer placeholders - CLEAR INSTRUCTIONS
    'customerName': 'Enter customer full name',
    'customerPhone':
        'Enter phone number with country code (e.g., +62812345678)',
    'customerEmail': 'Enter email address (optional)',
    'customerAddress': 'Enter complete address including city',

    // Sales placeholders - BUSINESS TERMS
    'downPayment': 'Enter down payment amount in Rupiah',
    'saleNotes': 'Enter additional notes or special conditions',
    'paymentMethod': 'Select payment method',
    'saleStatus': 'Select transaction status',

    // Search placeholders - USER-FRIENDLY
    'searchVehicles': 'Search by brand, model, year, color, or vehicle code...',
    'searchCustomers': 'Search by name, phone number, or email address...',
    'searchSales': 'Search by customer name, vehicle, or transaction number...',
    'searchGeneral': 'Enter search keywords...',

    // Authentication
    'username': 'Enter your username',
    'password': 'Enter your password',

    // Filters
    'selectCondition': 'Select vehicle condition',
    'selectStatus': 'Select availability status',
    'selectCategory': 'Select vehicle category',
    'selectSortBy': 'Select sort criteria',
  };

  // CONSISTENT BUTTON LABELS
  static const Map<String, String> buttons = {
    // Primary Actions
    'save': 'Save',
    'cancel': 'Cancel',
    'submit': 'Submit',
    'update': 'Update Changes',
    'delete': 'Delete',
    'confirm': 'Confirm',
    'apply': 'Apply',
    'reset': 'Reset',

    // Navigation
    'back': 'Go Back',
    'next': 'Next',
    'previous': 'Previous',
    'close': 'Close',
    'done': 'Done',

    // CRUD Operations
    'create': 'Create New',
    'add': 'Add',
    'edit': 'Edit',
    'view': 'View Details',
    'remove': 'Remove',

    // Search & Filter
    'search': 'Search',
    'filter': 'Filter',
    'clearFilter': 'Clear Filters',
    'refresh': 'Refresh',
    'reload': 'Reload',

    // Vehicle Specific
    'addVehicle': 'Add New Vehicle',
    'editVehicle': 'Edit Vehicle',
    'deleteVehicle': 'Delete Vehicle',
    'sellVehicle': 'Sell Vehicle',
    'reserveVehicle': 'Reserve Vehicle',
    'markSold': 'Mark as Sold',
    'sendToMaintenance': 'Send to Maintenance',
    'markAvailable': 'Mark as Available',

    // Sales Specific
    'createSale': 'Create Sale',
    'completeSale': 'Complete Sale',
    'cancelSale': 'Cancel Sale',
    'printReceipt': 'Print Receipt',

    // Customer Specific
    'addCustomer': 'Add Customer',
    'selectCustomer': 'Select Customer',
    'editCustomer': 'Edit Customer',

    // Authentication
    'login': 'Sign In',
    'logout': 'Sign Out',
    'forgotPassword': 'Forgot Password?',
  };

  // STATUS LABELS - CONSISTENT NAMING
  static const Map<String, String> statusLabels = {
    // Vehicle Availability
    'available': 'Available for Sale',
    'sold': 'Sold',
    'maintenance': 'Under Maintenance',
    'reserved': 'Reserved',
    'pending': 'Pending',

    // Vehicle Condition
    'excellent': 'Excellent Condition',
    'good': 'Good Condition',
    'fair': 'Fair Condition',
    'poor': 'Poor Condition',

    // Sale Status
    'completed': 'Transaction Completed',
    'cancelled': 'Transaction Cancelled',
    'processing': 'Processing',

    // Payment Status
    'paid': 'Fully Paid',
    'partial': 'Partially Paid',
    'unpaid': 'Unpaid',
    'refunded': 'Refunded',
  };

  // SECTION TITLES - PROFESSIONAL
  static const Map<String, String> sectionTitles = {
    'basicInfo': '🚗 Basic Vehicle Information',
    'technicalSpecs': '🔧 Technical Specifications',
    'pricingStatus': '💰 Pricing & Status Information',
    'locationDetails': '📍 Location & Additional Details',
    'customerInfo': '👤 Customer Information',
    'paymentInfo': '💳 Payment Information',
    'saleInfo': '📋 Sale Information',
    'additionalNotes': '📝 Additional Notes',
  };

  // ERROR MESSAGES - USER-FRIENDLY
  static const Map<String, String> errorMessages = {
    'required': 'This field is required',
    'invalidEmail': 'Please enter a valid email address',
    'invalidPhone': 'Please enter a valid phone number',
    'invalidYear': 'Please enter a valid year (1980-2025)',
    'invalidPrice': 'Please enter a valid price amount',
    'invalidMileage': 'Please enter a valid mileage reading',
    'tooShort': 'This field is too short',
    'tooLong': 'This field is too long',
    'networkError': 'Network connection failed. Please check your internet.',
    'serverError': 'Server error occurred. Please try again later.',
    'unauthorized': 'Authentication required. Please login again.',
    'forbidden': 'You do not have permission to perform this action.',
    'notFound': 'The requested resource was not found.',
  };

  // SUCCESS MESSAGES - ENCOURAGING
  static const Map<String, String> successMessages = {
    'vehicleCreated': 'Vehicle added successfully to inventory!',
    'vehicleUpdated': 'Vehicle information updated successfully!',
    'vehicleDeleted': 'Vehicle removed from inventory successfully!',
    'saleCreated': 'Sale transaction completed successfully!',
    'customerCreated': 'Customer added successfully!',
    'loginSuccess': 'Welcome back! Login successful.',
    'logoutSuccess': 'You have been logged out successfully.',
    'dataRefreshed': 'Data refreshed successfully!',
  };
}
