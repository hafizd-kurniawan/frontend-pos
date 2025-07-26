import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/ui_constants.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/custom_button.dart';
import '../../providers/auth_provider.dart';
import '../cashier/dashboard/cashier_dashboard_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  String _selectedRole = 'cashier';
  bool _isPasswordVisible = false;
  bool _isLoading = false; // ✅ ADD THIS VARIABLE

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listen to auth state changes
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.isAuthenticated) {
        // Navigate to dashboard on successful login
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const CashierDashboardScreen(),
          ),
        );
      } else if (next.error != null) {
        // Show error message
        _showErrorSnackBar(next.error!);
      }
    });

    final authState = ref.watch(authProvider);
    _isLoading = authState.isLoading; // ✅ UPDATE LOADING STATE

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary,
              AppColors.primary.withOpacity(0.8),
              AppColors.primaryLight.withOpacity(0.6),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(UiConstants.spacingMassive),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLogo(),
                  SizedBox(height: UiConstants.spacingGiant),
                  _buildLoginCard(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(UiConstants.radiusHuge),
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
          ),
          child: Icon(
            IconsaxPlusBold.car,
            size: UiConstants.iconMassive,
            color: Colors.white,
          ),
        ),
        SizedBox(height: UiConstants.spacingLarge),
        Text(
          'Vehicle Showroom',
          style: AppTextStyles.displayMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: UiConstants.spacingSmall),
        Text(
          'Management System',
          style: AppTextStyles.bodyLarge.copyWith(
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginCard() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 400),
      padding: EdgeInsets.all(UiConstants.spacingMassive),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(UiConstants.radiusXLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCardHeader(),
            SizedBox(height: UiConstants.spacingHuge),
            _buildRoleSelector(),
            SizedBox(height: UiConstants.spacingXLarge),
            _buildUsernameField(),
            SizedBox(height: UiConstants.spacingLarge),
            _buildPasswordField(),
            SizedBox(height: UiConstants.spacingHuge),
            _buildLoginButton(),
            SizedBox(height: UiConstants.spacingLarge),
            _buildDemoCredentials(),
          ],
        ),
      ),
    );
  }

  Widget _buildCardHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome Back!',
          style: AppTextStyles.headlineLarge.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: UiConstants.spacingSmall),
        Text(
          'Sign in to access your dashboard',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildRoleSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Login as',
          style: AppTextStyles.formLabel.copyWith(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: UiConstants.spacingMedium),
        Row(
          children: [
            Expanded(
              child: _buildRoleOption(
                'cashier',
                'Cashier',
                IconsaxPlusBold.money_send,
              ),
            ),
            SizedBox(width: UiConstants.spacingMedium),
            Expanded(
              child: _buildRoleOption(
                'admin',
                'Admin',
                IconsaxPlusBold.setting_2,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRoleOption(String role, String label, IconData icon) {
    final isSelected = _selectedRole == role;

    return GestureDetector(
      onTap: () => setState(() => _selectedRole = role),
      child: Container(
        padding: EdgeInsets.all(UiConstants.spacingLarge),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : AppColors.background,
          borderRadius: BorderRadius.circular(UiConstants.radiusMedium),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: UiConstants.iconLarge,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
            SizedBox(height: UiConstants.spacingSmall),
            Text(
              label,
              style: AppTextStyles.labelMedium.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsernameField() {
    return CustomTextField(
      controller: _usernameController,
      label: 'Username',
      hint: UiConstants.placeholders['username']!,
      prefixIcon: IconsaxPlusBold.user,
      required: true,
      size: TextFieldSize.large,
      validator: (value) {
        if (value?.isEmpty == true) {
          return UiConstants.errorMessages['required'];
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return CustomTextField(
      controller: _passwordController,
      label: 'Password',
      hint: UiConstants.placeholders['password']!,
      prefixIcon: IconsaxPlusBold.lock,
      suffixIcon: IconButton(
        onPressed: () =>
            setState(() => _isPasswordVisible = !_isPasswordVisible),
        icon: Icon(
          _isPasswordVisible ? IconsaxPlusBold.eye : IconsaxPlusBold.eye_slash,
          color: AppColors.textTertiary,
          size: UiConstants.iconMedium,
        ),
      ),
      obscureText: !_isPasswordVisible,
      required: true,
      size: TextFieldSize.large,
      validator: (value) {
        if (value?.isEmpty == true) {
          return UiConstants.errorMessages['required'];
        }
        if (value!.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }

  Widget _buildLoginButton() {
    return CustomButton(
      text: 'Sign In as ${_selectedRole.toUpperCase()}',
      onPressed: _isLoading ? null : _handleLogin, // ✅ NOW USING _handleLogin
      type: _selectedRole == 'cashier'
          ? ButtonType.primary
          : ButtonType.warning,
      variant: ButtonVariant.filled,
      size: ButtonSize.large,
      icon: IconsaxPlusBold.login,
      isLoading: _isLoading,
      isFullWidth: true,
      backgroundColor: _selectedRole == 'cashier'
          ? AppColors.primary
          : AppColors.warning,
    );
  }

  Widget _buildDemoCredentials() {
    return Container(
      padding: EdgeInsets.all(UiConstants.spacingLarge),
      decoration: BoxDecoration(
        color: AppColors.info.withOpacity(0.1),
        borderRadius: BorderRadius.circular(UiConstants.radiusMedium),
        border: Border.all(color: AppColors.info.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                IconsaxPlusBold.info_circle,
                size: UiConstants.iconMedium,
                color: AppColors.info,
              ),
              SizedBox(width: UiConstants.spacingSmall),
              Text(
                'Demo Credentials',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.info,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: UiConstants.spacingMedium),
          _buildCredentialRow('Cashier', 'cashier1', 'admin123'),
          SizedBox(height: UiConstants.spacingSmall),
          _buildCredentialRow('Admin', 'admin', 'admin123'),
        ],
      ),
    );
  }

  Widget _buildCredentialRow(String role, String username, String password) {
    return Row(
      children: [
        SizedBox(
          width: 60,
          child: Text(
            '$role:',
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          '$username / $password',
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontFamily: 'monospace',
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () => _fillCredentials(username, password),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: UiConstants.spacingSmall,
              vertical: UiConstants.spacingTiny,
            ),
            decoration: BoxDecoration(
              color: AppColors.info.withOpacity(0.1),
              borderRadius: BorderRadius.circular(UiConstants.radiusSmall),
            ),
            child: Text(
              'Use',
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.info,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ✅ ADD THIS METHOD
  void _fillCredentials(String username, String password) {
    _usernameController.text = username;
    _passwordController.text = password;

    // Auto-select role based on username
    setState(() {
      _selectedRole = username.contains('admin') ? 'admin' : 'cashier';
    });
  }

  // ✅ ADD THIS METHOD
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      _showErrorSnackBar('Please fill all required fields correctly');
      return;
    }

    // Clear any previous errors
    ref.read(authProvider.notifier).clearError();

    // Attempt login
    final success = await ref
        .read(authProvider.notifier)
        .login(
          username: _usernameController.text.trim(),
          password: _passwordController.text,
        );

    if (success) {
      // Success handling is done in the listener above
      _showSuccessSnackBar('Login successful! Welcome back.');
    }
    // Error handling is done in the listener above
  }

  void _showSuccessSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(IconsaxPlusBold.tick_circle, color: Colors.white),
            SizedBox(width: UiConstants.spacingMedium),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(IconsaxPlusBold.warning_2, color: Colors.white),
            SizedBox(width: UiConstants.spacingMedium),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
