import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspexion_ai/global/custom_text.dart'; // Adjust this import path if needed

void customSnackbar(
    BuildContext context, {
      required String title,
      required String message,
      Color backgroundColor = Colors.green,
      bool isError = false,
    }) {

  Get.closeCurrentSnackbar();

  Get.snackbar(
    title,
    message,
    snackPosition: SnackPosition.TOP,
    backgroundColor: isError ? Colors.red : backgroundColor,
    colorText: Colors.white,
    borderRadius: 8.0,
    margin: const EdgeInsets.all(16.0),
    duration: const Duration(seconds: 3),
    dismissDirection: DismissDirection.up,
    isDismissible: true,
    titleText: CustomText(
      text: title,
      fontWeight: FontWeight.bold,
      fontSize: 16.0,
      color: Colors.white,
    ),
    messageText: CustomText(
      text: message,
      fontSize: 14.0,
      color: Colors.white,
    ),
  );
}