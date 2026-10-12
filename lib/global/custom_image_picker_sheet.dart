import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inspexion_ai/core/theme/all_color.dart';
import 'package:inspexion_ai/global/custom_text.dart';

class CustomImagePickerSheet {
  static void show({required Function(ImageSource) onPick}) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 28.h),
        decoration: BoxDecoration(
          color: AllColor.whiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28.r),
            topRight: Radius.circular(28.r),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 20,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Grab Handle
              Container(
                height: 4.5.h,
                width: 44.w,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              const Gap(18),

              // Title Header
              CustomText(
                text: "Select Asset Photo",
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AllColor.blackColor,
              ),
              const Gap(4),
              CustomText(
                text: "Choose photo capture mode",
                fontSize: 12,
                color: Colors.grey.shade500,
                textAlign: TextAlign.center,
              ),
              const Gap(22),

              // Commercial Option Cards
              Row(
                children: [
                  Expanded(
                    child: _buildOptionCard(
                      icon: Icons.camera_alt_rounded,
                      title: "Camera",
                      subtitle: "Take live photo",
                      accentColor: AllColor.blueColor,
                      onTap: () {
                        Get.back();
                        onPick(ImageSource.camera);
                      },
                    ),
                  ),
                  const Gap(14),
                  Expanded(
                    child: _buildOptionCard(
                      icon: Icons.photo_library_rounded,
                      title: "Gallery",
                      subtitle: "Choose from device",
                      accentColor: const Color(0xFF00B4D8),
                      onTap: () {
                        Get.back();
                        onPick(ImageSource.gallery);
                      },
                    ),
                  ),
                ],
              ),
              const Gap(10),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  static Widget _buildOptionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 12.w),
        decoration: BoxDecoration(
          color: AllColor.greyColor300.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: Colors.grey.shade200,
            width: 1.w,
          ),
        ),
        child: Column(
          children: [
            Container(
              height: 54.r,
              width: 54.r,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: accentColor, size: 26.r),
            ),
            const Gap(12),
            CustomText(
              text: title,
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AllColor.blackColor,
            ),
            const Gap(2),
            CustomText(
              text: subtitle,
              fontSize: 11,
              color: Colors.grey.shade600,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}