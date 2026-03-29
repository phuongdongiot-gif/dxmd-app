import 'dart:ui';
import 'package:flutter/material.dart';

class ModernBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const ModernBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // List of navigation items
    final items = [
      _NavItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Trang chủ'),
      _NavItem(icon: Icons.map_outlined, activeIcon: Icons.map, label: 'Dự án'),
      _NavItem(icon: Icons.article_outlined, activeIcon: Icons.article, label: 'Tin tức'),
      _NavItem(icon: Icons.photo_library_outlined, activeIcon: Icons.photo_library, label: 'Thư viện'),
      _NavItem(icon: Icons.work_outline, activeIcon: Icons.work, label: 'Tuyển dụng'),
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85),
            borderRadius: BorderRadius.circular(35),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: const Color(0xFF0D47A1).withOpacity(0.05),
                blurRadius: 30,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(35),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(items.length, (index) {
                  final isActive = index == currentIndex;
                  final item = items[index];

                  return GestureDetector(
                    onTap: () => onTap(index),
                    behavior: HitTestBehavior.opaque,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            transitionBuilder: (Widget child, Animation<double> animation) {
                              return ScaleTransition(
                                scale: animation,
                                child: child,
                              );
                            },
                            child: Icon(
                              isActive ? item.activeIcon : item.icon,
                              key: ValueKey<bool>(isActive),
                              color: isActive ? const Color(0xFF0D47A1) : const Color(0xFF94A3B8),
                              size: isActive ? 26 : 24,
                            ),
                          ),
                          const SizedBox(height: 4),
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 250),
                            style: TextStyle(
                              fontSize: isActive ? 11 : 10,
                              fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
                              color: isActive ? const Color(0xFF0D47A1) : const Color(0xFF94A3B8),
                            ),
                            child: Text(item.label),
                          ),
                          // Subtle unselected dot that expands when active
                          const SizedBox(height: 2),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            height: 3,
                            width: isActive ? 16 : 0,
                            decoration: BoxDecoration(
                              color: isActive ? const Color(0xFF0D47A1) : Colors.transparent,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
