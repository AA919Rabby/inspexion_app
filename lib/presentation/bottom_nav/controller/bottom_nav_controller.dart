import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspexion_ai/presentation/home/ui/screen/home_screen.dart';
import 'package:inspexion_ai/presentation/settings/ui/screen/settings_screen.dart';

class BottomNavController extends GetxController {
  final RxInt selectedIndex = 0.obs;
  final RxBool isCameraLoading = false.obs;

  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  // brief tap feedback before showing picker sheet
  Future<void> onCameraTap({required VoidCallback onComplete}) async {
    if (isCameraLoading.value) return;
    isCameraLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 350));
    isCameraLoading.value = false;
    onComplete();
  }

  final List<Widget> pages = const [
    HomeScreen(),
    SettingsScreen(),
  ];
}