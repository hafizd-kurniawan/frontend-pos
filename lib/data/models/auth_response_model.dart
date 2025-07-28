import 'user_model.dart';

class AuthResponse {
  final String token;
  final User user;
  final String tokenType;
  final int expiresIn;
  final String? refreshToken;

  AuthResponse({
    required this.token,
    required this.user,
    required this.tokenType,
    required this.expiresIn,
    this.refreshToken,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'] ?? json['access_token'] ?? '',
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      tokenType: json['token_type'] ?? 'Bearer',
      expiresIn: json['expires_in'] ?? 3600,
      refreshToken: json['refresh_token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'user': user.toJson(),
      'token_type': tokenType,
      'expires_in': expiresIn,
      if (refreshToken != null) 'refresh_token': refreshToken,
    };
  }

  AuthResponse copyWith({
    String? token,
    User? user,
    String? tokenType,
    int? expiresIn,
    String? refreshToken,
  }) {
    return AuthResponse(
      token: token ?? this.token,
      user: user ?? this.user,
      tokenType: tokenType ?? this.tokenType,
      expiresIn: expiresIn ?? this.expiresIn,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }
}
