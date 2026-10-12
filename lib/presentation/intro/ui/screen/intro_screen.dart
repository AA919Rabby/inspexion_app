import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:get/get.dart';
import 'package:inspexion_ai/core/theme/all_color.dart';
import 'package:inspexion_ai/global/custom_loader.dart';
import 'package:inspexion_ai/global/custom_text.dart';
import 'package:inspexion_ai/presentation/intro/controller/intro_controller.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.isRegistered<IntroController>()
        ? Get.find<IntroController>()
        : Get.put(IntroController());

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
          child: Column(
            children: [
              const Spacer(flex: 3),

              // Glowing Ambient Logo Container
              Container(
                height: 110.r,
                width: 110.r,
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.05),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.15),
                    width: 1.5.w,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00B4D8).withValues(alpha: 0.2),
                      blurRadius: 28,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: Image.asset(
                  "asset/image/logo.png",
                  fit: BoxFit.contain,
                ),
              ),
              const Gap(18),

              // Title Branding
              CustomText(
                text: "InspeXion AI",
                color: AllColor.whiteColor,
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
              const Gap(8),

              // Commercial Tagline
              CustomText(
                text: "Intelligent Physical Asset Auditing",
                color: AllColor.whiteColor.withValues(alpha: 0.7),
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),

              const Spacer(flex: 3),

              // Custom Animated Loader
              const CustomLoader(),
              const Gap(24),

              // Enterprise Security Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lock_outline_rounded,
                    color: Colors.white.withValues(alpha: 0.4),
                    size: 13.r,
                  ),
                  const Gap(6),
                  CustomText(
                    text: "Enterprise SSL / TLS Secured",
                    color: Colors.white.withValues(alpha: 0.45),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
              const Gap(16),
            ],
          ),
        ),
      ),
    );
  }
}