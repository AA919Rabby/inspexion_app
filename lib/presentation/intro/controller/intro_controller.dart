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

      if (token != null && token.isNotEmpty) {
        Get.offAllNamed(AllRoute.bottomNavScreen);
      }
      else {
        Get.offAllNamed(AllRoute.onboardingScreen);
      }
    });
  }
}