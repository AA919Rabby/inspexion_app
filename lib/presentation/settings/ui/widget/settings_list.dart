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
    final authController=Get.find<AuthController>();
    return Column(
      children: [
        _buildSettingsList(title: "Edit Profile", icon: Icons.edit_note_rounded, color: AllColor.blueColor,onTap: (){
          Get.toNamed(AllRoute.profile);
        }),
        _buildSettingsList(title: "History", icon: Icons.history_edu_outlined, color: AllColor.blueColor,
            onTap: (){
          Get.toNamed(AllRoute.historyScreen);
            }
        ),
        _buildSettingsList(title: "About Us", icon: Icons.info, color: AllColor.blueColor,onTap: (){
          Get.toNamed(AllRoute.aboutUs);
        }),
        _buildSettingsList(title: "Help & Support", icon: Icons.help, color: AllColor.blueColor,onTap: (){
          Get.toNamed(AllRoute.support);
        }),
        _buildSettingsList(title: "Logout", icon: Icons.logout, color: AllColor.redColor,onTap: (){
          CustomDialog.show(
           /// content: Icon(Icons.logout,color: AllColor.redColor,size: 40.r,),
            context: context,
            backgroundColor: AllColor.whiteColor,
            title: "Logout",
            titleColor: AllColor.blackColor,
            message: "Are you sure you want to log out?",
            messageColor: AllColor.blackColor,
            confirmText: "Yes",
            cancelText: "No",
            cancelColor: AllColor.blueColor,
            onConfirm: () {
              Get.back(); // Close Dialog
              authController.logout(); // Trigger clean logout
            },
            onCancel: () {
              Get.back();
              // Optional: Handle cancel action
            },
          );
        }),

      ],
    );
  }
  /// settings list
  Widget _buildSettingsList({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Obx((){
      final settingsController=Get.find<SettingsController>();
      final isSelected=settingsController.selectedItem.value == title;
      return GestureDetector(
        onTap: (){
          settingsController.selectedItem.value=title;
          onTap();
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 12.h,
          ),
          margin: EdgeInsets.only(bottom: 5.h),
          decoration: BoxDecoration(
              color: AllColor.whiteColor,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: isSelected?AllColor.blueColor:Colors.transparent,
                  width: isSelected?2.w:0)
          ),
          child: Row(
            children: [
              Icon(icon, color: color),
              const Gap(16),
              Expanded(
                child: CustomText(
                  text: title,
                  fontSize: 17,
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: isSelected?AllColor.blueColor:AllColor.greyColor400,
                size: 15.r,
              ),
            ],
          ),
        ),
      );
    });
  }
}
