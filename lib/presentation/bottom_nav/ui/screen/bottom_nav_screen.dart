import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:get/get.dart';
import 'package:inspexion_ai/core/theme/all_color.dart';
import 'package:inspexion_ai/global/custom_text.dart';
import 'package:inspexion_ai/presentation/bottom_nav/controller/bottom_nav_controller.dart';

class BottomNavScreen extends StatelessWidget {
  const BottomNavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomNavController = Get.find<BottomNavController>();

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: Obx(
              () => IndexedStack(
            index: bottomNavController.selectedIndex.value,
            children: bottomNavController.pages,
          ),
        ),
      ),

      // Center Floating Action Button (Raised with bottom padding)
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 14.h), // Lifts the button up from the bottom edge
        child: FloatingActionButton(
          elevation: 5,
          backgroundColor: AllColor.blueColor,
          shape: const CircleBorder(),
          onPressed: bottomNavController.onCameraTap,
          child: Icon(
            Icons.camera_alt_rounded,
            color: AllColor.whiteColor,
            size: 28,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // Animated Bottom Navigation Bar
      bottomNavigationBar: Obx(
            () => AnimatedBottomNavigationBar.builder(
          itemCount: 2,
          tabBuilder: (int index, bool isActive) {
            final Color color =
            isActive ? AllColor.yellowColor : AllColor.whiteColor;
            final String label = index == 0 ? 'Home' : 'Settings';
            final IconData icon =
            index == 0 ? Icons.home_rounded : Icons.settings_rounded;

            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 24,
                  color: color,
                ),
                const Gap(3),
                CustomText(
                  text: label,
                  color: color,
                  fontSize: 12,
                  softWrap: true,
                ),
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
          shadow: BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, -2),
          ),
        ),
      ),
    );
  }
}