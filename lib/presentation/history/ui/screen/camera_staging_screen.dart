import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:get/get.dart';
import 'package:inspexion_ai/core/theme/all_color.dart';
import 'package:inspexion_ai/global/custom_button.dart';
import 'package:inspexion_ai/global/custom_text.dart';
import 'package:inspexion_ai/presentation/history/controller/history_controller.dart';



class CameraStagingScreen extends StatelessWidget {
  const CameraStagingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HistoryController>();

    return Scaffold(
      backgroundColor: AllColor.whiteColor,
      appBar: AppBar(
        backgroundColor: AllColor.blueColor,
        elevation: 0,
        centerTitle: true,
        title: CustomText(
          text: 'Selected Photos',
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: AllColor.whiteColor,
        ),
      ),
      body: Obx(
            () => Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.all(16.r),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12.w,
                      mainAxisSpacing: 12.h,
                    ),
                    itemCount: controller.stagedImages.length,
                    itemBuilder: (context, index) {
                      final image = controller.stagedImages[index];
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: Image.file(
                          File(image.path),
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(24.r),
                  decoration: BoxDecoration(
                    color: AllColor.whiteColor,
                    boxShadow: [
                      BoxShadow(
                        color: AllColor.blackColor.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomButton(
                        text: 'Add More Photo',
                        backgroundColor: AllColor.whiteColor,
                        textColor: AllColor.blueColor,
                        onPressed: controller.addMoreFromCamera,
                      ),
                      const Gap(12),
                      CustomButton(
                        text: 'Analyze (${controller.stagedImages.length})',
                        backgroundColor: AllColor.blueColor,
                        textColor: AllColor.whiteColor,
                        onPressed: controller.analyzeStagedImages,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Plain CircularProgressIndicator overlay
            if (controller.isInspecting.value)
              Container(
                width: double.infinity,
                height: double.infinity,
                color: AllColor.blackColor.withValues(alpha: 0.6),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}