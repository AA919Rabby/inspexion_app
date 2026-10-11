import 'dart:async';
import 'package:get/get.dart';
import 'package:inspexion_ai/all_route.dart';
import 'package:inspexion_ai/core/services/auth_services.dart';

class IntroController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _handleAppRouting();
  }

  void _handleAppRouting() {
    Timer(const Duration(seconds: 3), () {
      final String? token = AuthServices.getAccessToken();

      // 1. If user already logged in with Google -> Go directly to BottomNavScreen
      if (token != null && token.isNotEmpty) {
        Get.offAllNamed(AllRoute.bottomNavScreen);
      }
      // 2. If new user or app reinstalled -> Go to OnboardingScreen to Sign In
      else {
        Get.offAllNamed(AllRoute.onboardingScreen);
      }
    });
  }
}