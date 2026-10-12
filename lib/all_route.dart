import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:inspexion_ai/presentation/bottom_nav/ui/screen/bottom_nav_screen.dart';
import 'package:inspexion_ai/presentation/history/ui/screen/camera_staging_screen.dart';
import 'package:inspexion_ai/presentation/history/ui/screen/history_screen.dart';
import 'package:inspexion_ai/presentation/history/ui/screen/inspection_result_screen.dart';
import 'package:inspexion_ai/presentation/intro/ui/screen/intro_screen.dart';
import 'package:inspexion_ai/presentation/onboarding/ui/screen/onboarding_screen.dart';
import 'package:inspexion_ai/presentation/profile/ui/screen/profile_screen.dart';
import 'package:inspexion_ai/presentation/settings/ui/widget/about_us.dart';
import 'package:inspexion_ai/presentation/settings/ui/widget/support.dart';
import 'all_binding.dart';


class AllRoute {
  static const String intro = '/intro';
  static const String onboardingScreen = '/onboardingScreen';
  static const String bottomNavScreen = '/bottomNavScreen';
  static const String historyScreen = '/historyScreen';
  static const String inspectionResultScreen = '/inspectionResultScreen';
  static const String cameraStagingScreen = '/cameraStagingScreen';
  static const String aboutUs = '/aboutUs';
  static const String support = '/support';
  static const String profile = '/profile';

  /// Smooth transition timing
  static const Duration _transitionDuration = Duration(milliseconds: 100);
  static const Curve _transitionCurve = Curves.easeInOutCubic;

  static final List<GetPage> routes = [

    GetPage(
      name: intro,
      page: () => const IntroScreen(),
      binding: AllBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
      curve: Curves.easeIn,
    ),

    GetPage(
      name: onboardingScreen,
      page: () => const OnboardingScreen(),
      binding: AllBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    ),

    GetPage(
      name: bottomNavScreen,
      page: () => const BottomNavScreen(),
      binding: AllBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    ),

    GetPage(
      name: historyScreen,
      page: () => const HistoryScreen(),
      binding: AllBinding(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: _transitionDuration,
      curve: _transitionCurve,
      popGesture: true,
    ),

    GetPage(
      name: inspectionResultScreen,
      page: () => const InspectionResultScreen(),
      binding: AllBinding(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: _transitionDuration,
      curve: _transitionCurve,
      popGesture: true,
    ),

    GetPage(
      name: cameraStagingScreen,
      page: () => const CameraStagingScreen(),
      binding: AllBinding(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: _transitionDuration,
      curve: _transitionCurve,
      popGesture: true,
    ),

    GetPage(
      name: aboutUs,
      page: () => const AboutUs(),
      binding: AllBinding(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: _transitionDuration,
      curve: _transitionCurve,
      popGesture: true,
    ),

    GetPage(
      name: support,
      page: () => const Support(),
      binding: AllBinding(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: _transitionDuration,
      curve: _transitionCurve,
      popGesture: true,
    ),

    GetPage(
      name: profile,
      page: () => const ProfileScreen(),
      binding: AllBinding(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: _transitionDuration,
      curve: _transitionCurve,
      popGesture: true,
    ),
  ];
}