import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../constants/ui_constants.dart';

enum TextFieldSize { small, medium, large }

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onSuffixIconPressed;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final bool required;
  final int maxLines;
  final int? maxLength;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final TextFieldSize size;
  final bool showCounter; // ✅ ADD THIS PARAMETER

  const CustomTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.required = false,
    this.maxLines = 1,
    this.maxLength,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.onTap,
    this.size = TextFieldSize.medium,
    this.showCounter = false, // ✅ ADD THIS PARAMETER
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          _buildLabel(),
          SizedBox(height: UiConstants.labelSpacing),
        ],
        _buildTextField(),
      ],
    );
  }

  Widget _buildLabel() {
    return Row(
      children: [
        Text(
          label!,
          style: TextStyle(
            fontSize: _getLabelFontSize(),
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            height: 1.2,
          ),
        ),
        if (required) ...[
          SizedBox(width: UiConstants.spacingTiny),
          Text(
            '*',
            style: TextStyle(
              fontSize: _getLabelFontSize(),
              fontWeight: FontWeight.w600,
              color: AppColors.error,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTextField() {
    return Container(
      height: maxLines == 1 ? _getFieldHeight() : null,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        enabled: enabled,
        readOnly: readOnly,
        maxLines: maxLines,
        maxLength: maxLength,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        validator: validator,
        onChanged: onChanged,
        onTap: onTap,
        style: _getInputTextStyle(),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: _getHintTextStyle(),
          helperText: helperText,
          helperStyle: _getHelperTextStyle(),
          errorText: errorText,
          errorStyle: _getErrorTextStyle(),
          prefixIcon: _buildPrefixIcon(),
          suffixIcon: _buildSuffixIcon(),
          border: _getInputBorder(),
          enabledBorder: _getInputBorder(),
          focusedBorder: _getFocusedBorder(),
          errorBorder: _getErrorBorder(),
          focusedErrorBorder: _getErrorBorder(),
          disabledBorder: _getDisabledBorder(),
          filled: true,
          fillColor: _getFillColor(),
          contentPadding: _getContentPadding(),
          counterStyle: showCounter ? _getCounterTextStyle() : null,
          counterText: showCounter
              ? null
              : '', // ✅ HIDE COUNTER WHEN NOT NEEDED
        ),
      ),
    );
  }

  Widget? _buildPrefixIcon() {
    if (prefixIcon == null) return null;

    return Container(
      padding: EdgeInsets.only(
        left: _getHorizontalPadding(),
        right: UiConstants.spacingSmall,
      ),
      child: Icon(
        prefixIcon,
        color: enabled
            ? AppColors.textTertiary
            : AppColors.textTertiary.withOpacity(0.5),
        size: _getIconSize(),
      ),
    );
  }

  Widget? _buildSuffixIcon() {
    if (suffixIcon == null) return null;

    return Container(
      padding: EdgeInsets.only(
        right: _getHorizontalPadding(),
        left: UiConstants.spacingSmall,
      ),
      child: suffixIcon,
    );
  }

  // Size-based getters
  double _getFieldHeight() {
    switch (size) {
      case TextFieldSize.small:
        return UiConstants.inputHeightSmall;
      case TextFieldSize.medium:
        return UiConstants.inputHeightMedium;
      case TextFieldSize.large:
        return UiConstants.inputHeightLarge;
    }
  }

  double _getInputFontSize() {
    switch (size) {
      case TextFieldSize.small:
        return UiConstants.textSmall;
      case TextFieldSize.medium:
        return UiConstants.textMedium;
      case TextFieldSize.large:
        return UiConstants.textLarge;
    }
  }

  double _getLabelFontSize() {
    switch (size) {
      case TextFieldSize.small:
        return UiConstants.textBody;
      case TextFieldSize.medium:
        return UiConstants.textMedium;
      case TextFieldSize.large:
        return UiConstants.textLarge;
    }
  }

  double _getIconSize() {
    switch (size) {
      case TextFieldSize.small:
        return UiConstants.iconSmall;
      case TextFieldSize.medium:
        return UiConstants.iconMedium;
      case TextFieldSize.large:
        return UiConstants.iconLarge;
    }
  }

  double _getHorizontalPadding() {
    switch (size) {
      case TextFieldSize.small:
        return UiConstants.spacingMedium;
      case TextFieldSize.medium:
        return UiConstants.spacingLarge;
      case TextFieldSize.large:
        return UiConstants.spacingXLarge;
    }
  }

  double _getVerticalPadding() {
    switch (size) {
      case TextFieldSize.small:
        return UiConstants.spacingSmall;
      case TextFieldSize.medium:
        return UiConstants.spacingMedium;
      case TextFieldSize.large:
        return UiConstants.spacingLarge;
    }
  }

  // Text Styles - ✅ CONSISTENT FONT FAMILY
  TextStyle _getInputTextStyle() {
    return AppTextStyles.bodyMedium.copyWith(
      fontSize: _getInputFontSize(),
      fontWeight: FontWeight.w500,
      color: enabled ? AppColors.textPrimary : AppColors.textSecondary,
      height: 1.4,
    );
  }

  TextStyle _getHintTextStyle() {
    return AppTextStyles.bodyMedium.copyWith(
      fontSize: _getInputFontSize(),
      fontWeight: FontWeight.w400,
      color: AppColors.textTertiary,
      height: 1.4,
    );
  }

  TextStyle _getHelperTextStyle() {
    return AppTextStyles.bodySmall.copyWith(
      fontSize: UiConstants.textSmall,
      fontWeight: FontWeight.w400,
      color: AppColors.textSecondary,
      height: 1.3,
    );
  }

  TextStyle _getErrorTextStyle() {
    return AppTextStyles.bodySmall.copyWith(
      fontSize: UiConstants.textSmall,
      fontWeight: FontWeight.w500,
      color: AppColors.error,
      height: 1.3,
    );
  }

  TextStyle _getCounterTextStyle() {
    return AppTextStyles.bodySmall.copyWith(
      fontSize: UiConstants.textTiny,
      fontWeight: FontWeight.w400,
      color: AppColors.textTertiary,
    );
  }

  // Padding
  EdgeInsets _getContentPadding() {
    return EdgeInsets.symmetric(
      horizontal: _getHorizontalPadding(),
      vertical: _getVerticalPadding(),
    );
  }

  // Colors
  Color _getFillColor() {
    if (!enabled) return AppColors.background;
    return Colors.white;
  }

  // Borders
  OutlineInputBorder _getInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(UiConstants.radiusMedium),
      borderSide: BorderSide(color: AppColors.border, width: 1.5),
    );
  }

  OutlineInputBorder _getFocusedBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(UiConstants.radiusMedium),
      borderSide: BorderSide(color: AppColors.primary, width: 2.0),
    );
  }

  OutlineInputBorder _getErrorBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(UiConstants.radiusMedium),
      borderSide: BorderSide(color: AppColors.error, width: 2.0),
    );
  }

  OutlineInputBorder _getDisabledBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(UiConstants.radiusMedium),
      borderSide: BorderSide(
        color: AppColors.border.withOpacity(0.5),
        width: 1.0,
      ),
    );
  }
}

// ✅ UPDATED HELPER FUNCTION WITH showCounter PARAMETER
CustomTextField buildStandardTextField({
  required TextEditingController controller,
  required String label,
  required String placeholder,
  required IconData icon,
  bool required = false,
  TextFieldSize size = TextFieldSize.medium,
  TextInputType keyboardType = TextInputType.text,
  List<TextInputFormatter>? inputFormatters,
  String? Function(String?)? validator,
  void Function(String)? onChanged,
  int maxLines = 1,
  int? maxLength,
  bool enabled = true,
  String? helperText,
  bool showCounter = false, // ✅ ADD THIS PARAMETER
}) {
  return CustomTextField(
    controller: controller,
    label: label,
    hint: placeholder,
    prefixIcon: icon,
    required: required,
    size: size,
    keyboardType: keyboardType,
    inputFormatters: inputFormatters,
    validator: validator,
    onChanged: onChanged,
    maxLines: maxLines,
    maxLength: maxLength,
    enabled: enabled,
    helperText: helperText,
    showCounter: showCounter, // ✅ PASS THE PARAMETER
  );
}
