import 'package:flutter/material.dart';

import '../utils/text.dart';

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

Widget dropdownCard<T>({
  required String title,
  required T value,
  required List<T> items,
  required String Function(T) labelBuilder,
  required void Function(T) onChanged,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(title, fontSize: 12, color: Colors.grey),
        const SizedBox(height: 6),
        DropdownButtonHideUnderline(
          child: DropdownButton<T>(
            isExpanded: true,
            value: value,
            icon: const Icon(Icons.keyboard_arrow_down),
            items: items
                .map(
                  (e) => DropdownMenuItem<T>(
                    value: e,
                    child: AppText(labelBuilder(e)),
                  ),
                )
                .toList(),
            onChanged: (v) {
              if (v != null) onChanged(v);
            },
          ),
        ),
      ],
    ),
  );
}
