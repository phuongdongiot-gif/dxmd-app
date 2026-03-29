import 'dart:ui';
import 'package:flutter/material.dart';

class ModernHeaderBackground extends StatelessWidget {
  const ModernHeaderBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base color
        Container(color: const Color(0xFFF8FAFC)),
        
        // Decorative glowing circle top right
        Positioned(
          top: -40,
          right: -20,
          child: Container(
            width: 150, 
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF0D47A1).withOpacity(0.06),
            ),
          ),
        ),
        
        // Decorative glowing circle bottom left
        Positioned(
          bottom: 20,
          left: -40,
          child: Container(
            width: 180, 
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF0D47A1).withOpacity(0.04),
            ),
          ),
        ),
        
        // Frosted glass effect
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(color: Colors.white.withOpacity(0.5)),
          ),
        ),
      ],
    );
  }
}
