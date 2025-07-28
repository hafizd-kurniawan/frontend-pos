# Complete Installment System API Contract & DTOs

## 📋 Overview
This document provides a comprehensive API contract for the complete installment system integration, including all required endpoints, DTOs, request/response models, and implementation specifications.

## 🔐 Authentication
All endpoints require JWT authentication via `Authorization: Bearer <token>` header.

**Authentication Error Response:**
```json
{
  "success": false,
  "message": "Unauthorized access",
  "error_code": "UNAUTHORIZED",
  "timestamp": "2024-01-20T10:30:00Z"
}
```

---

## 📊 Core Data Models & DTOs

### 1. **PaymentMethod DTO**
```json
{
  "id": "credit",
  "name": "Credit/Financing",
  "description": "Installment payment plan",
  "icon": "credit",
  "supports_installments": true,
  "is_active": true,
  "color": "#9C27B0",
  "interest_rate": 12.5,
  "max_installment_months": 36,
  "min_down_payment_percentage": 10
}
```

**Flutter/Dart Model:**
```dart
class PaymentMethod {
  final String id;
  final String name;
  final String description;
  final String icon;
  final bool supportsInstallments;
  final bool isActive;
  final String? color;
  final double? interestRate;
  final int? maxInstallmentMonths;
  final double? minDownPaymentPercentage;
}
```

### 2. **Installment DTO**
```json
{
  "id": 1,
  "transaction_id": 101,
  "installment_number": 2,
  "due_date": "2024-02-15",
  "amount": 2500000,
  "paid_amount": 0,
  "status": "overdue",
  "paid_at": null,
  "payment_method": null,
  "payment_reference": null,
  "notes": null,
  "principal_amount": 2300000,
  "interest_amount": 200000,
  "penalty_amount": 50000,
  "created_at": "2024-01-01T10:00:00Z",
  "updated_at": "2024-01-15T14:30:00Z",
  
  // Customer Information
  "customer_id": 25,
  "customer_name": "John Doe",
  "customer_phone": "+628123456789",
  "customer_email": "john.doe@email.com",
  "customer_address": "Jl. Sudirman No. 123, Jakarta",
  "customer_type": "individual",
  
  // Transaction/Sale Information
  "sale_date": "2023-12-01",
  "total_sale_amount": 150000000,
  "down_payment": 15000000,
  "vehicle_info": "Honda Civic 2023 - B1234XYZ",
  
  // Computed fields
  "days_overdue": 45,
  "remaining_amount": 2500000,
  "total_remaining_installments": 10
}
```

### 3. **Customer DTO**
```json
{
  "id": 25,
  "customer_code": "CUST-2024-001",
  "name": "John Doe",
  "phone": "+628123456789",
  "email": "john.doe@email.com",
  "address": "Jl. Sudirman No. 123, Jakarta",
  "id_card_number": "3171234567890123",
  "type": "individual",
  "company_name": null,
  "is_active": true,
  "created_by": 1,
  "created_at": "2023-11-01T10:00:00Z",
  "updated_at": "2024-01-15T14:30:00Z",
  
  // Installment-specific fields
  "total_transactions": 2,
  "total_debt": 25000000,
  "overdue_amount": 5000000,
  "last_payment_date": "2023-12-15",
  "payment_behavior_score": 85
}
```

### 4. **InstallmentPreview DTO**
```json
{
  "monthly_payment": 2500000,
  "total_interest": 8000000,
  "total_amount": 158000000,
  "installment_count": 24,
  "interest_rate": 12.5,
  "down_payment": 15000000,
  "schedule": [
    {
      "installment_number": 1,
      "due_date": "2024-01-15",
      "amount": 2500000,
      "principal_amount": 2300000,
      "interest_amount": 200000,
      "status": "pending"
    }
  ]
}
```

---

## 🛠 API Endpoints Specification

### 1. **Get Available Payment Methods**
```
GET /api/sales/payment-methods
```

**Description:** Retrieve all available payment methods with installment capabilities

**Query Parameters:**
- `active_only` (boolean, optional): Filter only active payment methods (default: true)
- `supports_installments` (boolean, optional): Filter payment methods that support installments

