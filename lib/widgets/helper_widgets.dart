import 'package:flutter/material.dart';

Widget featureIcon(IconData icon, Color color) {
  return Container(
    width: 46,
    height: 46,
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.15),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Icon(icon, color: color, size: 24),
  );
}

Widget imageAvatar(String imageUrl) {
  return Stack(
    children: [
      Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(imageUrl),
          ),
        ),
      ),
      Positioned(
        bottom: 2,
        right: 2,
        child: Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
        ),
      ),
    ],
  );
}