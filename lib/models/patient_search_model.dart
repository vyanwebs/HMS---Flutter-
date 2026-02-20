import 'avatar_model.dart';

class PatientSearchModel {

  /// BASIC
  final String id;
  final String patientId;
  final String name;
  final int age;
  final String gender;
  final String mobile;

  /// PERSONAL
  final String? email;
  final String? address;
  final String? guardianName;
  final String? maritalStatus;
  final String? occupation;
  final String? education;
  final String? bloodGroup;
  final String? nationality;
  final String? language;

  /// ADMISSION
  final String admissionType;
  final String admissionStatus;
  final String? admissionCode;
  final String? admissionId;

  /// HEALTH
  final String? healthCondition;
  final String? admissionReason;
  final int? weight;

  /// EXTRA
  final PatientAvatarModel avatar;
  final int visitCount;
  final bool isTodayConfirmed;

  /// WARD
  final String? wardType;
  final String? bedAssign;

  /// NURSE
  final String? nurseName;
  final String? nurseId;

  /// META
  final String? patientType;

  PatientSearchModel({
    required this.id,
    required this.patientId,
    required this.name,
    required this.age,
    required this.gender,
    required this.mobile,
    required this.admissionType,
    required this.admissionStatus,
    this.email,
    this.address,
    this.guardianName,
    this.maritalStatus,
    this.occupation,
    this.education,
    this.bloodGroup,
    this.nationality,
    this.language,
    this.admissionCode,
    this.admissionId,
    this.healthCondition,
    this.admissionReason,
    this.weight,
    required this.avatar,
    required this.visitCount,
    required this.isTodayConfirmed,
    this.wardType,
    this.bedAssign,
    this.nurseName,
    this.nurseId,
    this.patientType,
  });

  // ==========================================================
  // SAFE PARSER
  // ==========================================================

  factory PatientSearchModel.fromJson(Map<String, dynamic> json) {
    return PatientSearchModel(
      id: json["_id"] ?? "",
      patientId: json["patientId"] ?? "",

      name: (json["name"] ?? "").toString().trim(),

      age: _parseInt(json["age"]),
      gender: json["gender"] ?? "",
      mobile: json["mobileNumber"] ?? "",

      email: json["email"],
      address: json["address"],
      guardianName: json["guardianName"],
      maritalStatus: json["maritalStatus"],
      occupation: json["occupation"],
      education: json["education"],
      bloodGroup: json["bloodGroup"],
      nationality: json["nationality"],
      language: json["language"],

      admissionType: json["currentAdmissionType"] ?? "",
      admissionStatus: json["currentAdmissionStatus"] ?? "",

      admissionCode: json["currentAdmissionCode"]?.toString(),
      admissionId: json["currentAdmissionId"],

      healthCondition: json["currentHealthCondition"],
      admissionReason: json["admissionReason"],

      weight: _parseNullableInt(json["weight"]),

      avatar: json["avatar"] != null
        ? PatientAvatarModel.fromJson(json["avatar"])
        : PatientAvatarModel.empty(),

      visitCount: _parseInt(json["visitCount"]),
      isTodayConfirmed: json["isTodayConfirmed"] ?? false,

      wardType: json["currentWardType"],
      bedAssign: json["currentBedAssign"],

      nurseName: json["currentNurseAssign"]?["name"],
      nurseId: json["currentNurseAssign"]?["id"],

      patientType: json["patientType"],
    );
  }

  // ==========================================================
  // HELPERS (VERY IMPORTANT)
  // ==========================================================

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }

  static int? _parseNullableInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }
}
