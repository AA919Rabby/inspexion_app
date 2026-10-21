import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:inspexion_ai/core/theme/all_color.dart';
import 'package:inspexion_ai/global/custom_text.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final String? initialValue;
  final String? Function(String?)? validator;
  final Object? prefixIcon;
  final Object? suffixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final int maxLines;
  final int? maxLength;
  final TextCapitalization textCapitalization;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;
  final Color? fillColor;
  final Color? textColor;
  final Color? hintColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final double? fontSize;
  final FontWeight? fontWeight;
  final bool filled;
  final String? errorText;
  final bool autocorrect;
  final bool enableSuggestions;

  const CustomTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.initialValue,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.maxLength,
    this.textCapitalization = TextCapitalization.none,
    this.onChanged,
    this.onTap,
    this.onSubmitted,
    this.focusNode,
    this.fillColor,
    this.textColor,
    this.hintColor,
    this.borderColor,
    this.focusedBorderColor,
    this.borderRadius,
    this.contentPadding,
    this.fontSize,
    this.fontWeight,
    this.filled = true,
    this.errorText,
    this.autocorrect = true,
    this.enableSuggestions = true,
  });

  Widget? _buildIcon(Object? icon) {
    if (icon == null) {
      return null;
    }

    if (icon is Widget) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: icon,
      );
    }

    if (icon is String) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        child: Center(
          widthFactor: 1.0,
          child: CustomText(
            text: icon,
            fontSize: 14,
            color: hintColor ?? Colors.grey.shade500,
          ),
        ),
      );
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final double radius = borderRadius ?? 14.r;

    return TextFormField(
      controller: controller,
      initialValue: controller == null ? initialValue : null,
      validator: validator,
      obscureText: obscureText,
      enabled: enabled,
      readOnly: readOnly,
      maxLines: obscureText ? 1 : maxLines,
      maxLength: maxLength,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      onChanged: onChanged,
      onTap: onTap,
      onFieldSubmitted: onSubmitted,
      focusNode: focusNode,
      autocorrect: autocorrect,
      enableSuggestions: enableSuggestions,
      style: TextStyle(
        fontSize: fontSize ?? 15,
        fontWeight: fontWeight ?? FontWeight.w500,
        color: textColor ?? AllColor.blackColor,
        letterSpacing: -0.1,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        errorText: errorText,
        filled: filled,
        fillColor: fillColor ?? AllColor.whiteColor,
        hintStyle: TextStyle(
          fontSize: fontSize ?? 14,
          color: hintColor ?? Colors.grey.shade400,
          fontWeight: FontWeight.w400,
        ),
        labelStyle: TextStyle(
          fontSize: fontSize ?? 14,
          color: hintColor ?? Colors.grey.shade500,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: _buildIcon(prefixIcon),
        prefixIconConstraints: BoxConstraints(
          minWidth: 46.w,
          minHeight: 24.h,
        ),
        suffixIcon: _buildIcon(suffixIcon),
        suffixIconConstraints: BoxConstraints(
          minWidth: 46.w,
          minHeight: 24.h,
        ),
        contentPadding: contentPadding ??
            EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 14.h,
            ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(
            color: borderColor ?? Colors.grey.shade300,
            width: 1.w,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(
            color: borderColor ?? Colors.grey.shade300,
            width: 1.w,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(
            color: focusedBorderColor ?? AllColor.blackColor,
            width: 1.6.w,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(
            color: AllColor.redColor,
            width: 1.2.w,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: BorderSide(
            color: AllColor.redColor,
            width: 1.6.w,
          ),
        ),
        errorStyle: TextStyle(
          color: AllColor.redColor,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}