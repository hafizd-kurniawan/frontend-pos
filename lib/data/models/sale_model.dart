import 'vehicle_model.dart';
import 'customer_model.dart';

class Sale {
  final int id;
  final int vehicleId;
  final int customerId;
  final String saleDate;
  final double totalAmount;
  final double downPayment;
  final double remainingAmount;
  final String paymentMethod;
  final String status;
  final String notes;
  final String createdAt;
  final String updatedAt;

  // Optional populated objects
  final Vehicle? vehicle;
  final Customer? customer;

  Sale({
    required this.id,
    required this.vehicleId,
    required this.customerId,
    required this.saleDate,
    required this.totalAmount,
    required this.downPayment,
    required this.remainingAmount,
    required this.paymentMethod,
    required this.status,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.vehicle,
    this.customer,
  });

  factory Sale.fromJson(Map<String, dynamic> json) {
    return Sale(
      id: json['id'] ?? 0,
      vehicleId: json['vehicle_id'] ?? 0,
      customerId: json['customer_id'] ?? 0,
      saleDate: json['sale_date'] ?? '',
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      downPayment: (json['down_payment'] ?? 0).toDouble(),
      remainingAmount: (json['remaining_amount'] ?? 0).toDouble(),
      paymentMethod: json['payment_method'] ?? '',
      status: json['status'] ?? '',
      notes: json['notes'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      vehicle: json['vehicle'] != null
          ? Vehicle.fromJson(json['vehicle'] as Map<String, dynamic>)
          : null,
      customer: json['customer'] != null
          ? Customer.fromJson(json['customer'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicle_id': vehicleId,
      'customer_id': customerId,
      'sale_date': saleDate,
      'total_amount': totalAmount,
      'down_payment': downPayment,
      'remaining_amount': remainingAmount,
      'payment_method': paymentMethod,
      'status': status,
      'notes': notes,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  Sale copyWith({
    int? id,
    int? vehicleId,
    int? customerId,
    String? saleDate,
    double? totalAmount,
    double? downPayment,
    double? remainingAmount,
    String? paymentMethod,
    String? status,
    String? notes,
    String? createdAt,
    String? updatedAt,
    Vehicle? vehicle,
    Customer? customer,
  }) {
    return Sale(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      customerId: customerId ?? this.customerId,
      saleDate: saleDate ?? this.saleDate,
      totalAmount: totalAmount ?? this.totalAmount,
      downPayment: downPayment ?? this.downPayment,
      remainingAmount: remainingAmount ?? this.remainingAmount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      vehicle: vehicle ?? this.vehicle,
      customer: customer ?? this.customer,
    );
  }
}
