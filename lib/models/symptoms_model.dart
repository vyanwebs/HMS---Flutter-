class SymptomRecord {
  final String id;
  final String patientMongoId;
  final String patientId;
  final String doctorMongoId;
  final String doctorId;
  final String admissionCode;
  final String admissionType;
  final String admissionId;

  final RecordedBy? recordedBy;
  final List<SymptomItem> symptoms;

  final String notes;
  final DateTime? recordedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SymptomRecord({
    required this.id,
    required this.patientMongoId,
    required this.patientId,
    required this.doctorMongoId,
    required this.doctorId,
    required this.admissionCode,
    required this.admissionType,
    required this.admissionId,
    required this.symptoms,
    required this.notes,
    this.recordedBy,
    this.recordedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory SymptomRecord.fromJson(Map<String, dynamic> json) {
    return SymptomRecord(
      id: json['_id'] ?? '',
      patientMongoId: json['patientMongoId'] ?? '',
      patientId: json['patientId'] ?? '',
      doctorMongoId: json['doctorMongoId'] ?? '',
      doctorId: json['doctorId'] ?? '',
      admissionCode: json['admissionCode']?.toString() ?? '',
      admissionType: json['admissionType'] ?? '',
      admissionId: json['admissionId'] ?? '',
      notes: json['notes'] ?? '',
      recordedBy: json['recordedBy'] != null
          ? RecordedBy.fromJson(json['recordedBy'])
          : null,
      symptoms: (json['symptoms'] as List? ?? [])
          .map((e) => SymptomItem.fromJson(e))
          .toList(),
      recordedAt: _parseDate(json['recordedAt']),
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
    );
  }

  SymptomRecord copyWith({
    List<SymptomItem>? symptoms,
  }) {
    return SymptomRecord(
      id: id,
      patientMongoId: patientMongoId,
      patientId: patientId,
      doctorMongoId: doctorMongoId,
      doctorId: doctorId,
      admissionCode: admissionCode,
      admissionType: admissionType,
      admissionId: admissionId,
      symptoms: symptoms ?? this.symptoms,
      notes: notes,
      recordedBy: recordedBy,
      recordedAt: recordedAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    try {
      return DateTime.parse(value);
    } catch (_) {
      return null;
    }
  }
}

class RecordedBy {
  final String id;
  final String staffId;
  final String role;

  RecordedBy({
    required this.id,
    required this.staffId,
    required this.role,
  });

  factory RecordedBy.fromJson(Map<String, dynamic> json) {
    return RecordedBy(
      id: json['id'] ?? '',
      staffId: json['staffId'] ?? '',
      role: json['role'] ?? '',
    );
  }
}

class SymptomItem {
  final String id;
  final String name;
  final String severity;
  final String duration;
  final String message;

  SymptomItem({
    required this.id,
    required this.name,
    required this.severity,
    required this.duration,
    required this.message,
  });

  factory SymptomItem.fromJson(Map<String, dynamic> json) {
    return SymptomItem(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      severity: json['severity'] ?? '',
      duration: json['duration'] ?? '',
      message: json['message'] ?? '',
    );
  }
}
