class Vehicle {
  final int id;
  final String vehicleCode;
  final int categoryId;
  final VehicleCategory? category;
  final String brand;
  final String model;
  final int year;
  final String color;
  final String engineType;
  final String transmission;
  final String fuelType;
  final String chassisNumber;
  final String engineNumber;
  final String licensePlate;
  final double purchasePrice;
  final double sellingPrice;
  final String conditionStatus;
  final String availabilityStatus;
  final String location;
  final double mileage;
  final String description;
  final List<String>? features;
  final String status;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Vehicle({
    required this.id,
    required this.vehicleCode,
    required this.categoryId,
    this.category,
    required this.brand,
    required this.model,
    required this.year,
    required this.color,
    required this.engineType,
    required this.transmission,
    required this.fuelType,
    required this.chassisNumber,
    required this.engineNumber,
    required this.licensePlate,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.conditionStatus,
    required this.availabilityStatus,
    required this.location,
    required this.mileage,
    required this.description,
    this.features,
    required this.status,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  // FOR BACKWARD COMPATIBILITY - GETTER MAPPING
  String get make => brand; // brand -> make mapping
  double get price => sellingPrice; // sellingPrice -> price mapping
  String get condition =>
      conditionStatus; // conditionStatus -> condition mapping

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'] ?? 0,
      vehicleCode: json['vehicle_code'] ?? '',
      categoryId: json['category_id'] ?? 0,
      category: json['category'] != null
          ? VehicleCategory.fromJson(json['category'] as Map<String, dynamic>)
          : null,
      brand: json['brand'] ?? '',
      model: json['model'] ?? '',
      year: json['year'] ?? 0,
      color: json['color'] ?? '',
      engineType: json['engine_type'] ?? '',
      transmission: json['transmission'] ?? '',
      fuelType: json['fuel_type'] ?? '',
      chassisNumber: json['chassis_number'] ?? '',
      engineNumber: json['engine_number'] ?? '',
      licensePlate: json['license_plate'] ?? '',
      purchasePrice: (json['purchase_price'] ?? 0).toDouble(),
      sellingPrice: (json['selling_price'] ?? 0).toDouble(),
      conditionStatus: json['condition_status'] ?? '',
      availabilityStatus: json['availability_status'] ?? '',
      location: json['location'] ?? '',
      mileage: (json['mileage'] ?? 0).toDouble(),
      description: json['description'] ?? '',
      features: json['features'] != null
          ? List<String>.from(json['features'] as List)
          : null,
      status: json['status'] ?? '',
      isActive: json['is_active'] ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicle_code': vehicleCode,
      'category_id': categoryId,
      'category': category?.toJson(),
      'brand': brand,
      'model': model,
      'year': year,
      'color': color,
      'engine_type': engineType,
      'transmission': transmission,
      'fuel_type': fuelType,
      'chassis_number': chassisNumber,
      'engine_number': engineNumber,
      'license_plate': licensePlate,
      'purchase_price': purchasePrice,
      'selling_price': sellingPrice,
      'condition_status': conditionStatus,
      'availability_status': availabilityStatus,
      'location': location,
      'mileage': mileage,
      'description': description,
      'features': features,
      'status': status,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Vehicle copyWith({
    int? id,
    String? vehicleCode,
    int? categoryId,
    VehicleCategory? category,
    String? brand,
    String? model,
    int? year,
    String? color,
    String? engineType,
    String? transmission,
    String? fuelType,
    String? chassisNumber,
    String? engineNumber,
    String? licensePlate,
    double? purchasePrice,
    double? sellingPrice,
    String? conditionStatus,
    String? availabilityStatus,
    String? location,
    double? mileage,
    String? description,
    List<String>? features,
    String? status,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Vehicle(
      id: id ?? this.id,
      vehicleCode: vehicleCode ?? this.vehicleCode,
      categoryId: categoryId ?? this.categoryId,
      category: category ?? this.category,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      year: year ?? this.year,
      color: color ?? this.color,
      engineType: engineType ?? this.engineType,
      transmission: transmission ?? this.transmission,
      fuelType: fuelType ?? this.fuelType,
      chassisNumber: chassisNumber ?? this.chassisNumber,
      engineNumber: engineNumber ?? this.engineNumber,
      licensePlate: licensePlate ?? this.licensePlate,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      conditionStatus: conditionStatus ?? this.conditionStatus,
      availabilityStatus: availabilityStatus ?? this.availabilityStatus,
      location: location ?? this.location,
      mileage: mileage ?? this.mileage,
      description: description ?? this.description,
      features: features ?? this.features,
      status: status ?? this.status,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Vehicle(id: $id, brand: $brand, model: $model, year: $year, price: $sellingPrice)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Vehicle && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

// Vehicle Category Model
class VehicleCategory {
  final int id;
  final String name;
  final String description;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  VehicleCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory VehicleCategory.fromJson(Map<String, dynamic> json) {
    return VehicleCategory(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      isActive: json['is_active'] ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

// Vehicle Status Enum
enum VehicleStatus { available, sold, maintenance, reserved }

extension VehicleStatusExtension on VehicleStatus {
  String get value {
    switch (this) {
      case VehicleStatus.available:
        return 'available';
      case VehicleStatus.sold:
        return 'sold';
      case VehicleStatus.maintenance:
        return 'maintenance';
      case VehicleStatus.reserved:
        return 'reserved';
    }
  }

  String get displayName {
    switch (this) {
      case VehicleStatus.available:
        return 'Available';
      case VehicleStatus.sold:
        return 'Sold';
      case VehicleStatus.maintenance:
        return 'Maintenance';
      case VehicleStatus.reserved:
        return 'Reserved';
    }
  }
}

// Vehicle Condition Enum
enum VehicleCondition { excellent, good, fair, poor }

extension VehicleConditionExtension on VehicleCondition {
  String get value {
    switch (this) {
      case VehicleCondition.excellent:
        return 'excellent';
      case VehicleCondition.good:
        return 'good';
      case VehicleCondition.fair:
        return 'fair';
      case VehicleCondition.poor:
        return 'poor';
    }
  }

  String get displayName {
    switch (this) {
      case VehicleCondition.excellent:
        return 'Excellent';
      case VehicleCondition.good:
        return 'Good';
      case VehicleCondition.fair:
        return 'Fair';
      case VehicleCondition.poor:
        return 'Poor';
    }
  }
}
