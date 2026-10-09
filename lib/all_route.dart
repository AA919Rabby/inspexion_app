import 'package:get/get.dart';
import 'package:inspexion_ai/presentation/bottom_nav/ui/screen/bottom_nav_screen.dart';
import 'package:inspexion_ai/presentation/history/ui/screen/camera_staging_screen.dart';
import 'package:inspexion_ai/presentation/history/ui/screen/history_screen.dart';
import 'package:inspexion_ai/presentation/history/ui/screen/inspection_result_screen.dart';
import 'package:inspexion_ai/presentation/intro/ui/screen/intro_screen.dart';
import 'package:inspexion_ai/presentation/onboarding/ui/screen/onboarding_screen.dart';
import 'all_binding.dart';


class AllRoute {
  static const String intro = '/intro';
  static const String onboardingScreen = '/onboardingScreen';
  static const String bottomNavScreen = '/bottomNavScreen';
  static const String historyScreen = '/historyScreen';
  static const String inspectionResultScreen = '/inspectionResultScreen';
  static const String cameraStagingScreen = '/cameraStagingScreen';

  static final List<GetPage> routes = [
    GetPage(
      name: intro,
      page: () => IntroScreen(),
      binding: AllBinding(),
    ),
    GetPage(
      name: onboardingScreen,
      page: () => OnboardingScreen(),
      binding: AllBinding(),
    ),
    GetPage(
      name: bottomNavScreen,
      page: () => BottomNavScreen(),
      binding: AllBinding(),
    ),
    GetPage(
      name: historyScreen,
      page: () => HistoryScreen(),
      binding: AllBinding(),
    ),
    GetPage(
      name: inspectionResultScreen,
      page: () => InspectionResultScreen(),
      binding: AllBinding(),
    ),
    GetPage(
      name: cameraStagingScreen,
      page: () => CameraStagingScreen(),
      binding: AllBinding(),
    ),

  ];
}