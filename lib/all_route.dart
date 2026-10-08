import 'package:get/get.dart';
import 'package:inspexion_ai/presentation/bottom_nav/ui/screen/bottom_nav_screen.dart';
import 'package:inspexion_ai/presentation/intro/ui/screen/intro_screen.dart';
import 'package:inspexion_ai/presentation/onboarding/ui/screen/onboarding_screen.dart';
import 'all_binding.dart';


class AllRoute {
  static const String intro = '/intro';
  static const String onboardingScreen = '/onboardingScreen';
  static const String bottomNavScreen = '/bottomNavScreen';


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

  ];
}