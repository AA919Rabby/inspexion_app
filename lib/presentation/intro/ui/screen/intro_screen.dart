import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:get/get.dart';
import 'package:inspexion_ai/core/theme/all_color.dart';
import 'package:inspexion_ai/global/custom_loader.dart';
import 'package:inspexion_ai/global/custom_text.dart';
import 'package:inspexion_ai/presentation/intro/controller/intro_controller.dart';


class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<IntroController>();
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
            stops: [0.0, 0.6, 1.0], // Optional: Fine-tunes color positioning
          ),
        ),
        child: Column(
          children: [
            const Spacer(),
            Center(
              child: CustomText(text: "InspeXion AI",color: AllColor.whiteColor,fontSize: 40,softWrap: true,),
            ),
            const Spacer(),
            const CustomLoader(),
            const Gap(30),
          ],
        ),
      ),
    );
  }
}
