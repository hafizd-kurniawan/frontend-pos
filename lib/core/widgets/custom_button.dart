import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../constants/ui_constants.dart';

enum ButtonType { primary, secondary, outline, text, danger, success, warning }

enum ButtonSize { small, medium, large }

enum ButtonVariant { filled, outlined, text }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final ButtonSize size;
  final ButtonVariant variant; // ✅ ADD THIS
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final Color? backgroundColor; // ✅ ADD THIS

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.size = ButtonSize.medium,
    this.variant = ButtonVariant.filled, // ✅ ADD THIS
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.backgroundColor, // ✅ ADD THIS
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: _getButtonHeight(),
      child: _buildButton(),
    );
  }

  Widget _buildButton() {
    // Use custom backgroundColor if provided, otherwise use type-based color
    final effectiveBackgroundColor = backgroundColor ?? _getTypeColor();

    switch (variant) {
      case ButtonVariant.filled:
        return _buildFilledButton(effectiveBackgroundColor);
      case ButtonVariant.outlined:
        return _buildOutlinedButton(effectiveBackgroundColor);
      case ButtonVariant.text:
        return _buildTextButton(effectiveBackgroundColor);
    }
  }

  Color _getTypeColor() {
    switch (type) {
      case ButtonType.primary:
        return AppColors.primary;
      case ButtonType.secondary:
        return AppColors.secondary;
      case ButtonType.outline:
        return AppColors.primary;
      case ButtonType.text:
        return AppColors.primary;
      case ButtonType.danger:
        return AppColors.error;
      case ButtonType.success:
        return AppColors.success;
      case ButtonType.warning:
        return AppColors.warning;
    }
  }

  Color _getTextColor(Color bgColor) {
    // Return white for dark backgrounds, dark for light backgrounds
    final luminance = bgColor.computeLuminance();
    return luminance > 0.5 ? AppColors.textPrimary : Colors.white;
  }

  Widget _buildFilledButton(Color bgColor) {
    final textColor = _getTextColor(bgColor);

    return ElevatedButton.icon(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: textColor,
        disabledBackgroundColor: bgColor.withOpacity(0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_getBorderRadius()),
        ),
        elevation: 2,
        padding: _getPadding(),
      ),
      icon: _buildIcon(textColor),
      label: _buildLabel(textColor),
    );
  }

  Widget _buildOutlinedButton(Color borderColor) {
    return OutlinedButton.icon(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: borderColor,
        disabledForegroundColor: borderColor.withOpacity(0.5),
        side: BorderSide(
          color: onPressed != null ? borderColor : AppColors.border,
          width: 2,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_getBorderRadius()),
        ),
        padding: _getPadding(),
      ),
      icon: _buildIcon(borderColor),
      label: _buildLabel(borderColor),
    );
  }

  Widget _buildTextButton(Color textColor) {
    return TextButton.icon(
      onPressed: isLoading ? null : onPressed,
      style: TextButton.styleFrom(
        foregroundColor: textColor,
        disabledForegroundColor: textColor.withOpacity(0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_getBorderRadius()),
        ),
        padding: _getPadding(),
      ),
      icon: _buildIcon(textColor),
      label: _buildLabel(textColor),
    );
  }

  Widget _buildIcon(Color color) {
    if (isLoading) {
      return SizedBox(
        width: _getIconSize(),
        height: _getIconSize(),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(color),
          strokeWidth: 2,
        ),
      );
    }

    if (icon == null) return const SizedBox.shrink();

    return Icon(icon, size: _getIconSize(), color: color);
  }

  Widget _buildLabel(Color color) {
    return Text(
      text,
      style: AppTextStyles.buttonMedium.copyWith(
        fontSize: _getFontSize(),
        fontWeight: FontWeight.w600,
        color: color,
      ),
    );
  }

  // Size-based getters
  double _getButtonHeight() {
    switch (size) {
      case ButtonSize.small:
        return UiConstants.buttonHeightSmall;
      case ButtonSize.medium:
        return UiConstants.buttonHeightMedium;
      case ButtonSize.large:
        return UiConstants.buttonHeightLarge;
    }
  }

  double _getFontSize() {
    switch (size) {
      case ButtonSize.small:
        return UiConstants.textSmall;
      case ButtonSize.medium:
        return UiConstants.textMedium;
      case ButtonSize.large:
        return UiConstants.textLarge;
    }
  }

  double _getIconSize() {
    switch (size) {
      case ButtonSize.small:
        return UiConstants.iconSmall;
      case ButtonSize.medium:
        return UiConstants.iconMedium;
      case ButtonSize.large:
        return UiConstants.iconLarge;
    }
  }

  double _getBorderRadius() {
    switch (size) {
      case ButtonSize.small:
        return UiConstants.radiusSmall;
      case ButtonSize.medium:
        return UiConstants.radiusMedium;
      case ButtonSize.large:
        return UiConstants.radiusLarge;
    }
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case ButtonSize.small:
        return EdgeInsets.symmetric(
          horizontal: UiConstants.spacingMedium,
          vertical: UiConstants.spacingSmall,
        );
      case ButtonSize.medium:
        return EdgeInsets.symmetric(
          horizontal: UiConstants.spacingLarge,
          vertical: UiConstants.spacingMedium,
        );
      case ButtonSize.large:
        return EdgeInsets.symmetric(
          horizontal: UiConstants.spacingXLarge,
          vertical: UiConstants.spacingLarge,
        );
    }
  }
}

