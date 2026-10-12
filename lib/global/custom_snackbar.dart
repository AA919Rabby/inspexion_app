import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:get/get.dart';
import 'package:inspexion_ai/core/theme/all_color.dart';
import 'package:inspexion_ai/global/custom_text.dart';

void customSnackbar(
    BuildContext context, {
      required String title,
      required String message,
      Color backgroundColor = const Color(0xFF10B981), // Emerald green default
      bool isError = false,
    }) {
  Get.closeCurrentSnackbar();

  final Color primaryColor = isError ? AllColor.redColor : backgroundColor;

  Get.snackbar(
    title,
    message,
    snackPosition: SnackPosition.TOP,
    backgroundColor: const Color(0xFF0F172A), // Luxury dark slate banner
    colorText: AllColor.whiteColor,
    borderRadius: 16.r,
    margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
    duration: const Duration(seconds: 3),
    dismissDirection: DismissDirection.up,
    isDismissible: true,
    borderColor: primaryColor.withValues(alpha: 0.4),
    borderWidth: 1.5.w,
    boxShadows: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.25),
        blurRadius: 16,
        offset: const Offset(0, 6),
      ),
    ],
    icon: Container(
      padding: EdgeInsets.all(8.r),
      margin: EdgeInsets.only(left: 6.w),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.15),
        shape: BoxShape.circle,
        border: Border.all(
          color: primaryColor.withValues(alpha: 0.35),
          width: 1.w,
        ),
      ),
      child: Icon(
        isError ? Icons.error_outline_rounded : Icons.check_circle_outline_rounded,
        color: primaryColor,
        size: 22.r,
      ),
    ),
    titleText: Padding(
      padding: EdgeInsets.only(left: 4.w),
      child: CustomText(
        text: title,
        fontWeight: FontWeight.bold,
        fontSize: 15,
        color: AllColor.whiteColor,
      ),
    ),
    messageText: Padding(
      padding: EdgeInsets.only(left: 4.w, top: 2.h),
      child: CustomText(
        text: message,
        fontSize: 12,
        color: Colors.grey.shade400,
        maxLines: 3,
        softWrap: true,
      ),
    ),
  );
}