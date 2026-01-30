import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hms/screens/module_login_screen.dart';

import '../models/hospital_panel_model.dart';
import '../utils/constants.dart';

class HospitalPanelCard extends StatelessWidget {
  final HospitalPanel panel;

  const HospitalPanelCard({super.key, required this.panel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // IMAGE
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(6)),
            child: AspectRatio(
              aspectRatio: 1.4,
              child: Image.network(
                panel.image,
                fit: BoxFit.cover,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  panel.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 6),

                Row(
                  children: [
                    Icon(Icons.person, size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 6),
                    Text(
                      "Total Registration : ${panel.totalRegistrations}",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: AppColors.info,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                      ),
                      onPressed: () => Get.to(() => ModuleLoginScreen(module: panel.module)),
                      child: const Row(
                        children: [
                          Text(
                            "Start Registration  ",
                            style: TextStyle(fontSize: 12),
                          ),
                          Icon(Icons.chevron_right_rounded)
                        ],
                      ),
                    ),

                    _rating(panel.rating),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _rating(double value) {
    return Row(
      children: [
        Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.orange,
          ),
        ),
        const SizedBox(width: 4),
        const Icon(Icons.star, color: Colors.orange, size: 16),
      ],
    );
  }
}
