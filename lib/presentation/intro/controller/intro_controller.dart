import 'dart:async';
import 'package:get/get.dart';
import 'package:inspexion_ai/all_route.dart';


class IntroController extends GetxController {
  @override
  void onInit() {
    super.onInit();

    Timer(const Duration(seconds: 3), () {
      Get.offAllNamed(AllRoute.onboardingScreen);
    });
  }
}