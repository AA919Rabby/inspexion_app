import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:inspexion_ai/core/theme/all_color.dart';
import 'package:inspexion_ai/global/custom_text.dart';


class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
       elevation: 2,
      color:AllColor.whiteColor,
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(20.r),
      // ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w,vertical: 2.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          //   color: AllColor.greyColor300,
          // border: Border.all(color: AllColor.blackColor, width: 0.05.w),
          // boxShadow: [
          //   BoxShadow(
          //     color: AllColor.greyColor400,
          //     spreadRadius: 0,
          //     blurRadius: 10,
          //     offset: Offset(4, 4), // changes position of shadow
          //   ),
          //   BoxShadow(
          //     color: AllColor.greyColor400,
          //     spreadRadius: 0,
          //     blurRadius: 10,
          //     offset: Offset(-4, -4), // changes position of shadow
          //   ),
          // ],
        ),
        child: Row(
          children: [
            Container(
              height: 65.h,
              width: 65.w,
              decoration: BoxDecoration(
                  border: Border.all(color: AllColor.blueColor, width:2.w),
                  shape: BoxShape.circle,
                  color: AllColor.yellowColor
              ),
            ),
            const Gap(10),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(text: "Welcome,",color: AllColor.blackColor,
                  fontSize: 15,),
                const Gap(5),
                CustomText(text: "Md Rabbi",fontWeight: FontWeight.w600,),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
