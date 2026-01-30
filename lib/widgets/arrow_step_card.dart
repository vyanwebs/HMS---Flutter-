import 'package:flutter/material.dart';

import '../models/operation_step_model.dart';

class ArrowStepCard extends StatelessWidget {
  final OperationStep step;

  const ArrowStepCard({super.key, required this.step});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          step.number,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xff1E88FF),
          ),
        ),
        const SizedBox(height: 10),

        Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              step.imagePath,
              height: 90, // desktop friendly
              fit: BoxFit.contain,
            ),
            Image.asset(step.icon, scale: 16,)
          ],
        ),

        const SizedBox(height: 12),

        Text(
          step.title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xff1E88FF),
          ),
        ),
      ],
    );
  }
}
