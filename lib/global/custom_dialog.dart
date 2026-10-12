import 'package:flutter/material.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:inspexion_ai/core/theme/all_color.dart';
import 'package:inspexion_ai/global/custom_text.dart';

class CustomDialog extends StatelessWidget {
  final String? image;
  final Widget? imageWidget;
  final String? title;
  final String? message;
  final Widget? content;
  final String? confirmText;
  final String? cancelText;
  final Color? confirmColor;
  final Color? cancelColor;
  final Color? titleColor;
  final Color? messageColor;
  final Color? backgroundColor;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool showConfirmButton;
  final bool showCancelButton;
  final bool barrierDismissible;
  final double? imageSize;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;

  const CustomDialog({
    super.key,
    this.image,
    this.imageWidget,
    this.title,
    this.message,
    this.content,
    this.confirmText = 'Yes',
    this.cancelText = 'No',
    this.confirmColor,
    this.cancelColor,
    this.titleColor,
    this.messageColor,
    this.backgroundColor,
    this.onConfirm,
    this.onCancel,
    this.showConfirmButton = true,
    this.showCancelButton = true,
    this.barrierDismissible = true,
    this.imageSize,
    this.borderRadius = 24,
    this.padding,
  });

  Widget _buildDefaultIcon() {
    return Container(
      width: 62.r,
      height: 62.r,
      decoration: BoxDecoration(
        color: AllColor.redColor.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.logout_rounded,
        color: AllColor.redColor,
        size: 30.r,
      ),
    );
  }

  Widget? _buildImage() {
    if (imageWidget != null) return imageWidget;

    if (image != null && image!.isNotEmpty) {
      return Container(
        width: imageSize ?? 62.r,
        height: imageSize ?? 62.r,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.network(
          image!,
          fit: BoxFit.cover,
        ),
      );
    }

    return _buildDefaultIcon();
  }

  Widget _buildCancelButton(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 48.h,
        child: OutlinedButton(
          onPressed: () {
            Navigator.of(context).pop();
            if (onCancel != null) onCancel!();
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: cancelColor ?? AllColor.blueColor,
            backgroundColor: Colors.transparent,
            elevation: 0,
            padding: EdgeInsets.zero,
            side: BorderSide(
              color: cancelColor ?? AllColor.blueColor,
              width: 1.5.w,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.r),
            ),
          ),
          child: CustomText(
            text: cancelText ?? 'No',
            color: cancelColor ?? AllColor.blueColor,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 48.h,
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            if (onConfirm != null) onConfirm!();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: confirmColor ?? AllColor.blueColor,
            foregroundColor: AllColor.whiteColor,
            elevation: 0,
            padding: EdgeInsets.zero,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.r),
            ),
          ),
          child: CustomText(
            text: confirmText ?? 'Yes',
            color: AllColor.whiteColor,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget? topImage = _buildImage();

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 480.w),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor ?? AllColor.whiteColor,
            borderRadius: BorderRadius.circular(borderRadius ?? 24.r),
            border: Border.all(
              color: Colors.white,
              width: 1.5.w,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: padding ?? EdgeInsets.symmetric(horizontal: 22.w, vertical: 26.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (topImage != null) ...[
                  topImage,
                  const Gap(16),
                ],
                if (title != null) ...[
                  CustomText(
                    text: title!,
                    textAlign: TextAlign.center,
                    color: titleColor ?? AllColor.blackColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  const Gap(8),
                ],
                if (message != null) ...[
                  CustomText(
                    text: message!,
                    textAlign: TextAlign.center,
                    color: messageColor ?? Colors.grey.shade600,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  const Gap(22),
                ],
                if (content != null) ...[
                  content!,
                  const Gap(20),
                ],
                if (showConfirmButton || showCancelButton)
                  Row(
                    children: [
                      if (showCancelButton) _buildCancelButton(context),
                      if (showCancelButton && showConfirmButton) const Gap(10),
                      if (showConfirmButton) _buildConfirmButton(context),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Future<T?> show<T>({
    required BuildContext context,
    String? image,
    Widget? imageWidget,
    String? title,
    String? message,
    Widget? content,
    String? confirmText,
    String? cancelText,
    Color? confirmColor,
    Color? cancelColor,
    Color? titleColor,
    Color? messageColor,
    Color? backgroundColor,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool? showConfirmButton,
    bool? showCancelButton,
    bool barrierDismissible = true,
    double? imageSize,
    double? borderRadius,
    EdgeInsetsGeometry? padding,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (context) {
        return CustomDialog(
          image: image,
          imageWidget: imageWidget,
          title: title,
          message: message,
          content: content,
          confirmText: confirmText ?? 'Yes',
          cancelText: cancelText ?? 'No',
          confirmColor: confirmColor ?? AllColor.blueColor,
          cancelColor: cancelColor,
          titleColor: titleColor,
          messageColor: messageColor,
          backgroundColor: backgroundColor ?? AllColor.whiteColor,
          onConfirm: onConfirm,
          onCancel: onCancel,
          showConfirmButton: showConfirmButton ?? true,
          showCancelButton: showCancelButton ?? true,
          barrierDismissible: barrierDismissible,
          imageSize: imageSize,
          borderRadius: borderRadius ?? 24.r,
          padding: padding,
        );
      },
    );
  }
}