**Response 200:**
```json
{
  "success": true,
  "message": "Payment methods retrieved successfully",
  "data": {
    "payment_methods": [
      {
        "id": "cash",
        "name": "Cash Payment",
        "description": "Direct cash payment",
        "icon": "cash",
        "supports_installments": false,
        "is_active": true,
        "color": "#4CAF50"
      },
      {
        "id": "credit",
        "name": "Credit/Financing",
        "description": "Installment payment plan",
        "icon": "credit",
        "supports_installments": true,
        "is_active": true,
        "color": "#9C27B0",
        "interest_rate": 12.5,
        "max_installment_months": 36,
        "min_down_payment_percentage": 10
      }
    ]
  }
}
```

### 2. **Calculate Payment Preview**
```
POST /api/sales/payment-preview
```

**Description:** Calculate installment preview based on amount and terms

**Request Body:**
```json
{
  "principal": 150000000,
  "installment_count": 24,
  "down_payment": 15000000,
  "payment_method_id": "credit"
}
```

**Request DTO (Flutter):**
```dart
class PaymentPreviewRequest {
  final double principal;
  final int installmentCount;
  final double downPayment;
  final String paymentMethodId;
  
  Map<String, dynamic> toJson() => {
    'principal': principal,
    'installment_count': installmentCount,
    'down_payment': downPayment,
    'payment_method_id': paymentMethodId,
  };
}
```

**Response 200:**
```json
{
  "success": true,
  "message": "Payment preview calculated successfully",
  "data": {
    "preview": {
      "monthly_payment": 2500000,
      "total_interest": 8000000,
      "total_amount": 158000000,
      "installment_count": 24,
      "interest_rate": 12.5,
      "down_payment": 15000000,
      "schedule": [
        {
          "installment_number": 1,
          "due_date": "2024-01-15",
          "amount": 2500000,
          "principal_amount": 2300000,
          "interest_amount": 200000,
          "status": "pending"
        }
      ]
    }
  }
}
```

### 3. **Get All Installments with Customer Data**
```
GET /api/sales/installments/with-customers
```

**Description:** Retrieve all installments with populated customer and transaction information

**Query Parameters:**
- `status` (string, optional): Filter by status (pending, overdue, paid, partially_paid, all)
- `customer_id` (integer, optional): Filter by specific customer
- `overdue_only` (boolean, optional): Get only overdue installments
- `page` (integer, optional): Page number (default: 1)
- `limit` (integer, optional): Items per page (default: 20, max: 100)
- `search` (string, optional): Search in customer name, phone, email, vehicle
- `sort_by` (string, optional): Sort field (due_date, customer_name, amount, status)
- `sort_order` (string, optional): Sort direction (asc, desc)

**Response 200:**
```json
{
  "success": true,
  "message": "Installments with customer data retrieved successfully",
  "data": {
    "installments": [
      {
        "id": 1,
        "transaction_id": 101,
        "installment_number": 2,
        "due_date": "2024-02-15",
        "amount": 2500000,
        "paid_amount": 0,
        "status": "overdue",
        "paid_at": null,
        "payment_method": null,
        "payment_reference": null,
        "notes": null,
        "principal_amount": 2300000,
        "interest_amount": 200000,
        "penalty_amount": 50000,
        "created_at": "2024-01-01T10:00:00Z",
        "updated_at": "2024-01-15T14:30:00Z",
        
        // Customer Information
        "customer_id": 25,
        "customer_name": "John Doe",
        "customer_phone": "+628123456789",
        "customer_email": "john.doe@email.com",
        "customer_address": "Jl. Sudirman No. 123, Jakarta",
        "customer_type": "individual",
        
        // Transaction/Sale Information
        "sale_date": "2023-12-01",
        "total_sale_amount": 150000000,
        "down_payment": 15000000,
        "vehicle_info": "Honda Civic 2023 - B1234XYZ",
        
        // Computed fields
        "days_overdue": 45,
        "remaining_amount": 2500000,
        "total_remaining_installments": 10
      }
    ],
    "pagination": {
      "current_page": 1,
      "per_page": 20,
      "total": 45,
      "total_pages": 3,
      "has_next_page": true,
      "has_previous_page": false
    },
    "summary": {
      "total_overdue": 8,
      "total_pending": 25,
      "total_amount_overdue": 45000000,
      "customers_with_overdue": 6
    }
  }
}
```

