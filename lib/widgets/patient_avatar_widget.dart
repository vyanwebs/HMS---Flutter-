import 'package:flutter/material.dart';
import '../models/patient_model.dart';
import '../utils/text.dart';

class PatientAvatar extends StatelessWidget {
  final PatientModel patient;
  final double radius;

  const PatientAvatar({
    super.key,
    required this.patient,
    this.radius = 28,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = _resolveImage();

    if (imageUrl != null && imageUrl.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: Colors.grey.shade200,
        backgroundImage: NetworkImage(imageUrl),
        onBackgroundImageError: (_, __) {},
        child: null,
      );
    }

    // 🔥 Fallback to first letter
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.blue.shade100,
      child: AppText(
        patient.initials,
        fontSize: radius,
        fontWeight: FontWeight.bold,
        color: Colors.blue.shade700,
      ),
    );
  }

  String? _resolveImage() {
    if (patient.avatar?.url.isNotEmpty == true) {
      return patient.avatar!.url;
    }

    if (patient.image.isNotEmpty) {
      return patient.image;
    }

    return null;
  }
}
