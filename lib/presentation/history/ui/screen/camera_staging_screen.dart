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
      backgroundColor: AllColor.greyColor300,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios_new, color: AllColor.whiteColor, size: 20.r),
        ),
        backgroundColor: AllColor.blueColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        toolbarHeight: 70.h,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24.r),
            bottomRight: Radius.circular(24.r),
          ),
        ),
        title: Obx(
              () => CustomText(
            text: 'Selected Photos (${controller.stagedImages.length})',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AllColor.whiteColor,
          ),
        ),
      ),
      body: Obx(
            () => Stack(
          children: [
            Column(
              children: [
                // Top Counter Info Bar
                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 4.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: "Ready for AI Diagnostic",
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: AllColor.blueColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: CustomText(
                          text: "${controller.stagedImages.length} In Queue",
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AllColor.blueColor,
                        ),
                      ),
                    ],
                  ),
                ),

                // Grid of Captured Image Thumbnails
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.all(16.r),
                    physics: const BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14.w,
                      mainAxisSpacing: 14.h,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: controller.stagedImages.length,
                    itemBuilder: (context, index) {
                      final image = controller.stagedImages[index];

                      return Container(
                        decoration: BoxDecoration(
                          color: AllColor.whiteColor,
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.r),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.file(
                                File(image.path),
                                fit: BoxFit.cover,
                              ),

                              // Image Number Badge
                              Positioned(
                                top: 10.h,
                                left: 10.w,
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.55),
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: CustomText(
                                    text: "#${index + 1}",
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: AllColor.whiteColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Bottom Commercial Dock Panel
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                  decoration: BoxDecoration(
                    color: AllColor.whiteColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24.r),
                      topRight: Radius.circular(24.r),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 16,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomButton(
                        text: 'Add More Photos',
                        backgroundColor: AllColor.whiteColor,
                        isOutlined: true,
                        textColor: AllColor.blackColor,
                        onPressed: controller.addMoreFromCamera,
                      ),
                      const Gap(12),
                      CustomButton(
                        text: 'Run AI Diagnostic (${controller.stagedImages.length})',
                        backgroundColor: AllColor.blueColor,
                        textColor: AllColor.whiteColor,
                        onPressed: controller.analyzeStagedImages,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Live WebSocket Progress Glassmorphism Overlay
            if (controller.isInspecting.value)
              Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black.withValues(alpha: 0.78),
                child: Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 28.w),
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 28.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(24.r),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.12),
                        width: 1.5.w,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                          decoration: BoxDecoration(
                            color: AllColor.blueColor.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(color: AllColor.blueColor.withValues(alpha: 0.4)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(width: 8.r, height: 8.r, decoration: BoxDecoration(color: AllColor.yellowColor, shape: BoxShape.circle)),
                              const Gap(6),
                              CustomText(text: "AI CLASSIFIER LIVE", fontSize: 11, fontWeight: FontWeight.bold, color: AllColor.whiteColor),
                            ],
                          ),
                        ),
                        const Gap(22),
                        const CircularProgressIndicator(),
                        const Gap(20),
                        Obx(
                              () => CustomText(
                            text: controller.liveStatusMessage.value.isNotEmpty
                                ? controller.liveStatusMessage.value
                                : "Analyzing photo stream with AI...",
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AllColor.whiteColor,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}