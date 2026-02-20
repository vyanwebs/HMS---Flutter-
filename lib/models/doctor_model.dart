import 'avatar_model.dart';

class DoctorModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String staffId;

  final bool isAvailableToday;

  /// Extra info
  final String doctorType;
  final String specialty;
  final String experience;
  final String department;
  final bool hasLeftHospital;
  final String staffStatus;

  final PatientAvatarModel avatar;

  DoctorModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.staffId,
    required this.isAvailableToday,
    required this.doctorType,
    required this.specialty,
    required this.experience,
    required this.department,
    required this.hasLeftHospital,
    required this.staffStatus,
    required this.avatar,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      phone: json["phone"] ?? "",
      staffId: json["staffId"] ?? "",
      isAvailableToday: json["isAvailableToday"] ?? false,

      doctorType: json["doctorType"] ?? "",
      specialty: json["specialty"] ?? "",
      experience: json["experience"] ?? "",
      department: json["department"] ?? "",
      hasLeftHospital: json["hasLeftHospital"] ?? false,
      staffStatus: json["staffStatus"] ?? "",

      avatar: json["avatar"] != null
          ? PatientAvatarModel.fromJson(json["avatar"])
          : PatientAvatarModel.empty(),
    );
  }
}