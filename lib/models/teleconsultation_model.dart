class TeleconsultationModel {
  final String id;
  final String patientName;
  final int patientAge;
  final DateTime startTime;
  final DateTime endTime;
  final String status;
  final String meetingLink;

  TeleconsultationModel({
    required this.id,
    required this.patientName,
    required this.patientAge,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.meetingLink,
  });

  factory TeleconsultationModel.fromJson(Map<String, dynamic> json) {
    final patient = json['patientId'] ?? {};

    return TeleconsultationModel(
      id: json['_id'],
      patientName: patient['name'] ?? 'Unknown',
      patientAge: patient['age'] ?? 0,
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      status: json['status'],
      meetingLink: (json['meetingLink'] ?? '').toString().trim(),
    );
  }
}