// ✅ UPDATED HELPER FUNCTIONS WITH NEW PARAMETERS
CustomButton buildPrimaryButton({
  required String text,
  required VoidCallback? onPressed,
  IconData? icon,
  ButtonSize size = ButtonSize.medium,
  bool isLoading = false,
  bool isFullWidth = false,
  Color? backgroundColor,
}) {
  return CustomButton(
    text: text,
    onPressed: onPressed,
    type: ButtonType.primary,
    variant: ButtonVariant.filled,
    size: size,
    icon: icon,
    isLoading: isLoading,
    isFullWidth: isFullWidth,
    backgroundColor: backgroundColor,
  );
}

CustomButton buildSecondaryButton({
  required String text,
  required VoidCallback? onPressed,
  IconData? icon,
  ButtonSize size = ButtonSize.medium,
  bool isLoading = false,
  bool isFullWidth = false,
  Color? backgroundColor,
}) {
  return CustomButton(
    text: text,
    onPressed: onPressed,
    type: ButtonType.primary,
    variant: ButtonVariant.outlined,
    size: size,
    icon: icon,
    isLoading: isLoading,
    isFullWidth: isFullWidth,
    backgroundColor: backgroundColor,
  );
}

CustomButton buildDangerButton({
  required String text,
  required VoidCallback? onPressed,
  IconData? icon,
  ButtonSize size = ButtonSize.medium,
  bool isLoading = false,
  bool isFullWidth = false,
  Color? backgroundColor,
}) {
  return CustomButton(
    text: text,
    onPressed: onPressed,
    type: ButtonType.danger,
    variant: ButtonVariant.filled,
    size: size,
    icon: icon,
    isLoading: isLoading,
    isFullWidth: isFullWidth,
    backgroundColor: backgroundColor,
  );
}

CustomButton buildWarningButton({
  required String text,
  required VoidCallback? onPressed,
  IconData? icon,
  ButtonSize size = ButtonSize.medium,
  bool isLoading = false,
  bool isFullWidth = false,
  Color? backgroundColor,
}) {
  return CustomButton(
    text: text,
    onPressed: onPressed,
    type: ButtonType.warning,
    variant: ButtonVariant.filled,
    size: size,
    icon: icon,
    isLoading: isLoading,
    isFullWidth: isFullWidth,
    backgroundColor: backgroundColor,
  );
}

CustomButton buildSuccessButton({
  required String text,
  required VoidCallback? onPressed,
  IconData? icon,
  ButtonSize size = ButtonSize.medium,
  bool isLoading = false,
  bool isFullWidth = false,
  Color? backgroundColor,
}) {
  return CustomButton(
    text: text,
    onPressed: onPressed,
    type: ButtonType.success,
    variant: ButtonVariant.filled,
    size: size,
    icon: icon,
    isLoading: isLoading,
    isFullWidth: isFullWidth,
    backgroundColor: backgroundColor,
  );
}

CustomButton buildTextButton({
  required String text,
  required VoidCallback? onPressed,
  IconData? icon,
  ButtonSize size = ButtonSize.medium,
  bool isLoading = false,
  bool isFullWidth = false,
  Color? backgroundColor,
}) {
  return CustomButton(
    text: text,
    onPressed: onPressed,
    type: ButtonType.primary,
    variant: ButtonVariant.text,
    size: size,
    icon: icon,
    isLoading: isLoading,
    isFullWidth: isFullWidth,
    backgroundColor: backgroundColor,
  );
}
