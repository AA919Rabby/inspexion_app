import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspexion_ai/presentation/home/ui/screen/home_screen.dart';
import 'package:inspexion_ai/presentation/settings/ui/screen/settings_screen.dart';


class BottomNavController extends GetxController {
  final RxInt selectedIndex = 0.obs;

  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  void onCameraTap() {

  }

  // The 2 screens: Home and Settings using your CustomText
  final List<Widget> pages = [
    HomeScreen(),
    SettingsScreen(),
  ];
}