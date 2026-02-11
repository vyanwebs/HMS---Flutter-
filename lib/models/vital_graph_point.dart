class VitalGraphPoint {
  final DateTime recordedAt;

  /// for normal vitals
  final double? value;

  /// for BP
  final double? systolic;
  final double? diastolic;

  VitalGraphPoint({
    required this.recordedAt,
    this.value,
    this.systolic,
    this.diastolic,
  });

  factory VitalGraphPoint.fromJson(
    Map<String, dynamic> json,
    String type,
  ) {
    final recordedAt = DateTime.parse(json['recordedAt']);

    if (type == "bp") {
      final bp = json['bp'];
      if (bp is String && bp.contains('/')) {
        final parts = bp.split('/');
        return VitalGraphPoint(
          recordedAt: recordedAt,
          systolic: double.tryParse(parts[0]),
          diastolic: double.tryParse(parts[1]),
        );
      }
      return VitalGraphPoint(recordedAt: recordedAt);
    }

    return VitalGraphPoint(
      recordedAt: recordedAt,
      value: (json[type] as num?)?.toDouble(),
    );
  }
}
