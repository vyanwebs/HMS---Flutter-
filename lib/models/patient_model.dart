import 'avatar_model.dart';
import 'patient_vitals_model.dart';

class PatientModel {
  // Core IDs
  final String id;
  final String patientId;

  // Personal details
  final String name;
  final int age;
  final String gender;
  final String email;
  final String mobileNumber;
  final String address;
  final String guardianName;
  final String maritalStatus;
  final String occupation;
  final String education;
  final String bloodGroup;
  final String nationality;
  final String language;
  final int weight;

  // Admission details
  final String currentAdmissionType;
  final String currentAdmissionStatus;
  final String currentDoctorAssigned;
  final String currentHealthCondition;
  final String admissionReason;
  final bool isTodayConfirmed;
  final int visitCount;

  // Dates
  final DateTime updatedAt;
  final DateTime registeredAt;

  // UI-only fields (not from API)
  final String image;

  final String timeAgo;

  final String role;
  final String registeredBy;
  final String registeredByStaffId;
  final List<String> admissionIds;

  final int currentAdmissionCode;
  final String currentAdmissionId;

  final String currentBedAssign;
  final String roomNumber;
  final String bedNumber;

  final PatientAvatarModel? avatar;
  final PatientVitalsModel? currentVitalsReport;

  final String currentWardType;
  final String initialVitalStatus;
  final Map<String, dynamic>? currentNurseAssign;

  final String patientType;
  final int ipdDepositAmount;
  final int currentIPDCode;
  final DateTime? createdAt;
  final String admissionInstructions;
  final String currentBill;

  PatientModel({
    required this.id,
    required this.patientId,
    required this.name,
    required this.age,
    required this.gender,
    required this.email,
    required this.mobileNumber,
    required this.address,
    required this.guardianName,
    required this.maritalStatus,
    required this.occupation,
    required this.education,
    required this.bloodGroup,
    required this.nationality,
    required this.language,
    required this.weight,
    required this.currentAdmissionType,
    required this.currentAdmissionStatus,
    required this.currentDoctorAssigned,
    required this.currentHealthCondition,
    required this.admissionReason,
    required this.isTodayConfirmed,
    required this.visitCount,
    required this.updatedAt,
    required this.registeredAt,
    required this.image,
    required this.timeAgo,

    required this.role,
    required this.registeredBy,
    required this.registeredByStaffId,
    required this.admissionIds,
    required this.currentAdmissionCode,
    required this.currentAdmissionId,
    required this.currentBedAssign,
    required this.roomNumber,
    required this.bedNumber,
    required this.avatar,
    required this.currentVitalsReport,

    required this.currentWardType,
    required this.initialVitalStatus,
    this.currentNurseAssign,

    required this.patientType,
    required this.ipdDepositAmount,
    required this.currentIPDCode,
    this.createdAt,
    required this.admissionInstructions,
    required this.currentBill,

  });

