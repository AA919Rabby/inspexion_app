import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:inspexion_ai/core/theme/all_color.dart';
import 'package:inspexion_ai/presentation/home/ui/widget/dashboard_stats_widget.dart';
import 'package:inspexion_ai/presentation/home/ui/widget/header_widget.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:AllColor.greyColor300,
      body: SafeArea(child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             // Card(
             //   elevation: 1,
             //   color:AllColor.whiteColor,
             //   shape: RoundedRectangleBorder(
             //     borderRadius: BorderRadius.circular(20.r),
             //   ),
             //   child: Container(
             //     padding: EdgeInsets.all(8.r),
             //     decoration: BoxDecoration(
             //       borderRadius: BorderRadius.circular(20.r),
             //    //   color: AllColor.greyColor300,
             //      // border: Border.all(color: AllColor.blueColor, width: 0.3.w),
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
             //
             //     ),
             //     child: Row(
             //       children: [
             //         Container(
             //           height: 100.h,
             //           width: 100.w,
             //           decoration: BoxDecoration(
             //             shape: BoxShape.circle,
             //             color: AllColor.yellowColor
             //           ),
             //         ),
             //       Column(
             //         mainAxisAlignment: MainAxisAlignment.start,
             //         crossAxisAlignment: CrossAxisAlignment.start,
             //         children: [
             //           CustomText(text: "Md Rabbi",fontWeight: FontWeight.w600,),
             //           const Gap(5),
             //           CustomText(text: "InspeXion AI",color: AllColor.blueColor,
             //             fontSize: 15,),
             //         ],
             //       ),
             //       ],
             //     ),
             //   ),
             // ),
              HeaderWidget(),
              const Gap(15),
              /// stats
              DashboardStatsWidget(),
            ],
          ),
        ),
      )),
    );
  }
}
