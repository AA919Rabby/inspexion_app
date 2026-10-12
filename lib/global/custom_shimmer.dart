import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class CustomShimmer extends StatefulWidget {
  final double? width;
  final double? height;
  final ShapeBorder shape;
  final BorderRadiusGeometry? borderRadius;

  const CustomShimmer({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.shape = const RoundedRectangleBorder(),
  });

  const CustomShimmer.circle({
    super.key,
    required double size,
  })  : width = size,
        height = size,
        shape = const CircleBorder(),
        borderRadius = null;

  @override
  State<CustomShimmer> createState() => _CustomShimmerState();
}

class _CustomShimmerState extends State<CustomShimmer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  void disposeWidget() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            shape: widget.shape is CircleBorder ? BoxShape.circle : BoxShape.rectangle,
            borderRadius: widget.shape is CircleBorder
                ? null
                : (widget.borderRadius ?? BorderRadius.circular(16.r)),
            gradient: LinearGradient(
              begin: Alignment(-1.8 + (_controller.value * 3.6), -0.3),
              end: Alignment(1.8 + (_controller.value * 3.6), 0.3),
              colors: [
                Colors.grey.shade300,
                Colors.grey.shade100,
                Colors.grey.shade300,
              ],
              stops: const [0.1, 0.5, 0.9],
            ),
          ),
        );
      },
    );
  }
}