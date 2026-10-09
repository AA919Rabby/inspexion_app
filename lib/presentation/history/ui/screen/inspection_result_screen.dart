import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:get/get.dart';
import 'package:inspexion_ai/core/theme/all_color.dart';
import 'package:inspexion_ai/global/custom_button.dart';
import 'package:inspexion_ai/global/custom_text.dart';
import 'package:inspexion_ai/presentation/history/controller/history_controller.dart';



class InspectionResultScreen extends StatelessWidget {
  const InspectionResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HistoryController>();

    return Scaffold(
      backgroundColor:AllColor.greyColor400,
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Get.back();
        }, icon: Icon(Icons.arrow_back_ios_new,color: AllColor.whiteColor,)),
        scrolledUnderElevation: 0,
        backgroundColor: AllColor.blueColor,
        elevation: 0,
      //  centerTitle: true,
        title: Obx(
              () => CustomText(
            text: 'Results (#${controller.currentInspection.value?.sessionId ?? 0})',
            fontSize: 25,
            color: AllColor.whiteColor,
          ),
        ),
      ),
      body: Obx(() {
        final data = controller.currentInspection.value;

        return Stack(
          children: [
            if (data == null)
              Center(
                child: CustomText(
                  text: 'No data found.',
                  fontSize: 16.sp,
                  color: AllColor.greyColor400,
                ),
              )
            else
              SingleChildScrollView(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        color: data.hasCriticalIssue
                            ? AllColor.redColor.withValues(alpha: 0.1)
                            : Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(
                          color: data.hasCriticalIssue ? AllColor.redColor : Colors.green,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            data.hasCriticalIssue ? Icons.warning_amber_rounded : Icons.check_circle_outline_rounded,
                            color: data.hasCriticalIssue ? AllColor.redColor : Colors.green,
                            size: 36.r,
                          ),
                          const Gap(14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: data.hasCriticalIssue ? 'CRITICAL DEFECT DETECTED' : 'INSPECTION PASSED',
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold,
                                  color: data.hasCriticalIssue ? AllColor.redColor : Colors.green,
                                ),
                                const Gap(4),
                                CustomText(
                                  text: data.hasCriticalIssue ? 'Repair recommended.' : 'Assets intact.',
                                  fontSize: 12.sp,
                                  color: AllColor.greyColor400,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(16),
                    Row(
                      children: [
                        Expanded(child: _metricBox(label: 'Images', value: '${data.processedCount}', color: AllColor.blueColor)),
                        const Gap(8),
                        Expanded(child: _metricBox(label: 'Critical', value: '${data.criticalDefects}', color: AllColor.redColor)),
                        const Gap(8),
                        Expanded(child: _metricBox(label: 'Minor', value: '${data.minorDefects}', color: AllColor.yellowColor)),
                      ],
                    ),
                    const Gap(24),
                    CustomText(
                      text: 'Defect List',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AllColor.blackColor,
                    ),
                    const Gap(12),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: data.results.length,
                      separatorBuilder: (_, _) => const Gap(10),
                      itemBuilder: (context, index) {
                        final item = data.results[index];
                        return Container(
                          padding: EdgeInsets.all(12.r),
                          decoration: BoxDecoration(color: AllColor.greyColor300, borderRadius: BorderRadius.circular(10.r)),
                          child: Row(
                            children: [
                              Icon(
                                item.isCritical ? Icons.error_rounded : Icons.check_circle_rounded,
                                color: item.isCritical ? AllColor.redColor : AllColor.blueColor,
                                size: 24.r,
                              ),
                              const Gap(12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: item.category.toUpperCase(),
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AllColor.blackColor,
                                    ),
                                    CustomText(text: item.filename, fontSize: 11.sp, color: AllColor.greyColor400),
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
                    const Gap(16),
                  ],
                ),
              ),

            // Plain CircularProgressIndicator
            if (controller.isGeneratingPdf.value)
              Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black.withValues(alpha: 0.6),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        );
      }),
    );
  }

  Widget _metricBox({required String label, required String value, required Color color}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10.r)),
      child: Column(
        children: [
          CustomText(text: value, fontSize: 20.sp, fontWeight: FontWeight.bold, color: color),
          CustomText(text: label, fontSize: 12.sp, color: AllColor.blackColor),
        ],
      ),
    );
  }
}