# Installment Customer Management API Specification

## Overview
This document specifies the API endpoints needed to integrate customer information into the installment management system, allowing full CRUD operations on customer installment data.

## Required API Endpoints

### 1. Get All Installments with Customer Data
**Endpoint:** `GET /api/sales/installments/with-customers`

**Description:** Retrieve all installments with populated customer and transaction information for management screens.

**Query Parameters:**
- `status` (optional): Filter by installment status (pending, overdue, paid, partially_paid, all)
- `customer_id` (optional): Filter by specific customer
- `overdue_only` (optional): Boolean to get only overdue installments
- `page` (optional): Page number for pagination (default: 1)
- `limit` (optional): Number of items per page (default: 20)
- `search` (optional): Search in customer name, phone, email, or vehicle info
- `sort_by` (optional): Sort field (due_date, customer_name, amount, status)
- `sort_order` (optional): Sort direction (asc, desc)

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
        
        // Computed fields for UI
        "days_overdue": 45,
        "remaining_amount": 2500000,
        "total_remaining_installments": 10
      }
    ],
    "pagination": {
      "current_page": 1,
      "per_page": 20,
      "total": 45,
      "total_pages": 3
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

### 2. Get Customer Installment Details
**Endpoint:** `GET /api/sales/customers/{customer_id}/installments`

**Description:** Get all installments for a specific customer with detailed payment history.

**Response 200:**
```json
{
  "success": true,
  "message": "Customer installments retrieved successfully",
  "data": {
    "customer": {
      "id": 25,
      "name": "John Doe",
      "phone": "+628123456789",
      "email": "john.doe@email.com",
      "address": "Jl. Sudirman No. 123, Jakarta",
      "type": "individual",
      "total_transactions": 2,
      "total_debt": 25000000,
      "overdue_amount": 5000000
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
        "vehicle_info": "Honda Civic 2023 - B1234XYZ"
      }
    ],
    "payment_history": [
      {
        "installment_id": 1,
        "payment_date": "2024-01-15",
        "amount": 2500000,
        "payment_method": "transfer",
        "reference": "TRF123456789"
      }
    ]
  }
}
```

### 3. Update Customer Information
**Endpoint:** `PATCH /api/sales/customers/{customer_id}`

**Description:** Update customer information that affects installment management.

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

### 4. Mark Customer Installments as Finished/Settled
**Endpoint:** `POST /api/sales/customers/{customer_id}/installments/settle`

**Description:** Mark all or specific customer installments as settled/finished.

**Request Body:**
```json
{
  "action": "settle_all", // or "settle_selected"
  "installment_ids": [1, 2, 3], // required if action is "settle_selected"
  "settlement_type": "full_payment", // "full_payment", "partial_settlement", "waived"
  "settlement_amount": 7500000, // total settlement amount
  "payment_method": "cash",
  "payment_reference": "SETTLE123456",
  "notes": "Customer paid full settlement",
  "settled_by": 1 // user ID who processed the settlement
}
```

**Response 200:**
```json
{
  "success": true,
  "message": "Customer installments settled successfully",
  "data": {
    "settlement_id": "SETTLE-2024-001",
    "customer_id": 25,
    "total_settled_amount": 7500000,
    "installments_settled": 3,
    "settlement_date": "2024-01-20T15:30:00Z",
    "remaining_balance": 0
  }
}
```

### 5. Get Overdue Customers Summary
**Endpoint:** `GET /api/sales/installments/overdue-customers`

**Description:** Get summary of customers with overdue installments for dashboard alerts.

**Response 200:**
```json
{
  "success": true,
  "message": "Overdue customers summary retrieved successfully",
  "data": {
    "customers": [
      {
        "customer_id": 25,
        "customer_name": "John Doe",
        "customer_phone": "+628123456789",
        "overdue_installments": 2,
        "total_overdue_amount": 5000000,
        "earliest_overdue_date": "2024-01-15",
        "days_since_earliest_overdue": 45,
        "last_payment_date": "2023-12-15"
      }
    ],
    "summary": {
      "total_overdue_customers": 6,
      "total_overdue_amount": 45000000,
      "average_overdue_days": 32,
      "customers_30_days_overdue": 4,
      "customers_60_days_overdue": 2,
      "customers_90_days_overdue": 1
    }
  }
}
```

### 6. Send Payment Reminder to Customer
**Endpoint:** `POST /api/sales/customers/{customer_id}/installments/{installment_id}/remind`

**Description:** Send payment reminder to customer via SMS/Email.

**Request Body:**
```json
{
  "reminder_type": "sms", // "sms", "email", "both"
  "message_template": "custom", // "default", "custom"
  "custom_message": "Dear {customer_name}, your installment payment of {amount} is overdue since {due_date}. Please make payment immediately.",
  "sent_by": 1 // user ID who sent the reminder
}
```

**Response 200:**
```json
{
  "success": true,
  "message": "Payment reminder sent successfully",
  "data": {
    "reminder_id": "REM-2024-001",
    "sent_to": "+628123456789",
    "sent_via": "sms",
    "sent_at": "2024-01-20T16:00:00Z",
    "cost": 500 // SMS cost in rupiah
  }
}
```

### 7. Customer Installment Actions Log
**Endpoint:** `GET /api/sales/customers/{customer_id}/installments/actions`

**Description:** Get history of actions performed on customer installments.

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
          "sent_to": "+628123456789"
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
          "new_status": "overdue"
        },
        "created_at": "2024-01-15T00:00:00Z"
      }
    ]
  }
}
```

## Error Responses

### 400 Bad Request
```json
{
  "success": false,
  "message": "Invalid request parameters",
  "errors": {
    "customer_id": ["Customer ID is required"],
    "settlement_amount": ["Settlement amount must be positive"]
  }
}
```

### 404 Not Found
```json
{
  "success": false,
  "message": "Customer not found",
  "error_code": "CUSTOMER_NOT_FOUND"
}
```

### 422 Unprocessable Entity
```json
{
  "success": false,
  "message": "Cannot settle installments with pending payments",
  "error_code": "INSTALLMENTS_HAVE_PENDING_PAYMENTS"
}
```

## Database Schema Requirements

### Additional Customer Fields Needed:
```sql
ALTER TABLE customers ADD COLUMN total_debt DECIMAL(15,2) DEFAULT 0;
ALTER TABLE customers ADD COLUMN overdue_amount DECIMAL(15,2) DEFAULT 0;
ALTER TABLE customers ADD COLUMN last_payment_date DATE;
ALTER TABLE customers ADD COLUMN payment_behavior_score INT DEFAULT 100;
```

### New Tables Needed:

#### customer_installment_actions
```sql
CREATE TABLE customer_installment_actions (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  customer_id INT NOT NULL,
  installment_id INT,
  action_type ENUM('payment_made', 'payment_reminder_sent', 'status_updated', 'settlement_made', 'info_updated'),
  performed_by INT NOT NULL,
  details JSON,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (customer_id) REFERENCES customers(id),
  FOREIGN KEY (installment_id) REFERENCES installments(id),
  FOREIGN KEY (performed_by) REFERENCES users(id)
);
```

#### installment_settlements
```sql
CREATE TABLE installment_settlements (
  id VARCHAR(50) PRIMARY KEY,
  customer_id INT NOT NULL,
  settlement_type ENUM('full_payment', 'partial_settlement', 'waived'),
  total_amount DECIMAL(15,2) NOT NULL,
  installment_ids JSON NOT NULL,
  payment_method VARCHAR(50),
  payment_reference VARCHAR(100),
  notes TEXT,
  settled_by INT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (customer_id) REFERENCES customers(id),
  FOREIGN KEY (settled_by) REFERENCES users(id)
);
```

## Implementation Priority

1. **High Priority:**
   - `GET /api/sales/installments/with-customers` - Core functionality for customer display
   - `GET /api/sales/customers/{customer_id}/installments` - Customer detail view
   - `PATCH /api/sales/customers/{customer_id}` - Customer info updates

2. **Medium Priority:**
   - `GET /api/sales/installments/overdue-customers` - Dashboard alerts
   - `POST /api/sales/customers/{customer_id}/installments/settle` - Settlement feature

3. **Low Priority:**
   - `POST /api/sales/customers/{customer_id}/installments/{installment_id}/remind` - Communication feature
   - `GET /api/sales/customers/{customer_id}/installments/actions` - Audit trail

This API specification provides complete customer integration for the installment management system, enabling full read, update, and finish operations on customer installment data.