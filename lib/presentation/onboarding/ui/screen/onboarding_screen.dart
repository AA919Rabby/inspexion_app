import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:get/get.dart';
import 'package:inspexion_ai/core/theme/all_color.dart';
import 'package:inspexion_ai/global/custom_button.dart';
import 'package:inspexion_ai/global/custom_text.dart';
import 'package:inspexion_ai/presentation/auth/controller/auth_controller.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../controller/onboarding_controller.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final onboardingController = Get.find<OnboardingController>();
    final authController = Get.find<AuthController>();

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AllColor.greyColor300,
        child: SafeArea(
          top: false,
          bottom: true,
          child: Stack(
            children: [
              Column(
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
                            // Top Image Container
                            Expanded(
                              flex: 7,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(28.r),
                                      bottomRight: Radius.circular(28.r),
                                    ),
                                    child: Image.asset(
                                      item['image']!,
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),

                                  // Skip Button: ONLY shown on 1st screen
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
                                            color: AllColor.whiteColor,
                                            fontSize: 16,
                                          ),
                                        ),
                                      )
                                          : const SizedBox.shrink(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Gap(15),

                            // Title & Description
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24.w),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomText(
                                      text: item['title']!,
                                      color: AllColor.yellowColor,
                                      fontSize: 26,
                                      fontWeight: FontWeight.w700,
                                      softWrap: true,
                                    ),
                                    const Gap(14),
                                    CustomText(
                                      text: item['description']!,
                                      color: AllColor.blackColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      textAlign: TextAlign.center,
                                      softWrap: true,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  // Expanding Dots Indicator
                  SmoothPageIndicator(
                    controller: onboardingController.pageController,
                    count: onboardingController.onboardingData.length,
                    effect: WormEffect(
                      dotHeight: 8.h,
                      dotWidth: 8.w,
                      spacing: 6.w,
                      activeDotColor: AllColor.yellowColor,
                      dotColor: AllColor.greyColor400,
                    ),
                  ),
                  const Gap(24),

                  // Bottom Action Buttons (Next / Google / Apple)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Obx(() {
                      final bool isLastPage = onboardingController.currentPage.value ==
                          onboardingController.onboardingData.length - 1;

                      // Pages 1 & 2: Show simple 'Next' Button
                      if (!isLastPage) {
                        return CustomButton(
                          text: 'Next',
                          onPressed: onboardingController.nextPage,
                          textColor: AllColor.whiteColor,
                          backgroundColor: AllColor.blueColor,
                        );
                      }

                      // Last Page: Sign-In Actions
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Google Login Button (Available on Android & iOS)
                          CustomButton(
                            text: Platform.isIOS ? 'Continue with Google' : 'Get Started',
                            onPressed: onboardingController.loginWithGoogle,
                            textColor: AllColor.whiteColor,
                            backgroundColor: AllColor.blueColor,
                          ),

                          // Apple Sign-In Button (ONLY on iOS devices)
                          if (Platform.isIOS) ...[
                            const Gap(7),
                            CustomButton(text: "Continue with Apple",
                                backgroundColor: AllColor.whiteColor,
                                /// outlined color is black
                                isOutlined: true,
                                textColor: AllColor.blackColor,
                                onPressed: onboardingController.loginWithApple),
                            // SignInWithAppleButton(
                            //   onPressed: onboardingController.loginWithApple,
                            //   height: 48.h,
                            //   borderRadius: BorderRadius.circular(10.r),
                            // ),
                          ],
                        ],
                      );
                    }),
                  ),
                  const Gap(20),
                ],
              ),

              // Full-screen loading overlay
              Obx(
                    () => authController.isLoading.value
                    ? Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black.withValues(alpha: 0.65),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}