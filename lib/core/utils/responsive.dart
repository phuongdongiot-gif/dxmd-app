import 'package:flutter/material.dart';

extension ResponsiveExtension on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  bool get isMobile => screenWidth < 650;
  bool get isTablet => screenWidth >= 650 && screenWidth < 1100;
  bool get isDesktop => screenWidth >= 1100;
}