### 4. **Get Customer Installment Details**
```
GET /api/sales/customers/{customer_id}/installments
```

**Description:** Get all installments for a specific customer with payment history

**Query Parameters:**
- `include_payment_history` (boolean, optional): Include payment history (default: true)
- `status` (string, optional): Filter installments by status

**Response 200:**
```json
{
  "success": true,
  "message": "Customer installments retrieved successfully",
  "data": {
    "customer": {
      "id": 25,
      "customer_code": "CUST-2024-001",
      "name": "John Doe",
      "phone": "+628123456789",
      "email": "john.doe@email.com",
      "address": "Jl. Sudirman No. 123, Jakarta",
      "type": "individual",
      "total_transactions": 2,
      "total_debt": 25000000,
      "overdue_amount": 5000000,
      "last_payment_date": "2023-12-15",
      "payment_behavior_score": 85
    },
    "installments": [
      {
        "id": 1,
        "transaction_id": 101,
        "installment_number": 2,
        "due_date": "2024-02-15",
        "amount": 2500000,
        "paid_amount": 0,
        "status": "overdue",
        "days_overdue": 45,
        "vehicle_info": "Honda Civic 2023 - B1234XYZ",
        "remaining_amount": 2500000
      }
    ],
    "payment_history": [
      {
        "id": 1,
        "installment_id": 1,
        "payment_date": "2024-01-15",
        "amount": 2500000,
        "payment_method": "transfer",
        "reference": "TRF123456789",
        "processed_by": 1,
        "processor_name": "Admin User",
        "notes": "Bank transfer payment"
      }
    ],
    "summary": {
      "total_installments": 12,
      "paid_installments": 2,
      "pending_installments": 8,
      "overdue_installments": 2,
      "total_paid_amount": 5000000,
      "total_remaining_amount": 20000000
    }
  }
}
```

### 5. **Update Customer Information**
```
PATCH /api/sales/customers/{customer_id}
```

**Description:** Update customer information affecting installment management

**Request Body:**
```json
{
  "name": "John Doe Updated",
  "phone": "+628123456789",
  "email": "john.updated@email.com",
  "address": "New Address",
  "notes": "Customer requested address change"
}
```

**Request DTO (Flutter):**
```dart
class UpdateCustomerRequest {
  final String? name;
  final String? phone;
  final String? email;
  final String? address;
  final String? notes;
  
  Map<String, dynamic> toJson() => {
    if (name != null) 'name': name,
    if (phone != null) 'phone': phone,
    if (email != null) 'email': email,
    if (address != null) 'address': address,
    if (notes != null) 'notes': notes,
  };
}
```

**Response 200:**
```json
{
  "success": true,
  "message": "Customer information updated successfully",
  "data": {
    "customer": {
      "id": 25,
      "name": "John Doe Updated",
      "phone": "+628123456789",
      "email": "john.updated@email.com",
      "address": "New Address",
      "updated_at": "2024-01-20T10:30:00Z"
    }
  }
}
```

### 6. **Pay Installment**
```
POST /api/sales/transactions/{transaction_id}/installments/{installment_id}/pay
```

**Description:** Process payment for a specific installment

**Request Body:**
```json
{
  "amount": 2500000,
  "payment_method": "transfer",
  "payment_reference": "TRF123456789",
  "notes": "Bank transfer payment",
  "processed_by": 1
}
```

**Request DTO (Flutter):**
```dart
class PayInstallmentRequest {
  final double amount;
  final String paymentMethod;
  final String? paymentReference;
  final String? notes;
  final int? processedBy;
  
  Map<String, dynamic> toJson() => {
    'amount': amount,
    'payment_method': paymentMethod,
    if (paymentReference != null) 'payment_reference': paymentReference,
    if (notes != null) 'notes': notes,
    if (processedBy != null) 'processed_by': processedBy,
  };
}
```

