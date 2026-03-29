import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/modern_bottom_nav_bar.dart';

class MainScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainScreen({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Cho phép nền chạy chìm phía sau Bottom NavBar
      body: navigationShell,
      bottomNavigationBar: ModernBottomNavBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
      ),
    );
  }
}
