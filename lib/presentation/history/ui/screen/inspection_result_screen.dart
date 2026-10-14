import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:get/get.dart';
import 'package:inspexion_ai/all_route.dart';
import 'package:inspexion_ai/core/theme/all_color.dart';
import 'package:inspexion_ai/global/custom_button.dart';
import 'package:inspexion_ai/global/custom_text.dart';
import 'package:inspexion_ai/presentation/history/controller/history_controller.dart';
import 'package:inspexion_ai/presentation/history/data/inspection_result_model.dart';

class InspectionResultScreen extends StatelessWidget {
  const InspectionResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HistoryController>();

    return Scaffold(
      backgroundColor: AllColor.greyColor300,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AllColor.blueColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        toolbarHeight: 65.h,
        title: Obx(
              () {
            final int displayNum = controller.currentInspection.value?.sessionNumber ?? 1;
            return CustomText(
              text: 'Results (#$displayNum)',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AllColor.whiteColor,
            );
          },
        ),
      ),
      body: Obx(() {
        final data = controller.currentInspection.value;

        return Stack(
          children: [
            if (data == null)
              Center(
                child: CustomText(
                  text: 'No inspection records available.',
                  fontSize: 16,
                  color: AllColor.greyColor400,
                ),
              )
            else
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status Alert Banner
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(18.r),
                      decoration: BoxDecoration(
                        color: AllColor.whiteColor,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: data.hasCriticalIssue ? AllColor.redColor : Colors.green.shade600,
                          width: 2.w,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(12.r),
                            decoration: BoxDecoration(
                              color: (data.hasCriticalIssue ? AllColor.redColor : Colors.green).withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              data.hasCriticalIssue ? Icons.warning_amber_rounded : Icons.verified_outlined,
                              color: data.hasCriticalIssue ? AllColor.redColor : Colors.green.shade700,
                              size: 32.r,
                            ),
                          ),
                          const Gap(14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: data.hasCriticalIssue ? 'CRITICAL HAZARD DETECTED' : 'ASSET AUDIT PASSED',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: data.hasCriticalIssue ? AllColor.redColor : Colors.green.shade800,
                                ),
                                const Gap(4),
                                CustomText(
                                  text: data.hasCriticalIssue
                                      ? 'Damage isolated with red tracking boxes. Inspection required.'
                                      : 'All components intact. Structural integrity verified.',
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(16),

                    // Metrics Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildMetricBox(
                            label: 'Total Images',
                            value: '${data.processedCount}',
                            color: AllColor.blueColor,
                            icon: Icons.photo_library_outlined,
                          ),
                        ),
                        const Gap(8),
                        Expanded(
                          child: _buildMetricBox(
                            label: 'Critical',
                            value: '${data.criticalDefects}',
                            color: AllColor.redColor,
                            icon: Icons.error_outline_rounded,
                          ),
                        ),
                        const Gap(8),
                        Expanded(
                          child: _buildMetricBox(
                            label: 'Safe / Intact',
                            value: '${data.minorDefects}',
                            color: Colors.green.shade600,
                            icon: Icons.check_circle_outline_rounded,
                          ),
                        ),
                      ],
                    ),
                    const Gap(24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: 'Side-by-Side Image Breakdown',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AllColor.blackColor,
                        ),
                        CustomText(
                          text: '${data.results.length} Scans',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                        ),
                      ],
                    ),
                    const Gap(12),

                    // Itemized Scans with Red Damage Bounding Boxes
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: data.results.length,
                      separatorBuilder: (_, _) => const Gap(12),
                      itemBuilder: (context, index) {
                        final item = data.results[index];
                        final double confPercent = item.confidence * 100;
                        final String displayCategory = item.category.replaceAll('_', ' ').toUpperCase();
                        final bool hasLocalThumb = index < controller.stagedImages.length;
                        final File? localFile = hasLocalThumb ? File(controller.stagedImages[index].path) : null;

                        return Container(
                          padding: EdgeInsets.all(12.r),
                          decoration: BoxDecoration(
                            color: AllColor.whiteColor,
                            borderRadius: BorderRadius.circular(16.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Left: Photo with AllColor.redColor Bounding Boxes
                              GestureDetector(
                                onTap: () {
                                  if (localFile != null) {
                                    _showFullScreenDamageViewer(context, localFile, item.boxes, displayCategory);
                                  }
                                },
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12.r),
                                      child: SizedBox(
                                        width: 100.w,
                                        height: 100.h,
                                        child: CustomPaint(
                                          foregroundPainter: item.isCritical
                                              ? DamageBoxPainter(boxes: item.boxes)
                                              : null,
                                          child: localFile != null
                                              ? Image.file(
                                            localFile,
                                            fit: BoxFit.cover,
                                          )
                                              : Container(
                                            color: Colors.grey.shade200,
                                            child: Icon(Icons.image, color: Colors.grey.shade400),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 4.h,
                                      left: 4.w,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withValues(alpha: 0.65),
                                          borderRadius: BorderRadius.circular(6.r),
                                        ),
                                        child: CustomText(
                                          text: "#${index + 1}",
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: AllColor.whiteColor,
                                        ),
                                      ),
                                    ),
                                    if (item.isCritical)
                                      Positioned(
                                        bottom: 4.h,
                                        right: 4.w,
                                        child: Container(
                                          padding: EdgeInsets.all(3.r),
                                          decoration: BoxDecoration(
                                            color: AllColor.redColor,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(Icons.fullscreen, color: AllColor.whiteColor, size: 14.r),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              const Gap(14),

                              // Right: Defect Description & Status
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: CustomText(
                                            text: displayCategory,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: AllColor.blackColor,
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                                          decoration: BoxDecoration(
                                            color: (item.isCritical ? AllColor.redColor : Colors.green).withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(8.r),
                                          ),
                                          child: CustomText(
                                            text: item.isCritical ? "CRITICAL" : "SAFE",
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: item.isCritical ? AllColor.redColor : Colors.green.shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Gap(4),
                                    CustomText(
                                      text: "Confidence: ${confPercent.toStringAsFixed(0)}%",
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: AllColor.blueColor,
                                    ),
                                    const Gap(4),
                                    CustomText(
                                      text: item.description,
                                      fontSize: 11,
                                      color: Colors.grey.shade600,
                                      maxLines: 3,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const Gap(28),

                    CustomButton(
                      text: 'Generate Official PDF Report',
                      backgroundColor: AllColor.blueColor,
                      textColor: AllColor.whiteColor,
                      onPressed: controller.generateAndOpenCurrentReport,
                    ),
                    const Gap(14),
                    CustomButton(
                      text: 'Back to Home',
                      backgroundColor: AllColor.whiteColor,
                      textColor: AllColor.blackColor,
                      isOutlined: true,
                      onPressed: () {
                        Get.offAllNamed(AllRoute.bottomNavScreen);
                      },
                    ),
                    const Gap(20),
                  ],
                ),
              ),

            if (controller.isGeneratingPdf.value)
              Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black.withValues(alpha: 0.7),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        );
      }),
    );
  }

  // Tap-to-Expand Full-Screen Viewer with AllColor.redColor Damage Boxes
  void _showFullScreenDamageViewer(
      BuildContext context,
      File imageFile,
      List<DamageBox> boxes,
      String title,
      ) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(16.r),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: title,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AllColor.whiteColor,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: CustomPaint(
                    foregroundPainter: DamageBoxPainter(boxes: boxes),
                    child: Image.file(imageFile, fit: BoxFit.cover),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(14.r),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 12.r,
                      height: 12.r,
                      decoration: BoxDecoration(color: AllColor.redColor, shape: BoxShape.circle),
                    ),
                    const Gap(8),
                    CustomText(
                      text: "Outlined areas indicate detected damage points",
                      fontSize: 11,
                      color: Colors.white70,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricBox({
    required String label,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 10.w),
      decoration: BoxDecoration(
        color: AllColor.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20.r),
          const Gap(6),
          CustomText(
            text: value,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color == AllColor.yellowColor ? Colors.amber.shade900 : color,
          ),
          const Gap(2),
          CustomText(
            text: label,
            fontSize: 11,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}

class DamageBoxPainter extends CustomPainter {
  final List<DamageBox> boxes;

  DamageBoxPainter({required this.boxes});

  @override
  void paint(Canvas canvas, Size size) {
    if (boxes.isEmpty) {
      final defaultRect = Rect.fromLTWH(
        size.width * 0.18,
        size.height * 0.18,
        size.width * 0.64,
        size.height * 0.64,
      );
      _drawBox(canvas, size, defaultRect, "CRITICAL DEFECT");
      return;
    }

    for (var b in boxes) {
      final rect = Rect.fromLTRB(
        b.xmin * size.width,
        b.ymin * size.height,
        b.xmax * size.width,
        b.ymax * size.height,
      );
      _drawBox(canvas, size, rect, b.label);
    }
  }

  void _drawBox(Canvas canvas, Size size, Rect rect, String label) {
    final borderPaint = Paint()
      ..color = AllColor.redColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final fillPaint = Paint()
      ..color = AllColor.redColor.withValues(alpha: 0.18)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(6)), fillPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(6)), borderPaint);

    final textPainter = TextPainter(
      text: TextSpan(
        text: "  $label  ",
        style: TextStyle(
          color: Colors.white,
          fontSize: 9.sp,
          fontWeight: FontWeight.bold,
          backgroundColor: AllColor.redColor,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(rect.left, (rect.top - 14).clamp(0.0, size.height)),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}