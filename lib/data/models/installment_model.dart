class InstallmentSchedule {
  final int installmentNumber;
  final DateTime dueDate;
  final double amount;
  final double principalAmount;
  final double interestAmount;
  final String status;

  InstallmentSchedule({
    required this.installmentNumber,
    required this.dueDate,
    required this.amount,
    required this.principalAmount,
    required this.interestAmount,
    this.status = 'pending',
  });

  factory InstallmentSchedule.fromJson(Map<String, dynamic> json) {
    return InstallmentSchedule(
      installmentNumber: json['installment_number'] ?? 0,
      dueDate: DateTime.parse(json['due_date'] ?? DateTime.now().toIso8601String()),
      amount: (json['amount'] ?? 0).toDouble(),
      principalAmount: (json['principal_amount'] ?? 0).toDouble(),
      interestAmount: (json['interest_amount'] ?? 0).toDouble(),
      status: json['status'] ?? 'pending',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'installment_number': installmentNumber,
      'due_date': dueDate.toIso8601String(),
      'amount': amount,
      'principal_amount': principalAmount,
      'interest_amount': interestAmount,
      'status': status,
    };
  }

  InstallmentSchedule copyWith({
    int? installmentNumber,
    DateTime? dueDate,
    double? amount,
    double? principalAmount,
    double? interestAmount,
    String? status,
  }) {
    return InstallmentSchedule(
      installmentNumber: installmentNumber ?? this.installmentNumber,
      dueDate: dueDate ?? this.dueDate,
      amount: amount ?? this.amount,
      principalAmount: principalAmount ?? this.principalAmount,
      interestAmount: interestAmount ?? this.interestAmount,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return 'InstallmentSchedule{installmentNumber: $installmentNumber, dueDate: $dueDate, amount: $amount}';
  }
}

class InstallmentPreview {
  final double monthlyPayment;
  final double totalInterest;
  final double totalAmount;
  final int installmentCount;
  final double interestRate;
  final List<InstallmentSchedule> schedule;

  InstallmentPreview({
    required this.monthlyPayment,
    required this.totalInterest,
    required this.totalAmount,
    required this.installmentCount,
    required this.interestRate,
    required this.schedule,
  });

  factory InstallmentPreview.fromJson(Map<String, dynamic> json) {
    return InstallmentPreview(
      monthlyPayment: (json['monthly_payment'] ?? 0).toDouble(),
      totalInterest: (json['total_interest'] ?? 0).toDouble(),
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      installmentCount: json['installment_count'] ?? 0,
      interestRate: (json['interest_rate'] ?? 0).toDouble(),
      schedule: (json['schedule'] as List<dynamic>?)
              ?.map((item) => InstallmentSchedule.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'monthly_payment': monthlyPayment,
      'total_interest': totalInterest,
      'total_amount': totalAmount,
      'installment_count': installmentCount,
      'interest_rate': interestRate,
      'schedule': schedule.map((item) => item.toJson()).toList(),
    };
  }

  InstallmentPreview copyWith({
    double? monthlyPayment,
    double? totalInterest,
    double? totalAmount,
    int? installmentCount,
    double? interestRate,
    List<InstallmentSchedule>? schedule,
  }) {
    return InstallmentPreview(
      monthlyPayment: monthlyPayment ?? this.monthlyPayment,
      totalInterest: totalInterest ?? this.totalInterest,
      totalAmount: totalAmount ?? this.totalAmount,
      installmentCount: installmentCount ?? this.installmentCount,
      interestRate: interestRate ?? this.interestRate,
      schedule: schedule ?? this.schedule,
    );
  }

  @override
  String toString() {
    return 'InstallmentPreview{monthlyPayment: $monthlyPayment, totalAmount: $totalAmount, installmentCount: $installmentCount}';
  }
}

class Installment {
  final int id;
  final int transactionId;
  final int installmentNumber;
  final DateTime dueDate;
  final double amount;
  final double paidAmount;
  final String status; // pending, paid, overdue, partially_paid
  final DateTime? paidAt;
  final String? paymentMethod;
  final String? paymentReference;
  final String? notes;
  final double principalAmount;
  final double interestAmount;
  final double penaltyAmount;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  // Customer information (populated from transaction/sale)
  final int? customerId;
  final String? customerName;
  final String? customerPhone;
  final String? customerEmail;
  final String? customerAddress;
  final String? customerType; // individual, corporate
  
  // Transaction/Sale information
  final String? saleDate;
  final double? totalSaleAmount;
  final double? downPayment;
  final String? vehicleInfo; // e.g., "Honda Civic 2023"

  Installment({
    required this.id,
    required this.transactionId,
    required this.installmentNumber,
    required this.dueDate,
    required this.amount,
    this.paidAmount = 0.0,
    this.status = 'pending',
    this.paidAt,
    this.paymentMethod,
    this.paymentReference,
    this.notes,
    this.principalAmount = 0.0,
    this.interestAmount = 0.0,
    this.penaltyAmount = 0.0,
    required this.createdAt,
    required this.updatedAt,
    // Customer information
    this.customerId,
    this.customerName,
    this.customerPhone,
    this.customerEmail,
    this.customerAddress,
    this.customerType,
    // Transaction information
    this.saleDate,
    this.totalSaleAmount,
    this.downPayment,
    this.vehicleInfo,
  });

  factory Installment.fromJson(Map<String, dynamic> json) {
    return Installment(
      id: json['id'] ?? 0,
      transactionId: json['transaction_id'] ?? 0,
      installmentNumber: json['installment_number'] ?? 0,
      dueDate: DateTime.parse(json['due_date'] ?? DateTime.now().toIso8601String()),
      amount: (json['amount'] ?? 0).toDouble(),
      paidAmount: (json['paid_amount'] ?? 0).toDouble(),
      status: json['status'] ?? 'pending',
      paidAt: json['paid_at'] != null ? DateTime.parse(json['paid_at']) : null,
      paymentMethod: json['payment_method'],
      paymentReference: json['payment_reference'],
      notes: json['notes'],
      principalAmount: (json['principal_amount'] ?? 0).toDouble(),
      interestAmount: (json['interest_amount'] ?? 0).toDouble(),
      penaltyAmount: (json['penalty_amount'] ?? 0).toDouble(),
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
      // Customer information
      customerId: json['customer_id'],
      customerName: json['customer_name'],
      customerPhone: json['customer_phone'],
      customerEmail: json['customer_email'],
      customerAddress: json['customer_address'],
      customerType: json['customer_type'],
      // Transaction information  
      saleDate: json['sale_date'],
      totalSaleAmount: json['total_sale_amount'] != null ? (json['total_sale_amount']).toDouble() : null,
      downPayment: json['down_payment'] != null ? (json['down_payment']).toDouble() : null,
      vehicleInfo: json['vehicle_info'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transaction_id': transactionId,
      'installment_number': installmentNumber,
      'due_date': dueDate.toIso8601String(),
      'amount': amount,
      'paid_amount': paidAmount,
      'status': status,
      'paid_at': paidAt?.toIso8601String(),
      'payment_method': paymentMethod,
      'payment_reference': paymentReference,
      'notes': notes,
      'principal_amount': principalAmount,
      'interest_amount': interestAmount,
      'penalty_amount': penaltyAmount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      // Customer information
      'customer_id': customerId,
      'customer_name': customerName,
      'customer_phone': customerPhone,
      'customer_email': customerEmail,
      'customer_address': customerAddress,
      'customer_type': customerType,
      // Transaction information
      'sale_date': saleDate,
      'total_sale_amount': totalSaleAmount,
      'down_payment': downPayment,
      'vehicle_info': vehicleInfo,
    };
  }

  Installment copyWith({
    int? id,
    int? transactionId,
    int? installmentNumber,
    DateTime? dueDate,
    double? amount,
    double? paidAmount,
    String? status,
    DateTime? paidAt,
    String? paymentMethod,
    String? paymentReference,
    String? notes,
    double? principalAmount,
    double? interestAmount,
    double? penaltyAmount,
    DateTime? createdAt,
    DateTime? updatedAt,
    // Customer information
    int? customerId,
    String? customerName,
    String? customerPhone,
    String? customerEmail,
    String? customerAddress,
    String? customerType,
    // Transaction information
    String? saleDate,
    double? totalSaleAmount,
    double? downPayment,
    String? vehicleInfo,
  }) {
    return Installment(
      id: id ?? this.id,
      transactionId: transactionId ?? this.transactionId,
      installmentNumber: installmentNumber ?? this.installmentNumber,
      dueDate: dueDate ?? this.dueDate,
      amount: amount ?? this.amount,
      paidAmount: paidAmount ?? this.paidAmount,
      status: status ?? this.status,
      paidAt: paidAt ?? this.paidAt,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentReference: paymentReference ?? this.paymentReference,
      notes: notes ?? this.notes,
      principalAmount: principalAmount ?? this.principalAmount,
      interestAmount: interestAmount ?? this.interestAmount,
      penaltyAmount: penaltyAmount ?? this.penaltyAmount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      // Customer information
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerEmail: customerEmail ?? this.customerEmail,
      customerAddress: customerAddress ?? this.customerAddress,
      customerType: customerType ?? this.customerType,
      // Transaction information
      saleDate: saleDate ?? this.saleDate,
      totalSaleAmount: totalSaleAmount ?? this.totalSaleAmount,
      downPayment: downPayment ?? this.downPayment,
      vehicleInfo: vehicleInfo ?? this.vehicleInfo,
    );
  }

  // Helper getters
  bool get isOverdue => DateTime.now().isAfter(dueDate) && status == 'pending';
  bool get isPaid => status == 'paid';
  bool get isPending => status == 'pending';
  bool get isPartiallyPaid => status == 'partially_paid';
  double get remainingAmount => amount - paidAmount;
  
  // Customer helper getters
  bool get hasCustomerInfo => customerId != null && customerName != null;
  String get customerDisplayName => customerName ?? 'Unknown Customer';
  String get customerContactInfo {
    if (customerPhone != null && customerEmail != null) {
      return '$customerPhone • $customerEmail';
    } else if (customerPhone != null) {
      return customerPhone!;
    } else if (customerEmail != null) {
      return customerEmail!;
    }
    return 'No contact info';
  }
  
  // Transaction helper getters
  String get transactionDisplayInfo {
    final parts = <String>[];
    if (vehicleInfo != null) parts.add(vehicleInfo!);
    if (saleDate != null) parts.add('Sale: $saleDate');
    return parts.isNotEmpty ? parts.join(' • ') : 'Transaction #$transactionId';
  }
  
  String get paymentProgress {
    if (totalSaleAmount != null && downPayment != null) {
      final progress = (paidAmount + downPayment!) / totalSaleAmount! * 100;
      return '${progress.toStringAsFixed(1)}%';
    }
    return 'N/A';
  }

  // Status color helpers
  String get statusColor {
    switch (status) {
      case 'paid':
        return '#4CAF50';
      case 'pending':
        return isOverdue ? '#F44336' : '#FF9800';
      case 'overdue':
        return '#F44336';
      case 'partially_paid':
        return '#2196F3';
      default:
        return '#9E9E9E';
    }
  }

  String get statusDisplayName {
    switch (status) {
      case 'paid':
        return 'Paid';
      case 'pending':
        return isOverdue ? 'Overdue' : 'Pending';
      case 'overdue':
        return 'Overdue';
      case 'partially_paid':
        return 'Partially Paid';
      default:
        return 'Unknown';
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Installment && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Installment{id: $id, transactionId: $transactionId, installmentNumber: $installmentNumber, status: $status}';
  }
}

// Request models for API calls
class PaymentPreviewRequest {
  final double principal;
  final int installmentCount;
  final double downPayment;
  final String paymentMethodId;

  PaymentPreviewRequest({
    required this.principal,
    required this.installmentCount,
    required this.downPayment,
    required this.paymentMethodId,
  });

  Map<String, dynamic> toJson() {
    return {
      'principal': principal,
      'installment_count': installmentCount,
      'down_payment': downPayment,
      'payment_method_id': paymentMethodId,
    };
  }
}

class PayInstallmentRequest {
  final double amount;
  final String paymentMethod;
  final String? paymentReference;
  final String? notes;

  PayInstallmentRequest({
    required this.amount,
    required this.paymentMethod,
    this.paymentReference,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'payment_method': paymentMethod,
      'payment_reference': paymentReference,
      'notes': notes,
    };
  }
}