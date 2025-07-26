import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user_model.dart';
import '../../data/services/auth_service.dart';
import '../../core/network/dio_client.dart';

// Auth Service Provider
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// Auth State
class AuthState {
  final User? user;
  final String? token;
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;

  AuthState({
    this.user,
    this.token,
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    User? user,
    String? token,
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
  }) {
    return AuthState(
      user: user ?? this.user,
      token: token ?? this.token,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

// Auth State Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(AuthState());

  Future<bool> login({
    required String username,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      print('🔐 AuthNotifier: Starting login process');
      final authResponse = await _authService.login(
        username: username,
        password: password,
      );

      print('✅ AuthNotifier: Login successful');
      print('👤 User: ${authResponse.user}');
      print('🎫 Token: ${authResponse.token.substring(0, 20)}...');

      state = state.copyWith(
        user: authResponse.user,
        token: authResponse.token,
        isLoading: false,
        isAuthenticated: true,
        error: null,
      );

      // TODO: Store token in secure storage
      // await _storeToken(authResponse.token);

      DioClient.instance.setAuthToken(authResponse.token);

      return true;
    } catch (e) {
      print('❌ AuthNotifier: Login failed - $e');
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        isAuthenticated: false,
      );
      return false;
    }
  }

  Future<void> logout() async {
    print('🚪 AuthNotifier: Starting logout process');

    try {
      await _authService.logout();
      print('✅ AuthNotifier: Server logout successful');
    } catch (e) {
      print(
        '⚠️ AuthNotifier: Server logout failed, but continuing with local logout',
      );
    }

    // Clear local state regardless of server response
    state = AuthState();

    // TODO: Clear stored token
    // await _clearStoredToken();

    print('✅ AuthNotifier: Local logout completed');
  }

  Future<void> loadCurrentUser() async {
    if (state.token == null) {
      print('⚠️ AuthNotifier: No token available, skipping user load');
      return;
    }

    try {
      print('👤 AuthNotifier: Loading current user');
      final user = await _authService.getCurrentUser();

      if (user != null) {
        state = state.copyWith(user: user, isAuthenticated: true);
        print('✅ AuthNotifier: Current user loaded');
      } else {
        print('⚠️ AuthNotifier: No current user found');
        state = AuthState(); // Clear auth state
      }
    } catch (e) {
      print('❌ AuthNotifier: Failed to load current user - $e');
      state = AuthState(); // Clear auth state on error
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Auth Provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.read(authServiceProvider);
  return AuthNotifier(authService);
});

// Current User Provider (convenience)
final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authProvider).user;
});

// Is Authenticated Provider (convenience)
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAuthenticated;
});

// Auth Loading Provider (convenience)
final authLoadingProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isLoading;
});

// Auth Error Provider (convenience)
final authErrorProvider = Provider<String?>((ref) {
  return ref.watch(authProvider).error;
});
