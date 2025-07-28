import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class Customer {
  final int id;
  final String fullName;
  final String name;
  final String phone;
  final String? companyName;
  final String email;
  final String address;
  final String createdAt;
  final String updatedAt;

  // ERD fields sebagai optional (future-proof)
  final String? customerCode;
  final String? idCardNumber;
  final String? type;
  final int? createdBy;
  final bool? isActive;

  Customer({
    required this.id,
    required this.fullName,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    this.companyName, // ✅ ADD THIS - nullable
    required this.createdAt,
    required this.updatedAt,
    this.customerCode,
    this.idCardNumber,
    this.type,
    this.createdBy,
    this.isActive,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] ?? 0,
      fullName: json['full_name'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      companyName: json['company_name'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      // ERD fields optional
      customerCode: json['customer_code'],
      idCardNumber: json['id_card_number'],
      type: json['type'],
      createdBy: json['created_by'],
      isActive: json['is_active'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };

    // Only include ERD fields if they have values
    if (customerCode != null) data['customer_code'] = customerCode;
    if (idCardNumber != null) data['id_card_number'] = idCardNumber;
    if (type != null) data['type'] = type;
    if (createdBy != null) data['created_by'] = createdBy;
    if (isActive != null) data['is_active'] = isActive;

    return data;
  }

  Customer copyWith({
    int? id,
    String? name,
    String? phone,
    String? email,
    String? address,
    String? createdAt,
    String? updatedAt,
    String? customerCode,
    String? idCardNumber,
    String? type,
    int? createdBy,
    bool? isActive,
  }) {
    return Customer(
      id: id ?? this.id,
      name: name ?? this.name,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      companyName: companyName ?? this.companyName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      customerCode: customerCode ?? this.customerCode,
      idCardNumber: idCardNumber ?? this.idCardNumber,
      type: type ?? this.type,
      createdBy: createdBy ?? this.createdBy,
      isActive: isActive ?? this.isActive,
    );
  }
}

// Customer type enum
enum CustomerType { individual, corporate }

extension CustomerTypeExtension on CustomerType {
  String get value {
    switch (this) {
      case CustomerType.individual:
        return 'individual';
      case CustomerType.corporate:
        return 'corporate';
    }
  }
}
