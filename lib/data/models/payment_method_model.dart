import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class PaymentMethod {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final bool supportsInstallments;
  final bool isActive;
  final String? color;

  PaymentMethod({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.supportsInstallments,
    this.isActive = true,
    this.color,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      icon: _getIconFromString(json['icon']),
      supportsInstallments: json['supports_installments'] ?? false,
      isActive: json['is_active'] ?? true,
      color: json['color'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': _getStringFromIcon(icon),
      'supports_installments': supportsInstallments,
      'is_active': isActive,
      'color': color,
    };
  }

  static IconData _getIconFromString(String? iconName) {
    switch (iconName) {
      case 'cash':
        return IconsaxPlusBold.money_recive;
      case 'transfer':
        return IconsaxPlusBold.card;
      case 'check':
        return IconsaxPlusBold.receipt_edit;
      case 'credit':
        return IconsaxPlusBold.receipt_minus;
      case 'financing':
        return IconsaxPlusBold.calculator;
      default:
        return IconsaxPlusBold.card;
    }
  }

  static String _getStringFromIcon(IconData icon) {
    if (icon == IconsaxPlusBold.money_recive) return 'cash';
    if (icon == IconsaxPlusBold.card) return 'transfer';
    if (icon == IconsaxPlusBold.receipt_edit) return 'check';
    if (icon == IconsaxPlusBold.receipt_minus) return 'credit';
    if (icon == IconsaxPlusBold.calculator) return 'financing';
    return 'card';
  }

  PaymentMethod copyWith({
    String? id,
    String? name,
    String? description,
    IconData? icon,
    bool? supportsInstallments,
    bool? isActive,
    String? color,
  }) {
    return PaymentMethod(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      supportsInstallments: supportsInstallments ?? this.supportsInstallments,
      isActive: isActive ?? this.isActive,
      color: color ?? this.color,
    );
  }

  // Static predefined payment methods for quick access
  static List<PaymentMethod> get defaultPaymentMethods => [
        PaymentMethod(
          id: 'cash',
          name: 'Cash Payment',
          description: 'Direct cash payment',
          icon: IconsaxPlusBold.money_recive,
          supportsInstallments: false,
          color: '#4CAF50',
        ),
        PaymentMethod(
          id: 'transfer',
          name: 'Bank Transfer',
          description: 'Electronic bank transfer',
          icon: IconsaxPlusBold.card,
          supportsInstallments: false,
          color: '#2196F3',
        ),
        PaymentMethod(
          id: 'check',
          name: 'Check Payment',
          description: 'Payment by check',
          icon: IconsaxPlusBold.receipt_edit,
          supportsInstallments: false,
          color: '#FF9800',
        ),
        PaymentMethod(
          id: 'credit',
          name: 'Credit/Financing',
          description: 'Installment payment plan',
          icon: IconsaxPlusBold.receipt_minus,
          supportsInstallments: true,
          color: '#9C27B0',
        ),
      ];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentMethod && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'PaymentMethod{id: $id, name: $name, supportsInstallments: $supportsInstallments}';
  }
}