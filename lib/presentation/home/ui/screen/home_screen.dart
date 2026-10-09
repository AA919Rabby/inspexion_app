import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:inspexion_ai/core/theme/all_color.dart';
import 'package:inspexion_ai/global/custom_text.dart';
import 'package:inspexion_ai/presentation/home/ui/widget/dashboard_stats_widget.dart';



class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: AllColor.blueColor, // Kept exactly the same
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: 100.h,
        // FIXED: Using title with absolute horizontal padding to fill the screen edges completely
        titleSpacing: 0,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
          child: Row(
            children: [
              Container(
                height: 75.h,
                width: 75.w,
                decoration: BoxDecoration(
                    border: Border.all(color: AllColor.yellowColor, width: 5.w),
                    shape: BoxShape.circle,
                    color: AllColor.whiteColor),
              ),
              const Gap(10),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: "Welcome,",
                    color: AllColor.whiteColor,
                    fontSize: 17,
                  ),
                  const Gap(5),
                  CustomText(
                    text: "Md Rabbi",
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                    color: AllColor.whiteColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

      // appBar: AppBar(
      //   backgroundColor: AllColor.blueColor,
      //   elevation: 0,
      //   scrolledUnderElevation: 0,
      //   automaticallyImplyLeading: false,
      //   toolbarHeight: 100.h,
      //   flexibleSpace: Container(
      //     padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 5.h),
      //     decoration: BoxDecoration(
      //       borderRadius: BorderRadius.circular(20.r),
      //       //   color: AllColor.greyColor300,
      //       // border: Border.all(color: AllColor.blackColor, width: 0.05.w),
      //       // boxShadow: [
      //       //   BoxShadow(
      //       //     color: AllColor.greyColor400,
      //       //     spreadRadius: 0,
      //       //     blurRadius: 10,
      //       //     offset: Offset(4, 4), // changes position of shadow
      //       //   ),
      //       //   BoxShadow(
      //       //     color: AllColor.greyColor400,
      //       //     spreadRadius: 0,
      //       //     blurRadius: 10,
      //       //     offset: Offset(-4, -4), // changes position of shadow
      //       //   ),
      //       // ],
      //     ),
      //     child: Row(
      //       children: [
      //         Container(
      //           height: 75.h,
      //           width: 75.w,
      //           decoration: BoxDecoration(
      //               border: Border.all(color: AllColor.yellowColor, width:5.w),
      //               shape: BoxShape.circle,
      //               color: AllColor.whiteColor
      //           ),
      //         ),
      //         const Gap(10),
      //         Column(
      //           mainAxisAlignment: MainAxisAlignment.start,
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             CustomText(text: "Welcome,",color: AllColor.whiteColor,
      //               fontSize: 17,),
      //             const Gap(5),
      //             CustomText(text: "Md Rabbi",fontWeight: FontWeight.w600,fontSize: 20,color: AllColor.whiteColor,),
      //           ],
      //         ),
      //       ],
      //     ),
      //   ),
      // ),

      backgroundColor: AllColor.greyColor300,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // TODO: Implement your refresh logic / API calls here
            await Future.delayed(const Duration(seconds: 2));
          },
          child: SingleChildScrollView(
            // AlwaysScrollableScrollPhysics ensures the pull-to-refresh
            // gesture triggers even if content fits without scrolling.
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.all(20.r),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Top header
                //  HeaderWidget(),
                  const Gap(15),

                  /// stats
                  DashboardStatsWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
