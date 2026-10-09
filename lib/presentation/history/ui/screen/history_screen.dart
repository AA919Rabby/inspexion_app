import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:inspexion_ai/core/theme/all_color.dart';
import 'package:inspexion_ai/global/custom_text.dart';
import 'package:get/get.dart';
import 'package:inspexion_ai/presentation/history/controller/history_controller.dart';



class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final historyController = Get.find<HistoryController>();
    return Scaffold(
      backgroundColor:AllColor.greyColor300,
      appBar: AppBar(
        backgroundColor: AllColor.blueColor,
        scrolledUnderElevation: 0,
        elevation: 0,
        title: CustomText(text: "History",fontSize: 25,color: AllColor.whiteColor,),
      ),
      body: SafeArea(child: SingleChildScrollView(child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          children: [

          ],
        ),
      ),)),
    );
  }
}
