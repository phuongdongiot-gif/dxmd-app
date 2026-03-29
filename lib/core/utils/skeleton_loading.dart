import 'package:flutter/material.dart';

class SkeletonLoading extends StatefulWidget {
  final double? width;
  final double? height;
  final double borderRadius;

  const SkeletonLoading({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 8.0,
  });

  @override
  State<SkeletonLoading> createState() => _SkeletonLoadingState();
}

class _SkeletonLoadingState extends State<SkeletonLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorTween;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _colorTween = ColorTween(
      begin: Colors.grey[300],
      end: Colors.grey[100],
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            // Default to constrained bounds, or fallback to 100x100 if infinite and null
            double w = widget.width ?? (constraints.hasBoundedWidth ? constraints.maxWidth : 100);
            double h = widget.height ?? (constraints.hasBoundedHeight ? constraints.maxHeight : 100);
            
            return Container(
              width: w,
              height: h,
              decoration: BoxDecoration(
                color: _colorTween.value,
                borderRadius: BorderRadius.circular(widget.borderRadius),
              ),
            );
          }
        );
      },
    );
  }
}
