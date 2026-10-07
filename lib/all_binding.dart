import 'package:get/get.dart';
import 'package:inspexion_ai/presentation/intro/controller/intro_controller.dart';
import 'package:inspexion_ai/presentation/onboarding/controller/onboarding_controller.dart';


class AllBinding extends Bindings {
  @override
  void dependencies() {

    Get.lazyPut(() => IntroController(), fenix: true);
    Get.lazyPut(() => OnboardingController(), fenix: true);



  }
}