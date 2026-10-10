import 'package:get/get.dart';
import 'package:inspexion_ai/presentation/auth/controller/auth_controller.dart';
import 'package:inspexion_ai/presentation/bottom_nav/controller/bottom_nav_controller.dart';
import 'package:inspexion_ai/presentation/history/controller/history_controller.dart';
import 'package:inspexion_ai/presentation/home/controller/home_controller.dart';
import 'package:inspexion_ai/presentation/intro/controller/intro_controller.dart';
import 'package:inspexion_ai/presentation/onboarding/controller/onboarding_controller.dart';
import 'package:inspexion_ai/presentation/profile/controller/profile_controller.dart';


class AllBinding extends Bindings {
  @override
  void dependencies() {

    Get.lazyPut(() => IntroController(), fenix: true);
    Get.lazyPut(() => OnboardingController(), fenix: true);
    Get.lazyPut(() => BottomNavController(), fenix: true);
    Get.lazyPut(() => AuthController(), fenix: true);
    Get.lazyPut(() => HomeController(), fenix: true);
    Get.lazyPut(() => HistoryController(), fenix: true);
    Get.lazyPut(() => ProfileController(), fenix: true);


  }
}