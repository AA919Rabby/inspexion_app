import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:get/get.dart';
import 'package:inspexion_ai/core/theme/all_color.dart';
import 'package:inspexion_ai/global/custom_text.dart';

void customSnackbar(
    BuildContext context, {
      required String title,
      required String message,
      Color backgroundColor = const Color(0xFF059669), // Modern studio emerald
      bool isError = false,
    }) {
  Get.closeCurrentSnackbar();

  // Modernized High-End Studio Palettes
  final Color activeBgColor = isError
      ? const Color(0xFFE11D48) // Modern Vibrant Crimson (Error)
      : backgroundColor;         // Modern Rich Emerald (Success)

  Get.snackbar(
    title,
    message,
    snackPosition: SnackPosition.TOP,
    backgroundColor: activeBgColor,
    colorText: AllColor.whiteColor,
    borderRadius: 18.r,
    margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
    duration: const Duration(seconds: 3),
    dismissDirection: DismissDirection.up,
    isDismissible: true,

    // Glassmorphic Frost Highlight Border
    borderColor: Colors.white.withValues(alpha: 0.28),
    borderWidth: 1.2.w,

    // Dual-Layer Ambient Glow Drop Shadows
    boxShadows: [
      BoxShadow(
        color: activeBgColor.withValues(alpha: 0.38),
        blurRadius: 22,
        spreadRadius: 1,
        offset: const Offset(0, 8),
      ),
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.15),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],

    // Frosted Circular Icon Container
    icon: Container(
      padding: EdgeInsets.all(8.r),
      margin: EdgeInsets.only(left: 6.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.22),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.4),
          width: 1.w,
        ),
      ),
      child: Center(
        child: Icon(
          isError ? Icons.priority_high_rounded : Icons.check_rounded,
          color: AllColor.whiteColor,
          size: 20.r,
        ),
      ),
    ),

    // High-Contrast Pure White Title
    titleText: Padding(
      padding: EdgeInsets.only(left: 6.w),
      child: CustomText(
        text: title,
        fontWeight: FontWeight.bold,
        fontSize: 15,
        color: AllColor.whiteColor,
      ),
    ),

    // Clean Translucent Message Text
    messageText: Padding(
      padding: EdgeInsets.only(left: 6.w, top: 2.h),
      child: CustomText(
        text: message,
        fontSize: 12,
        color: Colors.white.withValues(alpha: 0.92),
        maxLines: 3,
        softWrap: true,
      ),
    ),
  );
}