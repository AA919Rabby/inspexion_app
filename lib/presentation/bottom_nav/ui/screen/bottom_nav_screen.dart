import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inspexion_ai/core/theme/all_color.dart';
import 'package:inspexion_ai/global/custom_image_picker_sheet.dart';
import 'package:inspexion_ai/global/custom_text.dart';
import 'package:inspexion_ai/presentation/bottom_nav/controller/bottom_nav_controller.dart';
import 'package:inspexion_ai/presentation/history/controller/history_controller.dart';

class BottomNavScreen extends StatelessWidget {
  const BottomNavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomNavController = Get.find<BottomNavController>();

    // CRITICAL FIX: permanent: true ensures the controller instance is shared everywhere
    final historyController = Get.isRegistered<HistoryController>()
        ? Get.find<HistoryController>()
        : Get.put(HistoryController(), permanent: true);

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: Obx(
            () => Stack(
          children: [
            IndexedStack(
              index: bottomNavController.selectedIndex.value,
              children: bottomNavController.pages,
            ),

            if (historyController.isInspecting.value)
              Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black.withValues(alpha: 0.78),
                child: Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 28.w),
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 28.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(24.r),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.12),
                        width: 1.5.w,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                          decoration: BoxDecoration(
                            color: AllColor.blueColor.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: AllColor.blueColor.withValues(alpha: 0.4),
                            ),
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
                              const Gap(6),
                              CustomText(
                                text: "AI VISION RUNNING",
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AllColor.whiteColor,
                              ),
                            ],
                          ),
                        ),
                        const Gap(22),
                        const CircularProgressIndicator(),
                        const Gap(20),
                        Obx(
                              () => CustomText(
                            text: historyController.liveStatusMessage.value.isNotEmpty
                                ? historyController.liveStatusMessage.value
                                : "Classifying visual asset data...",
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AllColor.whiteColor,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),

      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 12.h),
        child: Container(
          height: 64.r,
          width: 64.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AllColor.blueColor,
            border: Border.all(
              color: AllColor.whiteColor,
              width: 3.5.w,
            ),
            boxShadow: [
              BoxShadow(
                color: AllColor.blueColor.withValues(alpha: 0.45),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: FloatingActionButton(
            elevation: 0,
            highlightElevation: 0,
            backgroundColor: Colors.transparent,
            shape: const CircleBorder(),
            onPressed: () {
              CustomImagePickerSheet.show(
                onPick: (ImageSource source) {
                  historyController.pickAndInspectImages(source);
                },
              );
            },
            child: Icon(Icons.camera_alt_rounded, color: AllColor.whiteColor, size: 26.r),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: Obx(
            () => AnimatedBottomNavigationBar.builder(
          itemCount: 2,
          tabBuilder: (int index, bool isActive) {
            final Color color = isActive ? AllColor.yellowColor : AllColor.whiteColor.withValues(alpha: 0.85);
            final String label = index == 0 ? 'Home' : 'Settings';
            final IconData icon = index == 0 ? Icons.home_rounded : Icons.settings_rounded;

            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 23.r, color: color),
                const Gap(3),
                CustomText(
                  text: label,
                  color: color,
                  fontSize: 11,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                  softWrap: true,
                ),
              ],
            );
          },
          activeIndex: bottomNavController.selectedIndex.value,
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.softEdge,
          notchMargin: 8,
          leftCornerRadius: 24.r,
          rightCornerRadius: 24.r,
          backgroundColor: AllColor.blueColor,
          onTap: bottomNavController.changeIndex,
          shadow: BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 16,
            spreadRadius: 2,
            offset: const Offset(0, -4),
          ),
        ),
      ),
    );
  }
}