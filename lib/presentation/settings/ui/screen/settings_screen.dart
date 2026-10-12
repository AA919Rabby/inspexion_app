import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:inspexion_ai/core/theme/all_color.dart';
import 'package:inspexion_ai/global/custom_text.dart';
import 'package:inspexion_ai/presentation/settings/ui/widget/settings_list.dart';


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AllColor.greyColor300,
      appBar: AppBar(
        backgroundColor: AllColor.blueColor,
        scrolledUnderElevation: 0,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 70.h,
        title: CustomText(
          text: "Settings & Preferences",
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AllColor.whiteColor,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section Sub-header
                Padding(
                  padding: EdgeInsets.only(left: 4.w, bottom: 12.h),
                  child: CustomText(
                    text: "Account & Application",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
                ),

                // Settings List
                const SettingsList(),

                const Gap(30),

                Center(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: AllColor.whiteColor,
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(color: Colors.white, width: 1.w),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8.r,
                              height: 8.r,
                              decoration: BoxDecoration(
                                color: AllColor.yellowColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const Gap(8),
                            CustomText(
                              text: "InspeXion AI v1.0.0",
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AllColor.blackColor,
                            ),
                          ],
                        ),
                      ),
                      const Gap(8),
                      CustomText(
                        text: "Enterprise Asset Inspection System",
                        fontSize: 11,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
                const Gap(20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}