import 'vehicle_model.dart';
import 'customer_model.dart';

class Sale {
  final int id;
  final String saleCode;
  final int vehicleId;
  final int customerId;
  final Vehicle? vehicle;
  final Customer? customer;
  final double sellingPrice;
  final double downPayment;
  final String paymentMethod;
  final String saleStatus;
  final DateTime saleDate;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  Sale({
    required this.id,
    required this.saleCode,
    required this.vehicleId,
    required this.customerId,
    this.vehicle,
    this.customer,
    required this.sellingPrice,
    required this.downPayment,
    required this.paymentMethod,
    required this.saleStatus,
    required this.saleDate,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Sale.fromJson(Map<String, dynamic> json) {
    return Sale(
      id: json['id'] ?? 0,
      saleCode: json['sale_code'] ?? '',
      vehicleId: json['vehicle_id'] ?? 0,
      customerId: json['customer_id'] ?? 0,
      vehicle: json['vehicle'] != null
          ? Vehicle.fromJson(json['vehicle'] as Map<String, dynamic>)
          : null,
      customer: json['customer'] != null
          ? Customer.fromJson(json['customer'] as Map<String, dynamic>)
          : null,
      sellingPrice: (json['selling_price'] ?? 0).toDouble(),
      downPayment: (json['down_payment'] ?? 0).toDouble(),
      paymentMethod: json['payment_method'] ?? '',
      saleStatus: json['sale_status'] ?? '',
      saleDate: json['sale_date'] != null
          ? DateTime.parse(json['sale_date'])
          : DateTime.now(),
      notes: json['notes'],
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
      'sale_code': saleCode,
      'vehicle_id': vehicleId,
      'customer_id': customerId,
      'selling_price': sellingPrice,
      'down_payment': downPayment,
      'payment_method': paymentMethod,
      'sale_status': saleStatus,
      'sale_date': saleDate.toIso8601String(),
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
