import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

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

    /// ✅ IMAGE AVAILABLE (CACHED)
    if (resolvedImage != null && resolvedImage.isNotEmpty) {
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: resolvedImage,
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,

          /// loading placeholder
          placeholder: (_, __) => Container(
            width: radius * 2,
            height: radius * 2,
            color: Colors.grey.shade200,
            alignment: Alignment.center,
            child: SizedBox(
              width: radius,
              height: radius,
              child: const CircularProgressIndicator(strokeWidth: 2),
            ),
          ),

          /// error fallback
          errorWidget: (_, __, ___) => _initialAvatar(),
        ),
      );
    }

    /// ✅ INITIALS FALLBACK
    return _initialAvatar();
  }

  /// ================= INITIAL AVATAR =================

  Widget _initialAvatar() {
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
    if (imageUrl?.isNotEmpty == true) {
      return imageUrl;
    }

    if (googleDriveLink?.isNotEmpty == true) {
      return _convertDriveLink(googleDriveLink!);
    }

    return null;
  }

  /// ================= GOOGLE DRIVE FIX =================

  String _convertDriveLink(String link) {
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