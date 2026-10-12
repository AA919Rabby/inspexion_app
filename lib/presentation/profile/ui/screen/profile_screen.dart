import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inspexion_ai/core/theme/all_color.dart';
import 'package:inspexion_ai/global/custom_button.dart';
import 'package:inspexion_ai/global/custom_image_picker_sheet.dart';
import 'package:inspexion_ai/global/custom_text.dart';
import 'package:inspexion_ai/global/custom_text_field.dart';
import 'package:inspexion_ai/presentation/profile/controller/profile_controller.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileController>();

    return Scaffold(
      backgroundColor: AllColor.greyColor300,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios_new, color: AllColor.whiteColor, size: 20.r),
        ),
        backgroundColor: AllColor.blueColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        toolbarHeight: 70.h,
        title: CustomText(
          text: 'Edit Profile',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AllColor.whiteColor,
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 20.h),
                child: Form(
                  key: profileController.profileKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            CustomImagePickerSheet.show(
                              onPick: (ImageSource source) {
                                profileController.pickImage(source);
                              },
                            );
                          },
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Container(
                                height: 140.r,
                                width: 140.r,
                                padding: EdgeInsets.all(3.r),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AllColor.whiteColor,
                                  border: Border.all(
                                    color: AllColor.yellowColor,
                                    width: 3.w,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.12),
                                      blurRadius: 14,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: Obx(() {
                                    if (profileController.selectedImage.value != null) {
                                      return Image.file(
                                        profileController.selectedImage.value!,
                                        fit: BoxFit.cover,
                                        width: 140.r,
                                        height: 140.r,
                                      );
                                    }
                                    if (profileController.networkAvatarUrl.value.isNotEmpty) {
                                      return Image.network(
                                        profileController.networkAvatarUrl.value,
                                        key: ValueKey(profileController.networkAvatarUrl.value),
                                        fit: BoxFit.cover,
                                        width: 140.r,
                                        height: 140.r,
                                        errorBuilder: (_, _,_) => Icon(
                                          Icons.add_a_photo_rounded,
                                          color: AllColor.blueColor,
                                          size: 55.r,
                                        ),
                                      );
                                    }
                                    return Icon(
                                      Icons.add_a_photo_rounded,
                                      color: AllColor.blueColor,
                                      size: 55.r,
                                    );
                                  }),
                                ),
                              ),

                              // Floating Camera Badge
                              Container(
                                padding: EdgeInsets.all(8.r),
                                decoration: BoxDecoration(
                                  color: AllColor.blueColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AllColor.whiteColor, width: 2.5.w),
                                ),
                                child: Icon(Icons.camera_alt_rounded, color: AllColor.whiteColor, size: 16.r),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Gap(30),

                      // Form Container Card
                      Container(
                        padding: EdgeInsets.all(20.r),
                        decoration: BoxDecoration(
                          color: AllColor.whiteColor,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(text: "Username", fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
                            const Gap(6),
                            CustomTextField(
                              controller: profileController.nameClt,
                              hintText: "Enter full username",
                              validator: (value) => (value == null || value.isEmpty) ? 'Required' : null,
                              prefixIcon: Icon(Icons.person_outline_rounded, color: AllColor.blueColor),
                            ),
                            const Gap(16),

                            CustomText(text: "Phone Number", fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
                            const Gap(6),
                            CustomTextField(
                              controller: profileController.numberClt,
                              hintText: "Enter contact number",
                              prefixIcon: Icon(Icons.phone_outlined, color: AllColor.blueColor),
                              validator: (value) => (value == null || value.isEmpty) ? 'Required' : null,
                            ),
                            const Gap(16),

                            CustomText(text: "City", fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
                            const Gap(6),
                            CustomTextField(
                              controller: profileController.cityClt,
                              hintText: "Enter your city",
                              validator: (value) => (value == null || value.isEmpty) ? 'Required' : null,
                              prefixIcon: Icon(Icons.location_city_rounded, color: AllColor.blueColor),
                            ),
                            const Gap(16),

                            CustomText(text: "Address", fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
                            const Gap(6),
                            CustomTextField(
                              controller: profileController.addressClt,
                              hintText: "Enter physical address",
                              validator: (value) => (value == null || value.isEmpty) ? 'Required' : null,
                              prefixIcon: Icon(Icons.location_on_outlined, color: AllColor.blueColor),
                            ),
                            const Gap(16),

                            CustomText(text: "Age", fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
                            const Gap(6),
                            CustomTextField(
                              controller: profileController.ageClt,
                              hintText: "Enter your age",
                              prefixIcon: Icon(Icons.calendar_today_rounded, color: AllColor.blueColor),
                              validator: (value) => (value == null || value.isEmpty) ? 'Required' : null,
                            ),
                          ],
                        ),
                      ),
                      const Gap(32),

                      // Save Button with Loading State
                      Obx(
                            () => profileController.isLoading.value
                            ? const Center(child: CircularProgressIndicator())
                            : CustomButton(
                          text: "Save Changes",
                          backgroundColor: AllColor.blueColor,
                          textColor: AllColor.whiteColor,
                          onPressed: profileController.updateProfile,
                        ),
                      ),
                      const Gap(20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}