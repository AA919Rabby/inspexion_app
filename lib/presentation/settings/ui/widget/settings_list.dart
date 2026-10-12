import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:inspexion_ai/all_route.dart';
import 'package:inspexion_ai/core/theme/all_color.dart';
import 'package:inspexion_ai/global/custom_dialog.dart';
import 'package:inspexion_ai/global/custom_text.dart';
import 'package:get/get.dart';
import 'package:inspexion_ai/presentation/auth/controller/auth_controller.dart';
import 'package:inspexion_ai/presentation/settings/controller/settings_controller.dart';

class SettingsList extends StatelessWidget {
  const SettingsList({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsController = Get.find<SettingsController>();
    final authController = Get.find<AuthController>();

    return Column(
      children: [
        _buildSettingsList(
          title: "Edit Profile",
          subtitle: "Manage personal details & avatar",
          icon: Icons.person_outline_rounded,
          color: AllColor.blueColor,
          onTap: () async {
            await Future.delayed(const Duration(milliseconds: 200));
            await Get.toNamed(AllRoute.profile);
            settingsController.selectedItem.value = "";
          },
        ),
        _buildSettingsList(
          title: "History",
          subtitle: "Past audit records & downloaded PDFs",
          icon: Icons.history_edu_outlined,
          color: AllColor.blueColor,
          onTap: () async {
            await Future.delayed(const Duration(milliseconds: 200));
            await Get.toNamed(AllRoute.historyScreen);
            settingsController.selectedItem.value = "";
          },
        ),
        _buildSettingsList(
          title: "About Us",
          subtitle: "Company info, terms & licenses",
          icon: Icons.info_outline_rounded,
          color: AllColor.blueColor,
          onTap: () async {
            await Future.delayed(const Duration(milliseconds: 200));
            await Get.toNamed(AllRoute.aboutUs);
            settingsController.selectedItem.value = "";
          },
        ),
        _buildSettingsList(
          title: "Help & Support",
          subtitle: "Customer service & contact desk",
          icon: Icons.support_agent_rounded,
          color: AllColor.blueColor,
          onTap: () async {
            await Future.delayed(const Duration(milliseconds: 200));
            await Get.toNamed(AllRoute.support);
            settingsController.selectedItem.value = "";
          },
        ),
        const Gap(6),
        _buildSettingsList(
          title: "Logout",
          subtitle: "Sign out of your account",
          icon: Icons.logout_rounded,
          color: AllColor.redColor,
          onTap: () async {
            await Future.delayed(const Duration(milliseconds: 200));
            await CustomDialog.show(
              context: context,
              backgroundColor: AllColor.whiteColor,
              title: "Logout",
              titleColor: AllColor.blackColor,
              message: "Are you sure you want to log out of your account?",
              messageColor: AllColor.blackColor,
              confirmText: "Yes",
              cancelText: "No",
              cancelColor: AllColor.blueColor,
              onConfirm: () {
                Get.back();
                authController.logout();
              },
              onCancel: () {
                Get.back();
              },
            );
            settingsController.selectedItem.value = "";
          },
        ),
      ],
    );
  }

  Widget _buildSettingsList({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Obx(() {
      final settingsController = Get.find<SettingsController>();
      final isSelected = settingsController.selectedItem.value == title;

      return GestureDetector(
        onTap: () {
          settingsController.selectedItem.value = title;
          onTap();
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          margin: EdgeInsets.only(bottom: 10.h),
          decoration: BoxDecoration(
            color: AllColor.whiteColor,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isSelected ? color : Colors.white,
              width: isSelected ? 1.5.w : 1.w,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isSelected ? 0.08 : 0.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              // Tinted Pill Icon Container
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(icon, color: color, size: 22.r),
              ),
              const Gap(14),

              // Title and Subtitle Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: title,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? color : AllColor.blackColor,
                    ),
                    const Gap(2),
                    CustomText(
                      text: subtitle,
                      fontSize: 12,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),
              ),

              // Right Arrow Chevron Badge
              Container(
                padding: EdgeInsets.all(6.r),
                decoration: BoxDecoration(
                  color: isSelected
                      ? color.withValues(alpha: 0.1)
                      : AllColor.greyColor300.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: isSelected ? color : AllColor.greyColor400,
                  size: 13.r,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}