**Response 200:**
```json
{
  "success": true,
  "message": "Installment payment processed successfully",
  "data": {
    "payment": {
      "id": 1,
      "installment_id": 1,
      "amount": 2500000,
      "payment_method": "transfer",
      "payment_reference": "TRF123456789",
      "payment_date": "2024-01-20T15:30:00Z",
      "processed_by": 1,
      "processor_name": "Admin User"
    },
    "installment": {
      "id": 1,
      "status": "paid",
      "paid_amount": 2500000,
      "remaining_amount": 0,
      "paid_at": "2024-01-20T15:30:00Z"
    }
  }
}
```

### 7. **Settle Customer Installments**
```
POST /api/sales/customers/{customer_id}/installments/settle
```

**Description:** Mark customer installments as settled/finished

**Request Body:**
```json
{
  "action": "settle_all",
  "installment_ids": [1, 2, 3],
  "settlement_type": "full_payment",
  "settlement_amount": 7500000,
  "payment_method": "cash",
  "payment_reference": "SETTLE123456",
  "notes": "Customer paid full settlement",
  "settled_by": 1
}
```

**Request DTO (Flutter):**
```dart
class SettleInstallmentsRequest {
  final String action; // settle_all, settle_selected
  final List<int>? installmentIds;
  final String settlementType; // full_payment, partial_settlement, waived
  final double settlementAmount;
  final String paymentMethod;
  final String? paymentReference;
  final String? notes;
  final int settledBy;
  
  Map<String, dynamic> toJson() => {
    'action': action,
    if (installmentIds != null) 'installment_ids': installmentIds,
    'settlement_type': settlementType,
    'settlement_amount': settlementAmount,
    'payment_method': paymentMethod,
    if (paymentReference != null) 'payment_reference': paymentReference,
    if (notes != null) 'notes': notes,
    'settled_by': settledBy,
  };
}
```

**Response 200:**
```json
{
  "success": true,
  "message": "Customer installments settled successfully",
  "data": {
    "settlement": {
      "id": "SETTLE-2024-001",
      "customer_id": 25,
      "settlement_type": "full_payment",
      "total_settled_amount": 7500000,
      "installments_settled": 3,
      "settlement_date": "2024-01-20T15:30:00Z",
      "remaining_balance": 0,
      "settled_by": 1,
      "settler_name": "Admin User"
    }
  }
}
```

### 8. **Get Overdue Installments**
```
GET /api/sales/installments/overdue
```

**Description:** Get overdue installments for dashboard alerts

**Query Parameters:**
- `days_overdue` (integer, optional): Filter by minimum days overdue
- `limit` (integer, optional): Limit number of results (default: 50)

**Response 200:**
```json
{
  "success": true,
  "message": "Overdue installments retrieved successfully",
  "data": {
    "overdue_installments": [
      {
        "id": 1,
        "customer_id": 25,
        "customer_name": "John Doe",
        "customer_phone": "+628123456789",
        "installment_number": 2,
        "due_date": "2024-01-15",
        "amount": 2500000,
        "days_overdue": 45,
        "vehicle_info": "Honda Civic 2023 - B1234XYZ"
      }
    ],
    "summary": {
      "total_overdue_count": 8,
      "total_overdue_amount": 45000000,
      "customers_affected": 6,
      "average_days_overdue": 32
    }
  }
}
```

### 9. **Update Installment Status**
```
PATCH /api/sales/installments/{installment_id}/status
```

**Description:** Update installment status (admin function)

**Request Body:**
```json
{
  "status": "overdue",
  "notes": "Marked as overdue due to non-payment",
  "updated_by": 1
}
```

**Request DTO (Flutter):**
```dart
class UpdateInstallmentStatusRequest {
  final String status; // pending, paid, overdue, partially_paid
  final String? notes;
  final int updatedBy;
  
  Map<String, dynamic> toJson() => {
    'status': status,
    if (notes != null) 'notes': notes,
    'updated_by': updatedBy,
  };
}
```

**Response 200:**
```json
{
  "success": true,
  "message": "Installment status updated successfully",
  "data": {
    "installment": {
      "id": 1,
      "status": "overdue",
      "updated_at": "2024-01-20T16:00:00Z",
      "updated_by": 1,
      "updater_name": "Admin User"
    }
  }
}
```

### 10. **Get Installment Statistics**
```
GET /api/sales/installments/stats
```

**Description:** Get installment statistics for dashboard