  // ================= FROM JSON =================
  factory PatientModel.fromJson(Map<String, dynamic> json) {
    final updated = DateTime.parse(json['updatedAt']);
    return PatientModel(
      id: json['_id'] ?? '',
      patientId: json['patientId'] ?? '',

      name: json['name'] ?? '',
      age: json['age'] ?? 0,
      gender: json['gender'] ?? '',
      email: json['email'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      address: json['address'] ?? '',
      guardianName: json['guardianName'] ?? '',
      maritalStatus: json['maritalStatus'] ?? '',
      occupation: json['occupation'] ?? '',
      education: json['education'] ?? '',
      bloodGroup: json['bloodGroup'] ?? '',
      nationality: json['nationality'] ?? '',
      language: json['language'] ?? '',
      weight: json['weight'] ?? 0,

      currentAdmissionType: json['currentAdmissionType'] ?? '',
      currentAdmissionStatus: json['currentAdmissionStatus'] ?? '',
      currentDoctorAssigned: json['currentDoctorAssigned'] ?? '',
      currentHealthCondition: json['currentHealthCondition'] ?? '',
      admissionReason: json['admissionReason'] ?? '',
      isTodayConfirmed: json['isTodayConfirmed'] ?? false,
      visitCount: json['visitCount'] ?? 0,

      updatedAt: updated,
      registeredAt: DateTime.parse(json['registeredAt']),

      image: '', // UI fallback (set later)
      timeAgo: json['timeAgo'] ?? _timeAgo(updated),

      role: json['role'] ?? '',
      registeredBy: json['registeredBy'] ?? '',
      registeredByStaffId: json['registeredByStaffId'] ?? '',
      admissionIds: List<String>.from(json['admissionIds'] ?? []),
      currentAdmissionCode: json['currentAdmissionCode'] ?? 0,
      currentAdmissionId: json['currentAdmissionId'] ?? '',
      currentBedAssign: json['currentBedAssign'] ?? '',
      roomNumber: json['roomNumber'] ?? '',
      bedNumber: json['bedNumber'] ?? '',
      avatar: json['avatar'] is Map<String, dynamic>
        ? PatientAvatarModel.fromJson(json['avatar'])
        : null,

      // avatar: json['avatar'] != null
      //   ? PatientAvatarModel.fromJson(json['avatar'])
      //   : PatientAvatarModel.empty(),
      currentVitalsReport: json['currentVitalsReport'] is Map<String, dynamic>
        ? PatientVitalsModel.fromJson(json['currentVitalsReport'])
        : null,

      // currentVitalsReport: json['currentVitalsReport'] != null
      //   ? PatientVitalsModel.fromJson(json['currentVitalsReport'])
      //   : PatientVitalsModel.empty(),

      currentWardType: json['currentWardType'] ?? '',
      initialVitalStatus: json['initialVitalStatus'] ?? '',
      currentNurseAssign: json['currentNurseAssign'] is Map<String, dynamic>
        ? json['currentNurseAssign']
        : null,

      patientType: json['patientType'] ?? '',
      ipdDepositAmount: int.tryParse(json['ipdDepositAmount']?.toString() ?? '') ?? 0,
      currentIPDCode: int.tryParse(json['currentIPDCode']?.toString() ?? '') ?? 0,
      admissionInstructions: json['admissionInstructions'] ?? '',
      currentBill: json['currentBill']?.toString() ?? '',

    );
  }

  // ================= TO JSON =================
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'patientId': patientId,
      'name': name,
      'age': age,
      'gender': gender,
      'email': email,
      'mobileNumber': mobileNumber,
      'address': address,
      'guardianName': guardianName,
      'maritalStatus': maritalStatus,
      'occupation': occupation,
      'education': education,
      'bloodGroup': bloodGroup,
      'nationality': nationality,
      'language': language,
      'weight': weight,
      'currentAdmissionType': currentAdmissionType,
      'currentAdmissionStatus': currentAdmissionStatus,
      'currentDoctorAssigned': currentDoctorAssigned,
      'currentHealthCondition': currentHealthCondition,
      'admissionReason': admissionReason,
      'isTodayConfirmed': isTodayConfirmed,
      'visitCount': visitCount,
      'updatedAt': updatedAt.toIso8601String(),
      'registeredAt': registeredAt.toIso8601String(),
      'role': role,
      'registeredBy': registeredBy,
      'registeredByStaffId': registeredByStaffId,
      'admissionIds': admissionIds,
      'currentAdmissionCode': currentAdmissionCode,
      'currentAdmissionId': currentAdmissionId,
      'currentBedAssign': currentBedAssign,
      'roomNumber': roomNumber,
      'bedNumber': bedNumber,
      'avatar': avatar?.toJson(),
      'currentVitalsReport': currentVitalsReport?.toJson(),

      'patientType': patientType,
      'ipdDepositAmount': ipdDepositAmount,
      'currentIPDCode': currentIPDCode,
      'createdAt': createdAt?.toIso8601String(),
      'admissionInstructions': admissionInstructions,
      'currentBill': currentBill,

    };
  }

  PatientModel copyWith({
    String? id,
    String? patientId,
    String? name,
    int? age,
    String? gender,
    String? email,
    String? mobileNumber,
    String? address,
    String? guardianName,
    String? maritalStatus,
    String? occupation,
    String? education,
    String? bloodGroup,
    String? nationality,
    String? language,
    int? weight,
    String? currentAdmissionType,
    String? currentAdmissionStatus,
    String? currentDoctorAssigned,
    String? currentHealthCondition,
    String? admissionReason,
    bool? isTodayConfirmed,
    int? visitCount,
    DateTime? updatedAt,
    DateTime? registeredAt,
    String? image,
    String? timeAgo,

    String? role,
    String? registeredBy,
    String? registeredByStaffId,
    List<String>? admissionIds,
    int? currentAdmissionCode,
    String? currentAdmissionId,
    String? currentBedAssign,
    String? roomNumber,
    String? bedNumber,
    PatientAvatarModel? avatar,
    PatientVitalsModel? currentVitalsReport,
  }) {
    return PatientModel(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      email: email ?? this.email,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      address: address ?? this.address,
      guardianName: guardianName ?? this.guardianName,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      occupation: occupation ?? this.occupation,
      education: education ?? this.education,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      nationality: nationality ?? this.nationality,
      language: language ?? this.language,
      weight: weight ?? this.weight,
      currentAdmissionType: currentAdmissionType ?? this.currentAdmissionType,
      currentAdmissionStatus: currentAdmissionStatus ?? this.currentAdmissionStatus,
      currentDoctorAssigned: currentDoctorAssigned ?? this.currentDoctorAssigned,
      currentHealthCondition: currentHealthCondition ?? this.currentHealthCondition,
      admissionReason: admissionReason ?? this.admissionReason,
      isTodayConfirmed: isTodayConfirmed ?? this.isTodayConfirmed,
      visitCount: visitCount ?? this.visitCount,
      updatedAt: updatedAt ?? this.updatedAt,
      registeredAt: registeredAt ?? this.registeredAt,
      image: image ?? this.image,
      timeAgo: timeAgo ?? this.timeAgo,

      role: role ?? this.role,
      registeredBy: registeredBy ?? this.registeredBy,
      registeredByStaffId: registeredByStaffId ?? this.registeredByStaffId,
      admissionIds: admissionIds ?? this.admissionIds,
      currentAdmissionCode: currentAdmissionCode ?? this.currentAdmissionCode,
      currentAdmissionId: currentAdmissionId ?? this.currentAdmissionId,
      currentBedAssign: currentBedAssign ?? this.currentBedAssign,
      roomNumber: roomNumber ?? this.roomNumber,
      bedNumber: bedNumber ?? this.bedNumber,
      avatar: avatar ?? this.avatar,
      currentVitalsReport: currentVitalsReport ?? this.currentVitalsReport,
      currentWardType: '',
      initialVitalStatus: '',
      admissionInstructions: '',
      patientType: '',
      ipdDepositAmount: ipdDepositAmount,
      currentIPDCode: currentIPDCode,
      currentBill: ''
    );
  }

  // ================= TIME AGO HELPER =================
  static String _timeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hr ago';
    if (diff.inDays == 1) return '1 day ago';

    return '${diff.inDays} days ago';
  }

  String get initials => name.isNotEmpty ? name[0].toUpperCase() : '?';
}
