import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:get/get.dart';
import 'package:inspexion_ai/core/theme/all_color.dart';
import 'package:inspexion_ai/global/custom_text.dart';
import 'package:inspexion_ai/global/custom_text_field.dart';



class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AllColor.greyColor300,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: AllColor.whiteColor,
          ),
        ),
        backgroundColor: AllColor.blueColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: CustomText(
          text: 'Edit Profile',
          fontSize: 22,
          color: AllColor.whiteColor,
        ),
      ),
      body: SafeArea(child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.r),
          child: Column(
            children: [
              Container(
                height: 100.h,
                width: 100.w,
                decoration: BoxDecoration(
                    border: Border.all(color: AllColor.yellowColor, width: 5.w),
                    shape: BoxShape.circle,
                    color: AllColor.whiteColor),
                child: Icon(Icons.add_a_photo,color: AllColor.blueColor,size: 70.r,),
              ),
              const Gap(20),
              CustomText(text: "Enter your name"),
              CustomTextField(),
            ],
          ),
        ),
      )),
    );
  }
}