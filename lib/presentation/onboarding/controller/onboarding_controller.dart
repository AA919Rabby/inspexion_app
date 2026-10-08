import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspexion_ai/all_route.dart';
import 'package:inspexion_ai/presentation/auth/controller/auth_controller.dart';

class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;

  final List<Map<String, String>> onboardingData = const [
    {
      'image': 'asset/image/onboarding1.png',
      'title': 'Snap & Inspect',
      'description':
      'Capture any item or vehicle defect with a single photo. Our AI inspects every detail immediately.',
    },
    {
      'image': 'asset/image/onboarding2.png',
      'title': 'Smart AI Diagnostics',
      'description':
      'Send photos directly to the AI engine to detect issues and discover exact problem areas.',
    },
    {
      'image': 'asset/image/onboarding3.png',
      'title': 'Instant AI & PDF Reports',
      'description':
      'Receive detailed AI analysis, recommended solutions, and download professional PDF inspection reports instantly.',
    },
  ];

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void nextPage() {
    if (currentPage.value < onboardingData.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      goToHomeScreen();
    }
  }

  void skip() {
    Get.offAllNamed(AllRoute.bottomNavScreen);
    //goToHomeScreen();
  }

  void goToHomeScreen() {
    final AuthController authController = Get.find<AuthController>();
    authController.googleLogin(); // Clean call without context argument
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}