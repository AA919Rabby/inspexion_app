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
    final historyController = Get.find<HistoryController>();

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
                color: Colors.black.withValues(alpha: 0.6),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 14.h),
        child: FloatingActionButton(
          elevation: 5,
          backgroundColor: AllColor.blueColor,
          shape: const CircleBorder(),
          onPressed: () {
            CustomImagePickerSheet.show(
              onPick: (ImageSource source) {
                historyController.pickAndInspectImages(source);
              },
            );
          },
          child: Icon(Icons.camera_alt_rounded, color: AllColor.whiteColor, size: 28),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Obx(
            () => AnimatedBottomNavigationBar.builder(
          itemCount: 2,
          tabBuilder: (int index, bool isActive) {
            final Color color = isActive ? AllColor.yellowColor : AllColor.whiteColor;
            final String label = index == 0 ? 'Home' : 'Settings';
            final IconData icon = index == 0 ? Icons.home_rounded : Icons.settings_rounded;

            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 24, color: color),
                const Gap(3),
                CustomText(text: label, color: color, fontSize: 12, softWrap: true),
              ],
            );
          },
          activeIndex: bottomNavController.selectedIndex.value,
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.softEdge,
          notchMargin: 0,
          leftCornerRadius: 20,
          rightCornerRadius: 20,
          backgroundColor: AllColor.blueColor,
          onTap: bottomNavController.changeIndex,
          shadow: BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: 10, offset: const Offset(0, -2)),
        ),
      ),
    );
  }
}