**Query Parameters:**
- `date_from` (string, optional): Start date for statistics (ISO format)
- `date_to` (string, optional): End date for statistics (ISO format)

**Response 200:**
```json
{
  "success": true,
  "message": "Installment statistics retrieved successfully",
  "data": {
    "total_installments": 150,
    "pending_count": 25,
    "overdue_count": 8,
    "paid_count": 117,
    "total_pending_amount": 125000000,
    "total_overdue_amount": 45000000,
    "total_paid_amount": 292500000,
    "overdue_percentage": 5.33,
    "collection_rate": 78,
    "average_payment_delay": 12.5,
    "customers_with_overdue": 6,
    "monthly_target": 300000000,
    "monthly_achievement": 78.5
  }
}
```

### 11. **Send Payment Reminder**
```
POST /api/sales/customers/{customer_id}/installments/{installment_id}/remind
```

**Description:** Send payment reminder to customer

**Request Body:**
```json
{
  "reminder_type": "sms",
  "message_template": "default",
  "custom_message": "Dear {customer_name}, your installment payment of {amount} is overdue since {due_date}.",
  "sent_by": 1
}
```

**Request DTO (Flutter):**
```dart
class SendReminderRequest {
  final String reminderType; // sms, email, both
  final String messageTemplate; // default, custom
  final String? customMessage;
  final int sentBy;
  
  Map<String, dynamic> toJson() => {
    'reminder_type': reminderType,
    'message_template': messageTemplate,
    if (customMessage != null) 'custom_message': customMessage,
    'sent_by': sentBy,
  };
}
```

**Response 200:**
```json
{
  "success": true,
  "message": "Payment reminder sent successfully",
  "data": {
    "reminder": {
      "id": "REM-2024-001",
      "sent_to": "+628123456789",
      "sent_via": "sms",
      "sent_at": "2024-01-20T16:00:00Z",
      "cost": 500,
      "status": "delivered"
    }
  }
}
```

### 12. **Get Customer Action History**
```
GET /api/sales/customers/{customer_id}/installments/actions
```

**Description:** Get history of actions performed on customer installments

**Query Parameters:**
- `action_type` (string, optional): Filter by action type
- `page` (integer, optional): Page number
- `limit` (integer, optional): Items per page

**Response 200:**
```json
{
  "success": true,
  "message": "Customer installment actions retrieved successfully",
  "data": {
    "actions": [
      {
        "id": 1,
        "action_type": "payment_reminder_sent",
        "installment_id": 1,
        "performed_by": 1,
        "performer_name": "Admin User",
        "details": {
          "reminder_type": "sms",
          "sent_to": "+628123456789",
          "cost": 500
        },
        "created_at": "2024-01-20T16:00:00Z"
      },
      {
        "id": 2,
        "action_type": "status_updated",
        "installment_id": 1,
        "performed_by": 1,
        "performer_name": "Admin User",
        "details": {
          "old_status": "pending",
          "new_status": "overdue",
          "reason": "Payment deadline exceeded"
        },
        "created_at": "2024-01-15T00:00:00Z"
      }
    ],
    "pagination": {
      "current_page": 1,
      "per_page": 20,
      "total": 15,
      "total_pages": 1
    }
  }
}
```

---

## 📝 Complete Flutter/Dart DTOs

### Response Wrapper Models
```dart
class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final String? errorCode;
  final Map<String, List<String>>? errors;
  final String? timestamp;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.errorCode,
    this.errors,
    this.timestamp,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(dynamic)? fromJsonT) {
    return ApiResponse<T>(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null && fromJsonT != null ? fromJsonT(json['data']) : null,
      errorCode: json['error_code'],
      errors: json['errors'] != null ? Map<String, List<String>>.from(json['errors']) : null,
      timestamp: json['timestamp'],
    );
  }
}

class PaginationMeta {
  final int currentPage;
  final int perPage;
  final int total;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;

  PaginationMeta({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      currentPage: json['current_page'] ?? 1,
      perPage: json['per_page'] ?? 20,
      total: json['total'] ?? 0,
      totalPages: json['total_pages'] ?? 0,
      hasNextPage: json['has_next_page'] ?? false,
      hasPreviousPage: json['has_previous_page'] ?? false,
    );
  }
}
```

