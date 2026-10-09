import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:inspexion_ai/core/theme/all_color.dart';
import 'package:inspexion_ai/global/custom_text.dart';
import 'package:inspexion_ai/presentation/settings/ui/widget/settings_list.dart';


class SettingsScreen extends StatelessWidget {
  const SettingsScreen ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:AllColor.greyColor300,
      appBar: AppBar(
        backgroundColor: AllColor.blueColor,
        scrolledUnderElevation: 0,
        elevation: 0,
        title: CustomText(text: "Settings",fontSize: 25,color: AllColor.whiteColor,),
      ),
      body: SafeArea(child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             // CustomText(text: "Settings",fontSize: 25,),
            //  const Gap(10),
              /// settings list 
              SettingsList(),
            ],
          ),
        ),
      )),
    );
  }
}
