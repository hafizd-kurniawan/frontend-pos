class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final String? error;
  final Map<String, dynamic>? errors;

  const ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.error,
    this.errors,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json)? fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: fromJsonT != null && json['data'] != null
          ? fromJsonT(json['data'])
          : json['data'],
      error: json['error'],
      errors: json['errors'],
    );
  }

  Map<String, dynamic> toJson(Object? Function(T value)? toJsonT) {
    return {
      'success': success,
      'message': message,
      'data': data != null && toJsonT != null ? toJsonT(data as T) : data,
      'error': error,
      'errors': errors,
    };
  }

  // Factory constructors for common responses
  factory ApiResponse.success({required String message, T? data}) {
    return ApiResponse<T>(success: true, message: message, data: data);
  }

  factory ApiResponse.error({
    required String message,
    String? error,
    Map<String, dynamic>? errors,
  }) {
    return ApiResponse<T>(
      success: false,
      message: message,
      error: error,
      errors: errors,
    );
  }
}

class PaginatedResponse<T> {
  final bool success;
  final String message;
  final T data;
  final PaginationMeta pagination;

  const PaginatedResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.pagination,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    return PaginatedResponse<T>(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: fromJsonT(json['data']),
      pagination: PaginationMeta.fromJson(json['pagination'] ?? {}),
    );
  }

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) {
    return {
      'success': success,
      'message': message,
      'data': toJsonT(data),
      'pagination': pagination.toJson(),
    };
  }
}

class PaginationMeta {
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasNext;
  final bool hasPrev;

  const PaginationMeta({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrev,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 20,
      total: json['total'] ?? 0,
      totalPages: json['total_pages'] ?? 0,
      hasNext: json['has_next'] ?? false,
      hasPrev: json['has_prev'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'limit': limit,
      'total': total,
      'total_pages': totalPages,
      'has_next': hasNext,
      'has_prev': hasPrev,
    };
  }
}
