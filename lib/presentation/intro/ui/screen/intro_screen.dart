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
    if (!Get.isRegistered<IntroController>()) {
      Get.put(IntroController());
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0A192F),
              Color(0xFF000439),
              Color(0xFF000000),
            ],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 3),

              // static glowing logo badge
              Container(
                height: 110.r,
                width: 110.r,
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0x10FFFFFF),
                  border: Border.all(
                    color: const Color(0x33FFFFFF),
                    width: 1.5.w,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x4700B4D8),
                      blurRadius: 32,
                      spreadRadius: 6,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Image.asset(
                  "asset/image/logo.png",
                  fit: BoxFit.contain,
                ),
              ),
              const Gap(18),

              CustomText(
                text: "InspeXion AI",
                color: AllColor.whiteColor,
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
              const Gap(8),

              CustomText(
                text: "Intelligent Physical Asset Auditing",
                color: const Color(0xB3FFFFFF),
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),

              const Spacer(flex: 3),

              const CustomLoader(),
              const Gap(24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lock_outline_rounded,
                    color: const Color(0x66FFFFFF),
                    size: 13.r,
                  ),
                  const Gap(6),
                  CustomText(
                    text: "Enterprise SSL / TLS Secured",
                    color: const Color(0x73FFFFFF),
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