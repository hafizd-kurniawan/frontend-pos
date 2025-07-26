class User {
  final int id;
  final String username;
  final String email;
  final String fullName; // Backend sends "full_name"
  final String phone;
  final String role;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.fullName,
    required this.phone,
    required this.role,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  // Getter for backward compatibility
  String get name => fullName;

  factory User.fromJson(Map<String, dynamic> json) {
    print('🔍 Parsing User from JSON: $json');

    return User(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String, // Match backend field name
      phone: json['phone'] as String,
      role: json['role'] as String,
      isActive: json['is_active'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'full_name': fullName,
      'phone': phone,
      'role': role,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  User copyWith({
    int? id,
    String? username,
    String? email,
    String? fullName,
    String? phone,
    String? role,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, username: $username, fullName: $fullName, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

// Role enum for better type safety
enum UserRole { admin, cashier, mechanic }

extension UserRoleExtension on UserRole {
  String get value {
    switch (this) {
      case UserRole.admin:
        return 'admin';
      case UserRole.cashier:
        return 'cashier';
      case UserRole.mechanic:
        return 'mechanic';
    }
  }

  String get displayName {
    switch (this) {
      case UserRole.admin:
        return 'Administrator';
      case UserRole.cashier:
        return 'Cashier';
      case UserRole.mechanic:
        return 'Mechanic';
    }
  }
}

extension UserExtension on User {
  UserRole get userRole {
    switch (role.toLowerCase()) {
      case 'admin':
        return UserRole.admin;
      case 'cashier':
        return UserRole.cashier;
      case 'mechanic':
        return UserRole.mechanic;
      default:
        return UserRole.cashier; // Default fallback
    }
  }

  bool get isAdmin => role.toLowerCase() == 'admin';
  bool get isCashier => role.toLowerCase() == 'cashier';
  bool get isMechanic => role.toLowerCase() == 'mechanic';
}
