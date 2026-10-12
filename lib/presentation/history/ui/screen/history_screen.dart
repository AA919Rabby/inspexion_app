import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:get/get.dart';
import 'package:inspexion_ai/core/theme/all_color.dart';
import 'package:inspexion_ai/global/custom_button.dart';
import 'package:inspexion_ai/global/custom_shimmer.dart';
import 'package:inspexion_ai/global/custom_text.dart';
import 'package:inspexion_ai/presentation/history/controller/history_controller.dart';


class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<HistoryController>()
        ? Get.find<HistoryController>()
        : Get.put(HistoryController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchHistory();
    });

    return Scaffold(
      backgroundColor: AllColor.greyColor300,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios_new, color: AllColor.whiteColor, size: 20.r),
        ),
        backgroundColor: AllColor.blueColor,
        elevation: 3,
        scrolledUnderElevation: 0,
        centerTitle: true,
        toolbarHeight: 70.h,
        title: CustomText(
          text: 'Inspection History',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AllColor.whiteColor,
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
            child: Column(
              children: [
                CustomShimmer(height: 140.h),
                const Gap(14),
                CustomShimmer(height: 140.h),
                const Gap(14),
                CustomShimmer(height: 140.h),
              ],
            ),
          );
        }

        if (controller.reports.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(22.r),
                    decoration: BoxDecoration(
                      color: AllColor.whiteColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(Icons.inventory_2_outlined, size: 54.r, color: AllColor.greyColor400),
                  ),
                  const Gap(18),
                  CustomText(
                    text: 'No History Found',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AllColor.blackColor,
                  ),
                  const Gap(6),
                  CustomText(
                    text: 'Your generated inspection reports will automatically appear here.',
                    fontSize: 13,
                    color: Colors.grey.shade500,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return RefreshIndicator(
          color: AllColor.blueColor,
          backgroundColor: AllColor.whiteColor,
          onRefresh: () async {
            await controller.fetchHistory();
          },
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
            itemCount: controller.reports.length,
            separatorBuilder: (_, _) => const Gap(12),
            itemBuilder: (context, index) {
              final report = controller.reports[index];
              final String displayTitle = report.reportTitle.replaceAll('_', ' ');
              final String date = report.createdAt.isNotEmpty ? report.createdAt.split('T').first : 'Recent';
              final int scanSequence = controller.reports.length - index;

              return Container(
                decoration: BoxDecoration(
                  color: AllColor.whiteColor,
                  borderRadius: BorderRadius.circular(18.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(10.r),
                            decoration: BoxDecoration(
                              color: AllColor.redColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Icon(Icons.picture_as_pdf_rounded, color: AllColor.redColor, size: 24.r),
                          ),
                          const Gap(14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: displayTitle,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: AllColor.blackColor,
                                ),
                                const Gap(4),
                                Row(
                                  children: [
                                    Icon(Icons.calendar_today_rounded, size: 12.r, color: Colors.grey.shade500),
                                    const Gap(5),
                                    CustomText(
                                      text: date,
                                      fontSize: 12,
                                      color: Colors.grey.shade500,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: AllColor.blueColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: CustomText(
                              text: '#$scanSequence',
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AllColor.blueColor,
                            ),
                          ),
                        ],
                      ),
                      const Gap(14),
                      Divider(color: AllColor.greyColor300, height: 1),
                      const Gap(12),
                      CustomButton(
                        text: 'Download & View PDF',
                        backgroundColor: AllColor.blueColor,
                        textColor: AllColor.whiteColor,
                        onPressed: () => controller.downloadAndOpenReport(report.id, report.reportTitle),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}