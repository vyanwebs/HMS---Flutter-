import 'package:flutter/material.dart';
import '../../utils/text.dart';

class StatCardWidget extends StatelessWidget {
  final String title;
  final String value;
  final Gradient gradient;
  final String imagePath;

  const StatCardWidget({
    super.key,
    required this.title,
    required this.value,
    required this.gradient,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            bottom: 0,
            child: _backgroundImage(),
          ),
          Positioned(
            left: 20,
            bottom: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  value,
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF000000),
                ),
                const SizedBox(height: 50),
                AppText(
                  title,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF757575),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _backgroundImage() {
    return SizedBox(
      width: 120,
      height: 90,
      child: Image.asset(
        imagePath,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Icon(
                Icons.insert_chart,
                color: Colors.white,
                size: 24,
              ),
            ),
          );
        },
      ),
    );
  }
}
