class DoctorModel {
  final String id;
  final String name;
  final String specialty;
  final String department;
  final String avatarUrl;
  final bool isAvailableToday;

  DoctorModel({
    required this.id,
    required this.name,
    required this.specialty,
    required this.department,
    required this.avatarUrl,
    required this.isAvailableToday,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      specialty: json['specialty'] ?? 'General',
      department: json['department'] ?? '',
      avatarUrl: json['avatar']?['googleDriveLink'] ?? '',
      isAvailableToday: json['isAvailableToday'] ?? false,
    );
  }
}

class AppointmentModel {
  final String id;
  final String patientName;
  final String patientId;
  final String mobileNumber;
  final String symptoms;
  final String status;
  final String appointmentType;
  final DateTime scheduledDate;

  AppointmentModel({
    required this.id,
    required this.patientName,
    required this.patientId,
    required this.mobileNumber,
    required this.symptoms,
    required this.status,
    required this.appointmentType,
    required this.scheduledDate,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['_id'] ?? '',
      patientName: json['patientName'] ?? (json['patientMongoId']?['name'] ?? 'N/A'),
      patientId: json['patientId'] ?? (json['patientMongoId']?['patientId'] ?? 'N/A'),
      mobileNumber: json['mobileNumber'] ?? (json['patientMongoId']?['mobileNumber'] ?? ''),
      symptoms: json['symptoms'] ?? json['reason'] ?? 'No symptoms reported',
      status: json['appointmentStatus'] ?? 'PENDING',
      appointmentType: json['appointmentType'] ?? 'IN_PERSON',
      scheduledDate: DateTime.parse(json['scheduledDateAndTime'] ?? json['createdAt']),
    );
  }
}