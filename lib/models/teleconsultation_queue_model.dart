class TeleconsultationQueueModel {
  // Core IDs
  final String id;               // _id
  final String doctorId;
  final String admissionId;

  // Patient details (flattened for UI)
  final String patientId;
  final String patientName;
  final int patientAge;
  final String patientGender;
  final String patientAvatar;

  // Teleconsultation details
  final DateTime startTime;
  final DateTime endTime;
  final String status;
  final String reason;
  final String meetingLink;

  // Meta
  final DateTime createdAt;
  final DateTime updatedAt;

  // UI-only
  final String waitingTime; // "Waiting: 15 min"

  TeleconsultationQueueModel({
    required this.id,
    required this.doctorId,
    required this.admissionId,
    required this.patientId,
    required this.patientName,
    required this.patientAge,
    required this.patientGender,
    required this.patientAvatar,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.reason,
    required this.meetingLink,
    required this.createdAt,
    required this.updatedAt,
    required this.waitingTime,
  });

  // ================= FROM JSON =================
  factory TeleconsultationQueueModel.fromJson(Map<String, dynamic> json) {
    final patient = json['patientId'] ?? {};
    final avatar = patient['avatar'] ?? {};

    return TeleconsultationQueueModel(
      id: json['_id'] ?? '',
      doctorId: json['doctorId'] ?? '',
      admissionId: json['admissionId'] ?? '',

      patientId: patient['_id'] ?? '',
      patientName: patient['name'] ?? 'Unknown',
      patientAge: patient['age'] ?? 0,
      patientGender: patient['gender'] ?? '',
      patientAvatar: avatar['url'] ?? '',

      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      status: json['status'] ?? '',
      reason: json['reason'] ?? '',
      meetingLink: json['meetingLink'] ?? '',

      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),

      waitingTime: _formatWaiting(json['waiting']),
    );
  }

  // ================= TO JSON =================
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'doctorId': doctorId,
      'admissionId': admissionId,
      'patientId': patientId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'status': status,
      'reason': reason,
      'meetingLink': meetingLink,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // ================= COPY WITH =================
  TeleconsultationQueueModel copyWith({
    String? status,
    String? waitingTime,
  }) {
    return TeleconsultationQueueModel(
      id: id,
      doctorId: doctorId,
      admissionId: admissionId,
      patientId: patientId,
      patientName: patientName,
      patientAge: patientAge,
      patientGender: patientGender,
      patientAvatar: patientAvatar,
      startTime: startTime,
      endTime: endTime,
      status: status ?? this.status,
      reason: reason,
      meetingLink: meetingLink,
      createdAt: createdAt,
      updatedAt: updatedAt,
      waitingTime: waitingTime ?? this.waitingTime,
    );
  }

  // ================= HELPERS =================
  static String _formatWaiting(String? waiting) {
    if (waiting == null || waiting.isEmpty) return 'Waiting: --';

    return 'Waiting: $waiting';
  }
}
