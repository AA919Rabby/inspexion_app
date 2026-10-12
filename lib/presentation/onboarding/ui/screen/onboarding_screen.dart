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
      backgroundColor: AllColor.greyColor300,
      body: SafeArea(
        top: false,
        bottom: true,
        child: Stack(
          children: [
            Column(
              children: [
                // Carousel Page View
                Expanded(
                  child: PageView.builder(
                    controller: onboardingController.pageController,
                    onPageChanged: onboardingController.onPageChanged,
                    itemCount: onboardingController.onboardingData.length,
                    itemBuilder: (context, index) {
                      final item = onboardingController.onboardingData[index];
                      return Column(
                        children: [
                          // Top Image Container with Frosted Skip Pill
                          Expanded(
                            flex: 7,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(32.r),
                                      bottomRight: Radius.circular(32.r),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.1),
                                        blurRadius: 14,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(32.r),
                                      bottomRight: Radius.circular(32.r),
                                    ),
                                    child: Image.asset(
                                      item['image']!,
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),

                                // Frosted Glass Skip Pill (Only on 1st Screen)
                                Positioned(
                                  top: MediaQuery.of(context).padding.top + 12.h,
                                  right: 18.w,
                                  child: Obx(
                                        () => onboardingController.currentPage.value == 0
                                        ? GestureDetector(
                                      onTap: onboardingController.skip,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withValues(alpha: 0.42),
                                          borderRadius: BorderRadius.circular(20.r),
                                          border: Border.all(
                                            color: Colors.white.withValues(alpha: 0.25),
                                            width: 1.w,
                                          ),
                                        ),
                                        child: CustomText(
                                          text: 'Skip',
                                          color: AllColor.whiteColor,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    )
                                        : const SizedBox.shrink(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Gap(18),

                          // Typography (Title & Body)
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24.w),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomText(
                                    text: item['title']!,
                                    color: AllColor.blueColor,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    textAlign: TextAlign.center,
                                    softWrap: true,
                                  ),
                                  const Gap(12),
                                  CustomText(
                                    text: item['description']!,
                                    color: Colors.grey.shade700,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
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

                // Smooth Worm Indicator
                SmoothPageIndicator(
                  controller: onboardingController.pageController,
                  count: onboardingController.onboardingData.length,
                  effect: WormEffect(
                    dotHeight: 8.h,
                    dotWidth: 8.w,
                    spacing: 7.w,
                    activeDotColor: AllColor.blueColor,
                    dotColor: AllColor.greyColor400,
                  ),
                ),
                const Gap(26),

                // Bottom Action Buttons
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 22.w),
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

                    // Last Page: Sign-In Action Stack
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Primary Google Login Button
                        CustomButton(
                          text: Platform.isIOS ? 'Continue with Google' : 'Get Started',
                          onPressed: onboardingController.loginWithGoogle,
                          textColor: AllColor.whiteColor,
                          backgroundColor: AllColor.blueColor,
                        ),

                        // Official Apple Outlined Button (iOS ONLY)
                        if (Platform.isIOS) ...[
                          const Gap(10),
                          CustomButton(
                            text: "Continue with Apple",
                            backgroundColor: AllColor.whiteColor,
                            isOutlined: true,
                            textColor: AllColor.blackColor,
                            onPressed: onboardingController.loginWithApple,
                          ),
                        ],
                      ],
                    );
                  }),
                ),
                const Gap(22),
              ],
            ),

            // Loading Overlay with Plain CircularProgressIndicator
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
    );
  }
}