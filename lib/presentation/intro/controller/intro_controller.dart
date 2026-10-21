import 'dart:async';
import 'package:get/get.dart';
import 'package:inspexion_ai/all_route.dart';
import 'package:inspexion_ai/core/services/auth_services.dart';

class IntroController extends GetxController {
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  void startTimer() {
    // cancel any previous timer to prevent duplicates
    _timer?.cancel();

    _timer = Timer(const Duration(seconds: 3), () {
      final String? token = AuthServices.getAccessToken();

      // if logged in -> go straight to Home. If logged out -> go to Onboarding
      if (token != null && token.isNotEmpty) {
        Get.offAllNamed(AllRoute.bottomNavScreen);
      } else {
        Get.offAllNamed(AllRoute.onboardingScreen);
      }
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}