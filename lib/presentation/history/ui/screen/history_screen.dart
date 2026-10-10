import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:get/get.dart';
import 'package:inspexion_ai/core/theme/all_color.dart';
import 'package:inspexion_ai/global/custom_button.dart';
import 'package:inspexion_ai/global/custom_text.dart';
import 'package:inspexion_ai/presentation/history/controller/history_controller.dart';



class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HistoryController());

    return Scaffold(
      backgroundColor:AllColor.greyColor300,
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Get.back();
        }, icon: Icon(Icons.arrow_back_ios_new,color: AllColor.whiteColor,)),
        scrolledUnderElevation: 0,
        backgroundColor: AllColor.blueColor,
        elevation: 0,
       // centerTitle: true,
        title: CustomText(
          text: 'History',
          fontSize: 22,
          color: AllColor.whiteColor,
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.reports.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory_2_outlined, size: 80.r),
                  const Gap(8),
                  CustomText(
                    text: 'Your inspection history is empty.',
                    fontSize: 15, textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return RefreshIndicator(
          color: AllColor.blueColor,
          //onRefresh: controller.fetchHistory,
           onRefresh: ()async{
             await Future.delayed(const Duration(seconds: 2));
           },
          child: ListView.separated(
            padding: EdgeInsets.all(16.r),
            itemCount: controller.reports.length,
            separatorBuilder: (_,_) => const Gap(12),
            itemBuilder: (context, index) {
              final report = controller.reports[index];
              final String displayTitle = report.reportTitle.replaceAll('_', ' ');
              final String date = report.createdAt.isNotEmpty ? report.createdAt.split('T').first : 'Recent';

              return Card(
                elevation: 3,
                color: AllColor.whiteColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                 // side: BorderSide(color: AllColor.greyColor300, width: 1.5),
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
                            decoration: BoxDecoration(color: AllColor.blueColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10.r)),
                            child: Icon(Icons.picture_as_pdf_rounded, color: AllColor.redColor, size: 24.r),
                          ),
                          const Gap(12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(text: displayTitle, fontSize: 15.sp, fontWeight: FontWeight.bold, color: AllColor.blackColor),
                                const Gap(4),
                                Row(
                                  children: [
                                    Icon(Icons.calendar_month_outlined, size: 13.r, color: AllColor.greyColor400),
                                    const Gap(4),
                                    CustomText(text: date, fontSize: 12.sp, color: AllColor.greyColor400),
                                  ],
                                ),
                              ],
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