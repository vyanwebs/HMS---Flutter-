// class PatientRowModel {
//   final String id;
//   final String name;
//   final String patientId;
//   final String ageGender;
//   final String contact;
//   final String type;
//   final String status;
//   final int visit;

//   PatientRowModel({
//     required this.id,
//     required this.name,
//     required this.patientId,
//     required this.ageGender,
//     required this.contact,
//     required this.type,
//     required this.status,
//     required this.visit,
//   });

//   factory PatientRowModel.fromJson(Map<String, dynamic> json) {
//     return PatientRowModel(
//       id: json['_id'] ?? '',
//       name: json['name'] ?? '',
//       patientId: json['patientId'] ?? '',
//       ageGender: json['ageGender'] ?? '',
//       contact: json['contact'] ?? '',
//       type: json['type'] ?? '',
//       status: json['status'] ?? '',
//       visit: json['visit'] ?? 0,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'name': name,
//       'patientId': patientId,
//       'ageGender': ageGender,
//       'contact': contact,
//       'type': type,
//       'status': status,
//       'visit': visit,
//     };
//   }
// }


class PatientRowModel {
  final String id;
  final String name;
  final String patientId;
  final String ageGender;
  final String address;
  final String contact;
  final String type;
  final String status;
  final int visit;

  PatientRowModel({
    required this.id,
    required this.name,
    required this.patientId,
    required this.ageGender,
    required this.contact,
    required this.address,
    required this.type,
    required this.status,
    required this.visit,
  });

  factory PatientRowModel.fromJson(Map<String, dynamic> json) {
    return PatientRowModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      patientId: json['patientId'] ?? '',
      // Combining Gender and Age from separate fields in API
      ageGender: "${json['gender'] ?? 'N/A'}/${json['age'] ?? '0'}",
      address: json['address'] ?? 'N/A',
      contact: json['mobileNumber'] ?? '',
      type: json['currentAdmissionType'] ?? '',
      status: json['currentAdmissionStatus'] ?? '',
      visit: json['visitCount'] ?? 0,
    );
  }
}