### Additional Request DTOs
```dart
class UpdateCustomerRequest {
  final String? name;
  final String? phone;
  final String? email;
  final String? address;
  final String? notes;
  
  UpdateCustomerRequest({
    this.name,
    this.phone,
    this.email,
    this.address,
    this.notes,
  });
  
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (name != null) data['name'] = name;
    if (phone != null) data['phone'] = phone;
    if (email != null) data['email'] = email;
    if (address != null) data['address'] = address;
    if (notes != null) data['notes'] = notes;
    return data;
  }
}

class SettleInstallmentsRequest {
  final String action; // settle_all, settle_selected
  final List<int>? installmentIds;
  final String settlementType; // full_payment, partial_settlement, waived
  final double settlementAmount;
  final String paymentMethod;
  final String? paymentReference;
  final String? notes;
  final int settledBy;
  
  SettleInstallmentsRequest({
    required this.action,
    this.installmentIds,
    required this.settlementType,
    required this.settlementAmount,
    required this.paymentMethod,
    this.paymentReference,
    this.notes,
    required this.settledBy,
  });
  
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'action': action,
      'settlement_type': settlementType,
      'settlement_amount': settlementAmount,
      'payment_method': paymentMethod,
      'settled_by': settledBy,
    };
    if (installmentIds != null) data['installment_ids'] = installmentIds;
    if (paymentReference != null) data['payment_reference'] = paymentReference;
    if (notes != null) data['notes'] = notes;
    return data;
  }
}

class UpdateInstallmentStatusRequest {
  final String status; // pending, paid, overdue, partially_paid
  final String? notes;
  final int updatedBy;
  
  UpdateInstallmentStatusRequest({
    required this.status,
    this.notes,
    required this.updatedBy,
  });
  
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'status': status,
      'updated_by': updatedBy,
    };
    if (notes != null) data['notes'] = notes;
    return data;
  }
}

class SendReminderRequest {
  final String reminderType; // sms, email, both
  final String messageTemplate; // default, custom
  final String? customMessage;
  final int sentBy;
  
  SendReminderRequest({
    required this.reminderType,
    required this.messageTemplate,
    this.customMessage,
    required this.sentBy,
  });
  
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'reminder_type': reminderType,
      'message_template': messageTemplate,
      'sent_by': sentBy,
    };
    if (customMessage != null) data['custom_message'] = customMessage;
    return data;
  }
}
```

---

## 🚨 Error Response Specifications

### Standard Error Responses

**400 Bad Request:**
```json
{
  "success": false,
  "message": "Invalid request parameters",
  "error_code": "VALIDATION_ERROR",
  "errors": {
    "customer_id": ["Customer ID is required"],
    "settlement_amount": ["Settlement amount must be positive"],
    "payment_method": ["Payment method is not supported"]
  },
  "timestamp": "2024-01-20T10:30:00Z"
}
```

**401 Unauthorized:**
```json
{
  "success": false,
  "message": "Unauthorized access",
  "error_code": "UNAUTHORIZED",
  "timestamp": "2024-01-20T10:30:00Z"
}
```

**404 Not Found:**
```json
{
  "success": false,
  "message": "Customer not found",
  "error_code": "CUSTOMER_NOT_FOUND",
  "timestamp": "2024-01-20T10:30:00Z"
}
```

**422 Unprocessable Entity:**
```json
{
  "success": false,
  "message": "Cannot settle installments with pending payments",
  "error_code": "INSTALLMENTS_HAVE_PENDING_PAYMENTS",
  "details": {
    "pending_installments": [1, 2],
    "required_action": "Pay or void pending installments first"
  },
  "timestamp": "2024-01-20T10:30:00Z"
}
```

**500 Internal Server Error:**
```json
{
  "success": false,
  "message": "Internal server error occurred",
  "error_code": "INTERNAL_SERVER_ERROR",
  "timestamp": "2024-01-20T10:30:00Z"
}
```

---

## 📊 Database Schema Requirements

