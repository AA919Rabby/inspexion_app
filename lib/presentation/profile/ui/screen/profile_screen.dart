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
      body: Obx(
            () => Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(20.r),
                  child: Form(
                    key: profileController.profileKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Avatar Photo Container with Image Picker
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              CustomImagePickerSheet.show(
                                onPick: (ImageSource source) {
                                  profileController.pickImage(source);
                                },
                              );
                            },
                            child: Container(
                              height: 150.h,
                              width: 150.w,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: AllColor.whiteColor,
                                    offset: const Offset(0, 3),
                                    blurRadius: 1,
                                    spreadRadius: 0,
                                  ),
                                ],
                                border: Border.all(
                                  color: AllColor.yellowColor,
                                  width: 5.w,
                                ),
                                shape: BoxShape.circle,
                                color: AllColor.whiteColor,
                              ),
                              child: ClipOval(
                                child: Obx(() {
                                  if (profileController.selectedImage.value != null) {
                                    return Image.file(
                                      profileController.selectedImage.value!,
                                      fit: BoxFit.cover,
                                      width: 151.w,
                                      height: 150.h,
                                    );
                                  } else if (profileController.networkAvatarUrl.value.isNotEmpty) {
                                    return Image.network(
                                      profileController.networkAvatarUrl.value,
                                      fit: BoxFit.cover,
                                      width: 150.w,
                                      height: 150.h,
                                      errorBuilder: (_, _, _) => Icon(
                                        Icons.add_a_photo,
                                        color: AllColor.blueColor,
                                        size: 80.r,
                                      ),
                                    );
                                  }
                                  return Icon(
                                    Icons.add_a_photo,
                                    color: AllColor.blueColor,
                                    size: 80.r,
                                  );
                                }),
                              ),
                            ),
                          ),
                        ),

                        const Gap(20),
                        CustomText(text: "Enter your username"),
                        const Gap(5),
                        CustomTextField(
                          controller: profileController.nameClt,
                          hintText: "Username",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            if (value.length < 3) {
                              return 'Too short';
                            }
                            return null;
                          },
                          prefixIcon: Icon(
                            Icons.person,
                            color: AllColor.blueColor,
                          ),
                        ),

                        const Gap(5),
                        CustomText(text: "Enter your phone number"),
                        const Gap(5),
                        CustomTextField(
                          controller: profileController.numberClt,
                          hintText: "Phone Number",
                          prefixIcon: Icon(
                            Icons.phone,
                            color: AllColor.blueColor,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Required';
                            }
                            final phoneRegex = RegExp(r'^[0-9]+$');
                            if (!phoneRegex.hasMatch(value.trim()) || value.trim().length < 11) {
                              return 'Minimum 11 digits';
                            }
                            return null;
                          },
                        ),

                        const Gap(5),
                        CustomText(text: "Enter your city"),
                        const Gap(5),
                        CustomTextField(
                          controller: profileController.cityClt,
                          hintText: "City",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            if (value.length < 3) {
                              return 'Too short';
                            }
                            return null;
                          },
                          prefixIcon: Icon(
                            Icons.location_city,
                            color: AllColor.blueColor,
                          ),
                        ),

                        const Gap(5),
                        CustomText(text: "Enter your address"),
                        const Gap(5),
                        CustomTextField(
                          controller: profileController.addressClt,
                          hintText: "Address",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            if (value.length < 3) {
                              return 'Too short';
                            }
                            return null;
                          },
                          prefixIcon: Icon(
                            Icons.location_on,
                            color: AllColor.blueColor,
                          ),
                        ),

                        const Gap(5),
                        CustomText(text: "Enter your age"),
                        const Gap(5),
                        CustomTextField(
                          controller: profileController.ageClt,
                          hintText: "Age",
                          prefixIcon: Icon(
                            Icons.calendar_today_rounded, // Fixed syntax error
                            color: AllColor.blueColor,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Required';
                            }
                            final age = RegExp(r'^[0-9]+$');
                            if (!age.hasMatch(value.trim()) || value.trim().length < 2) {
                              return 'Minimum 2 digits';
                            }
                            return null;
                          },
                        ),

                        const Gap(50),

                        // Save Button
                        Obx(()=>profileController.isLoading.value?CircularProgressIndicator():
                        CustomButton(
                          text: "Save",
                          backgroundColor: AllColor.blueColor,
                          textColor: AllColor.whiteColor,
                          onPressed: profileController.updateProfile,
                        ),),

                        const Gap(30),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Full-screen CircularProgressIndicator without color
            // if (profileController.isLoading.value)
            //   Container(
            //     width: double.infinity,
            //     height: double.infinity,
            //     color: Colors.black.withValues(alpha: 0.6),
            //     child: const Center(
            //       child: CircularProgressIndicator(),
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }
}