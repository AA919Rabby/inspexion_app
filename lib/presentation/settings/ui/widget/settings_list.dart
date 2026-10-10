import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:inspexion_ai/all_route.dart';
import 'package:inspexion_ai/core/theme/all_color.dart';
import 'package:inspexion_ai/global/custom_text.dart';
import 'package:get/get.dart';



class SettingsList extends StatelessWidget {
  const SettingsList({super.key});

  @override
  Widget build(BuildContext context) {
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
        _buildSettingsList(title: "Logout", icon: Icons.logout, color: AllColor.redColor,onTap: (){}),

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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 12.h,
        ),
        decoration: BoxDecoration(
          color: AllColor.whiteColor,
         borderRadius: BorderRadius.circular(12.r),
         // border: Border.all(color: AllColor.)
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
            const Gap(16),
            Expanded(
              child: CustomText(
                text: title,
                fontSize: 18,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AllColor.blueColor,
              size: 15.r,
            ),
          ],
        ),
      ),
    );
  }
}