### Additional Customer Fields
```sql
-- Add installment-specific fields to customers table
ALTER TABLE customers ADD COLUMN total_debt DECIMAL(15,2) DEFAULT 0;
ALTER TABLE customers ADD COLUMN overdue_amount DECIMAL(15,2) DEFAULT 0;
ALTER TABLE customers ADD COLUMN last_payment_date DATE;
ALTER TABLE customers ADD COLUMN payment_behavior_score INT DEFAULT 100;
ALTER TABLE customers ADD COLUMN customer_code VARCHAR(50) UNIQUE;
ALTER TABLE customers ADD COLUMN id_card_number VARCHAR(20);
```

### New Tables

#### customer_installment_actions
```sql
CREATE TABLE customer_installment_actions (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  customer_id INT NOT NULL,
  installment_id INT,
  action_type ENUM('payment_made', 'payment_reminder_sent', 'status_updated', 'settlement_made', 'info_updated', 'reminder_sent') NOT NULL,
  performed_by INT NOT NULL,
  details JSON,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE,
  FOREIGN KEY (installment_id) REFERENCES installments(id) ON DELETE SET NULL,
  FOREIGN KEY (performed_by) REFERENCES users(id),
  INDEX idx_customer_actions (customer_id, created_at),
  INDEX idx_installment_actions (installment_id, created_at)
);
```

#### installment_settlements
```sql
CREATE TABLE installment_settlements (
  id VARCHAR(50) PRIMARY KEY,
  customer_id INT NOT NULL,
  settlement_type ENUM('full_payment', 'partial_settlement', 'waived') NOT NULL,
  total_amount DECIMAL(15,2) NOT NULL,
  installment_ids JSON NOT NULL,
  payment_method VARCHAR(50),
  payment_reference VARCHAR(100),
  notes TEXT,
  settled_by INT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE,
  FOREIGN KEY (settled_by) REFERENCES users(id),
  INDEX idx_customer_settlements (customer_id, created_at)
);
```

#### payment_reminders
```sql
CREATE TABLE payment_reminders (
  id VARCHAR(50) PRIMARY KEY,
  customer_id INT NOT NULL,
  installment_id INT NOT NULL,
  reminder_type ENUM('sms', 'email', 'both') NOT NULL,
  sent_to VARCHAR(100) NOT NULL,
  message_content TEXT,
  cost DECIMAL(10,2) DEFAULT 0,
  status ENUM('sent', 'delivered', 'failed') DEFAULT 'sent',
  sent_by INT NOT NULL,
  sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE,
  FOREIGN KEY (installment_id) REFERENCES installments(id) ON DELETE CASCADE,
  FOREIGN KEY (sent_by) REFERENCES users(id),
  INDEX idx_customer_reminders (customer_id, sent_at),
  INDEX idx_installment_reminders (installment_id, sent_at)
);
```

---

## 🔧 Implementation Priority

### **Phase 1 - Core Functionality (High Priority)**
1. `GET /api/sales/payment-methods` - Payment method retrieval
2. `POST /api/sales/payment-preview` - Installment calculation
3. `GET /api/sales/installments/with-customers` - Main installment list
4. `POST /api/sales/transactions/{id}/installments/{id}/pay` - Payment processing
5. `GET /api/sales/installments/stats` - Dashboard statistics

### **Phase 2 - Customer Management (Medium Priority)**
1. `GET /api/sales/customers/{id}/installments` - Customer detail view
2. `PATCH /api/sales/customers/{id}` - Customer info updates
3. `GET /api/sales/installments/overdue` - Overdue alerts
4. `PATCH /api/sales/installments/{id}/status` - Status updates

### **Phase 3 - Advanced Features (Low Priority)**
1. `POST /api/sales/customers/{id}/installments/settle` - Settlement functionality
2. `POST /api/sales/customers/{id}/installments/{id}/remind` - Communication
3. `GET /api/sales/customers/{id}/installments/actions` - Audit trail

---

## 📋 Summary

This comprehensive API contract provides:

✅ **12 Complete API Endpoints** with detailed specifications
✅ **Complete DTO Specifications** for all request/response models  
✅ **Flutter/Dart Model Implementations** ready for integration
✅ **Database Schema Requirements** for backend implementation
✅ **Error Handling Specifications** with consistent format
✅ **Authentication & Security** requirements
✅ **Implementation Priority** roadmap

The contract ensures seamless integration between the Flutter frontend and backend API, providing a complete installment management system with customer data integration, payment processing, and comprehensive management features.
