// import 'avatar_model.dart';

// class RecentPatientModel {
//   // ===== CORE IDENTIFIERS =====
//   final String id;
//   final String patientId;
//   final String name;
//   final String email;
//   final String role;

//   // ===== PERSONAL INFO =====
//   final int age;
//   final String gender;
//   final String mobileNumber;
//   final String address;
//   final String guardianName;
//   final String maritalStatus;
//   final String occupation;
//   final String education;
//   final String bloodGroup;
//   final String nationality;
//   final String language;

//   // ===== ADMISSION INFO =====
//   final String currentAdmissionType; // OPD / IPD
//   final String currentAdmissionStatus; // PENDING / DISCHARGE_REQUESTED
//   final String? currentHealthCondition;
//   final String? admissionReason;
//   final String? currentAdmissionId;
//   final String? currentAdmissionCode;

//   // ===== META =====
//   final int visitCount;
//   final bool isTodayConfirmed;
//   final String registeredBy;
//   final String registeredByStaffId;

//   // ===== DATES =====
//   final DateTime registeredAt;
//   final DateTime createdAt;
//   final DateTime updatedAt;

//   // ===== UI FIELDS =====
//   final AvatarModel? avatar;
//   final String timeAgo;

//   RecentPatientModel({
//     required this.id,
//     required this.patientId,
//     required this.name,
//     required this.email,
//     required this.role,
//     required this.age,
//     required this.gender,
//     required this.mobileNumber,
//     required this.address,
//     required this.guardianName,
//     required this.maritalStatus,
//     required this.occupation,
//     required this.education,
//     required this.bloodGroup,
//     required this.nationality,
//     required this.language,
//     required this.currentAdmissionType,
//     required this.currentAdmissionStatus,
//     required this.currentHealthCondition,
//     required this.admissionReason,
//     required this.currentAdmissionId,
//     required this.currentAdmissionCode,
//     required this.visitCount,
//     required this.isTodayConfirmed,
//     required this.registeredBy,
//     required this.registeredByStaffId,
//     required this.registeredAt,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.avatar,
//     required this.timeAgo,
//   });

//   // ================= FACTORY =================

//   factory RecentPatientModel.fromJson(Map<String, dynamic> json) {
//     return RecentPatientModel(
//       id: json['_id'] ?? '',
//       patientId: json['patientId'] ?? '',
//       name: json['name'] ?? 'Unknown',
//       email: json['email'] ?? '',
//       role: json['role'] ?? 'patient',

//       age: json['age'] ?? 0,
//       gender: json['gender'] ?? '',
//       mobileNumber: json['mobileNumber'] ?? '',
//       address: json['address'] ?? '',
//       guardianName: json['guardianName'] ?? '',
//       maritalStatus: json['maritalStatus'] ?? '',
//       occupation: json['occupation'] ?? '',
//       education: json['education'] ?? '',
//       bloodGroup: json['bloodGroup'] ?? '',
//       nationality: json['nationality'] ?? '',
//       language: json['language'] ?? '',

//       currentAdmissionType: json['currentAdmissionType'] ?? '',
//       currentAdmissionStatus: json['currentAdmissionStatus'] ?? '',
//       currentHealthCondition: json['currentHealthCondition'],
//       admissionReason: json['admissionReason'] ?? "",
//       currentAdmissionId: json['currentAdmissionId'],
//       currentAdmissionCode: json['currentAdmissionCode'],

//       visitCount: json['visitCount'] ?? 0,
//       isTodayConfirmed: json['isTodayConfirmed'] ?? false,
//       registeredBy: json['registeredBy'] ?? '',
//       registeredByStaffId: json['registeredByStaffId'] ?? '',

//       registeredAt: DateTime.tryParse(json['registeredAt'] ?? '') ?? DateTime.now(),
//       createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
//       updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),

//       avatar: json['avatar'] != null
//         ? AvatarModel.fromJson(json['avatar'])
//         : null,
//       timeAgo: json["timeAgo"] ?? "N/A",
//     );
//   }

//   // ================= UI HELPERS =================

//   String get displayStatus {
//     switch (currentAdmissionStatus.toUpperCase()) {
//       case 'PENDING':
//         return 'Pending';
//       case 'DISCHARGE_REQUESTED':
//         return 'Discharge Requested';
//       case 'ADMITTED':
//         return 'Admitted';
//       default:
//         return 'Stable';
//     }
//   }

//   // String get timeAgo {
//   //   final diff = DateTime.now().difference(updatedAt);

//   //   if (diff.inMinutes < 60) {
//   //     return '${diff.inMinutes} min ago';
//   //   } else if (diff.inHours < 24) {
//   //     return '${diff.inHours} hrs ago';
//   //   } else {
//   //     return '${diff.inDays} days ago';
//   //   }
//   // }

//   String get initials => name.isNotEmpty ? name[0].toUpperCase() : '?';

//   bool get isIPD => currentAdmissionType == 'IPD';
//   bool get isOPD => currentAdmissionType == 'OPD';

//   bool get isCritical =>
//       (currentHealthCondition ?? '').toLowerCase().contains('serious');
// }
