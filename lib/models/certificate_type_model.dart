import 'package:flutter/material.dart';

class CertificateType {
  final String id;
  final String certificateName;
  final String description;
  final bool isFixed;
  final Widget icon;

  const CertificateType({
    required this.id,
    required this.certificateName,
    required this.description,
    required this.icon,
    this.isFixed = false,
  });

  /// Factory for CUSTOM certificate types (from API)
  factory CertificateType.fromJson(Map<String, dynamic> json) {
    return CertificateType(
      id: json["_id"] ?? "",
      certificateName: json["certificateName"] ?? "",
      description: json["description"] ?? "",
      icon: const Icon(Icons.description), // default icon for custom types
      isFixed: false,
    );
  }
}
