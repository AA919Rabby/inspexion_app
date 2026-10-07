import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:get/get.dart';
import 'package:inspexion_ai/core/theme/all_color.dart';
import 'package:inspexion_ai/global/custom_button.dart';
import 'package:inspexion_ai/global/custom_text.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../controller/onboarding_controller.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final onboardingController = Get.find<OnboardingController>();

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0A192F), // Deep Midnight Blue
              Color(0xFF000439), // Rich Navy
              Color(0xFF000000), // Pure Black
            ],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          top: false,
          bottom: true,
          child: Column(
            children: [
              // Page View
              Expanded(
                child: PageView.builder(
                  controller: onboardingController.pageController,
                  onPageChanged: onboardingController.onPageChanged,
                  itemCount: onboardingController.onboardingData.length,
                  itemBuilder: (context, index) {
                    final item = onboardingController.onboardingData[index];
                    return Column(
                      children: [
                        // Image Stack
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(28.r),
                                bottomRight: Radius.circular(28.r),
                              ),
                              child: Image.asset(
                                item['image']!,
                                width: double.infinity,
                                height: 0.48.sh,
                                fit: BoxFit.cover,
                              ),
                            ),

                            // Skip Button: ONLY shown on the 1st screen
                            Positioned(
                              top: MediaQuery.of(context).padding.top + 10.h,
                              right: 20.w,
                              child: Obx(
                                    () => onboardingController.currentPage.value == 0
                                    ? GestureDetector(
                                  onTap: onboardingController.skip,
                                  behavior: HitTestBehavior.opaque,
                                  child: Padding(
                                    padding: EdgeInsets.all(8.r),
                                    child: CustomText(
                                      text: 'Skip',
                                      color: AllColor.whiteColor
                                          .withValues(alpha: 0.85),
                                      fontSize: 16,
                                    ),
                                  ),
                                )
                                    : const SizedBox.shrink(),
                              ),
                            ),
                          ],
                        ),
                        const Gap(24),

                        // Title & Description
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: Column(
                            children: [
                              CustomText(
                                text: item['title']!,
                                color: AllColor.yellowColor,
                                fontSize: 26,
                                softWrap: true,
                              ),
                              const Gap(14),
                              CustomText(
                                text: item['description']!,
                                color: AllColor.whiteColor,
                                fontSize: 15,
                                softWrap: true,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              // Simple Expanding Dots Indicator
              SmoothPageIndicator(
                controller: onboardingController.pageController,
                count: onboardingController.onboardingData.length,
                effect: WormEffect(
                  dotHeight: 8.h,
                  dotWidth: 8.w, // Circle when resting (8x8)
                 // expansionFactor: 3, // Expands its width dynamically when swiping
                  spacing: 6.w,
                  activeDotColor: AllColor.yellowColor,
                  dotColor: AllColor.whiteColor.withValues(alpha: 0.35),
                ),
              ),
              const Gap(32),

              // Custom Button (Next / Get Started)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Obx(
                      () => CustomButton(
                    text: onboardingController.currentPage.value ==
                        onboardingController.onboardingData.length - 1
                        ? 'Get Started'
                        : 'Next',
                    onPressed: onboardingController.nextPage,
                    textColor: AllColor.whiteColor,
                    backgroundColor: AllColor.blueColor,
                  ),
                ),
              ),
              const Gap(24),
            ],
          ),
        ),
      ),
    );
  }
}