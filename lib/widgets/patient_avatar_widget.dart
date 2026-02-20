import 'package:flutter/material.dart';

import '../utils/text.dart';

class PatientAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? googleDriveLink;
  final String name;
  final double radius;

  const PatientAvatar({
    super.key,
    required this.name,
    this.imageUrl,
    this.googleDriveLink,
    this.radius = 28,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedImage = _resolveImage();

    /// ✅ IMAGE AVAILABLE
    if (resolvedImage != null && resolvedImage.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: Colors.grey.shade200,
        backgroundImage: NetworkImage(resolvedImage),
        onBackgroundImageError: (_, __) {},
      );
    }

    /// ✅ FALLBACK INITIALS
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.blue.shade100,
      child: AppText(
        _initials(name),
        fontSize: radius * 0.7,
        fontWeight: FontWeight.bold,
        color: Colors.blue.shade700,
      ),
    );
  }

  /// ================= IMAGE RESOLVER =================

  String? _resolveImage() {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return imageUrl;
    }

    if (googleDriveLink != null && googleDriveLink!.isNotEmpty) {
      return _convertDriveLink(googleDriveLink!);
    }

    return null;
  }

  /// ================= GOOGLE DRIVE FIX =================

  String _convertDriveLink(String link) {
    if (!link.contains("drive.google.com")) return link;

    final reg = RegExp(r'/d/(.*?)/');
    final match = reg.firstMatch(link);

    if (match != null) {
      return "https://drive.google.com/uc?export=view&id=${match.group(1)}";
    }

    return link;
  }

  /// ================= INITIALS =================

  String _initials(String name) {
    final parts = name.trim().split(" ");

    if (parts.length == 1) {
      return parts.first[0].toUpperCase();
    }

    return "${parts.first[0]}${parts.last[0]}".toUpperCase();
  }
}