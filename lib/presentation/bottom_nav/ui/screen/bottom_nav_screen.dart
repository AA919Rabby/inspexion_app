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
            // live socket progress modal
            if (historyController.isInspecting.value)
              Container(
                width: double.infinity,
                height: double.infinity,
                color: const Color(0xC7000000),
                child: Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 28.w),
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 28.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(24.r),
                      border: Border.all(
                        color: const Color(0x1FFFFFFF),
                        width: 1.5.w,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x66000000),
                          blurRadius: 20,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                          decoration: BoxDecoration(
                            color: const Color(0x336200EE),
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: const Color(0x666200EE),
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
        child: Obx(
              () => Container(
            height: 64.r,
            width: 64.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: bottomNavController.isCameraLoading.value
                  ? AllColor.blackColor
                  : AllColor.blueColor,
              border: Border.all(
                color: AllColor.whiteColor,
                width: 3.5.w,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x736200EE),
                  blurRadius: 16,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: FloatingActionButton(
              elevation: 0,
              highlightElevation: 0,
              backgroundColor: Colors.transparent,
              shape: const CircleBorder(),
              onPressed: () {
                bottomNavController.onCameraTap(
                  onComplete: () {
                    CustomImagePickerSheet.show(
                      onPick: (ImageSource source) {
                        historyController.pickAndInspectImages(source);
                      },
                    );
                  },
                );
              },
              child: bottomNavController.isCameraLoading.value
                  ? const CircularProgressIndicator()
                  : Icon(
                Icons.camera_alt_rounded,
                color: AllColor.whiteColor,
                size: 26.r,
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Obx(
            () => AnimatedBottomNavigationBar.builder(
          itemCount: 2,
          tabBuilder: (int index, bool isActive) {
            final Color color = isActive ? AllColor.yellowColor : const Color(0xD9FFFFFF);
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
          shadow: const BoxShadow(
            color: Color(0x40000000),
            blurRadius: 16,
            spreadRadius: 2,
            offset: Offset(0, -4),
          ),
        ),
      ),
    );
  }
}