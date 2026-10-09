import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:inspexion_ai/core/theme/all_color.dart';
import 'package:inspexion_ai/global/custom_text.dart';


class SettingsList extends StatelessWidget {
  const SettingsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSettingsList(title: "Profile", icon: Icons.person, color: AllColor.blueColor),
        _buildSettingsList(title: "History", icon: Icons.history_edu_outlined, color: AllColor.blueColor),
        _buildSettingsList(title: "About Us", icon: Icons.info, color: AllColor.blueColor),
        _buildSettingsList(title: "Help & Support", icon: Icons.help, color: AllColor.blueColor),
        _buildSettingsList(title: "Logout", icon: Icons.logout, color: AllColor.redColor),

      ],
    );
  }
  /// settings list
  Widget _buildSettingsList({
    required String title,
    required IconData icon,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () {},
      child: Card(
        color: AllColor.whiteColor,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 12.h,
          ),
          child: Row(
            children: [
              Icon(icon, color: color),
              const Gap(16),
              Expanded(
                child: CustomText(
                  text: title,
                  fontSize: 20,
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
      ),
    );
  }
}
