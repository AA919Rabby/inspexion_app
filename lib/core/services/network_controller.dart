import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:get/get.dart';
import 'package:inspexion_ai/core/theme/all_color.dart';
import 'package:inspexion_ai/global/custom_button.dart';
import 'package:inspexion_ai/global/custom_text.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  final RxBool isConnected = true.obs;

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(dynamic result) {
    bool hasNoInternet = false;

    if (result is List<ConnectivityResult>) {
      hasNoInternet = result.contains(ConnectivityResult.none) || result.isEmpty;
    } else if (result is ConnectivityResult) {
      hasNoInternet = result == ConnectivityResult.none;
    }

    if (hasNoInternet) {
      isConnected.value = false;
      _showNoInternetDialog();
    } else {
      isConnected.value = true;
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
    }
  }

  void _showNoInternetDialog() {
    if (Get.isDialogOpen ?? false) return;

    Get.dialog(
      PopScope(
        canPop: false, // Prevents Android back button from dismissing dialog
        child: Dialog(
          backgroundColor: AllColor.whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(24.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.wifi_off_rounded,
                  color: AllColor.redColor,
                  size: 60.r,
                ),
                const Gap(16),
                CustomText(
                  text: "No Internet Connection",
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AllColor.blackColor,
                ),
                const Gap(8),
                CustomText(
                  text: "InspeXion AI requires an active internet connection to run AI inspections. Please turn on your internet or close the app.",
                  fontSize: 13,
                  color: AllColor.greyColor400,
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
                const Gap(24),
                CustomButton(
                  text: "Close App",
                  backgroundColor: AllColor.redColor,
                  textColor: AllColor.whiteColor,
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}