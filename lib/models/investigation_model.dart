// class InvestigationModel {
//   final String id;
//   final String investigationType;
//   final String tags;
//   final DateTime scheduledDateAndTime;
//   final String insuranceStatus;
//   final String? doctorName;
//   final String priority;
//   final String reasonForInvestigation;
//   final String clinicalHistory;
//   final String investigationDetails;

//   InvestigationModel({
//     required this.id,
//     required this.investigationType,
//     required this.tags,
//     required this.scheduledDateAndTime,
//     required this.insuranceStatus,
//     this.doctorName,
//     required this.priority,
//     required this.reasonForInvestigation,
//     required this.clinicalHistory,
//     required this.investigationDetails,
//   });

//   factory InvestigationModel.fromJson(Map<String, dynamic> json) {
//     return InvestigationModel(
//       id: json['_id'] ?? '',
//       investigationType: json['investigationType'] ?? '',
//       tags: json['tags'] ?? '',
//       scheduledDateAndTime: DateTime.parse(json['scheduledDateAndTime'] ?? DateTime.now().toIso8601String()),
//       insuranceStatus: json['insuranceStatus'] ?? '',
//       doctorName: json['doctorMongoId']?['name'] ?? 'Unknown',
//       priority: json['priority'] ?? '',
//       reasonForInvestigation: json['reasonForInvestigation'] ?? '',
//       clinicalHistory: json['clinicalHistory'] ?? '',
//       investigationDetails: json['investigationDetails'] ?? '',
//     );
//   }
// }

// class InvestigationModel {
//   final String id;

//   /// Patient
//   final String? patientName;
//   final String? patientId;

//   /// Doctor
//   final String? doctorName;
//   final String? doctorId;

//   /// Investigation
//   final String investigationType;
//   final String priority;
//   final String reasonForInvestigation;
//   final String clinicalHistory;
//   final String investigationDetails;
//   final String tags;

//   /// Dates
//   final DateTime scheduledDateAndTime;
//   final DateTime? createdAt;

//   /// Billing
//   final String insuranceStatus;
//   final String? paymentStatus;
//   final bool insuranceCovered;

//   InvestigationModel({
//     required this.id,

//     this.patientName,
//     this.patientId,

//     this.doctorName,
//     this.doctorId,

//     required this.investigationType,
//     required this.priority,
//     required this.reasonForInvestigation,
//     required this.clinicalHistory,
//     required this.investigationDetails,
//     required this.tags,

//     required this.scheduledDateAndTime,
//     this.createdAt,

//     required this.insuranceStatus,
//     this.paymentStatus,
//     required this.insuranceCovered,
//   });

//   factory InvestigationModel.fromJson(Map<String, dynamic> json) {
//     return InvestigationModel(
//       id: json['_id'] ?? '',

//       /// Patient
//       patientName: json['patientMongoId']?['name'],
//       patientId: json['patientId'],

//       /// Doctor
//       doctorName: json['doctorMongoId']?['name'],
//       doctorId: json['doctorMongoId']?['_id'],

//       /// Investigation
//       investigationType: json['investigationType'] ?? '',
//       priority: json['priority'] ?? '',
//       reasonForInvestigation: json['reasonForInvestigation'] ?? '',
//       clinicalHistory: json['clinicalHistory'] ?? '',
//       investigationDetails: json['investigationDetails'] ?? '',
//       tags: json['tags'] ?? '',

//       /// Dates
//       scheduledDateAndTime: DateTime.parse(
//         json['scheduledDateAndTime'] ??
//             DateTime.now().toIso8601String(),
//       ),

//       createdAt: json['createdAt'] != null
//           ? DateTime.parse(json['createdAt'])
//           : null,

//       /// Billing
//       insuranceStatus: json['insuranceStatus'] ?? '',
//       paymentStatus: json['paymentStatus'],
//       insuranceCovered: json['insuranceCovered'] ?? false,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       "investigationType": investigationType,
//       "priority": priority,
//       "scheduledDateAndTime":
//           scheduledDateAndTime.toIso8601String(),
//       "reasonForInvestigation": reasonForInvestigation,
//       "clinicalHistory": clinicalHistory,
//       "investigationDetails": investigationDetails,
//       "tags": tags,
//       "insuranceStatus": insuranceStatus,
//       "paymentStatus": paymentStatus,
//       "insuranceCovered": insuranceCovered,
//     };
//   }
// }


// class InvestigationModel {
//   final String id;

//   /// Patient
//   final String? patientName;
//   final String? patientId;
//   final String? patientMongoId; // ADD THIS - useful for references

//   /// Doctor
//   final String? doctorName;
//   final String? doctorId;
//   final String? doctorMongoId; // ADD THIS - useful for references

//   /// Investigation
//   final String investigationType;
//   final String priority;
//   final String reasonForInvestigation;
//   final String clinicalHistory;
//   final String investigationDetails;
//   final String tags;

//   /// Dates
//   final DateTime scheduledDateAndTime;
//   final DateTime? createdAt;
//   final DateTime? updatedAt; // ADD THIS - from your JSON

//   /// Billing
//   final String insuranceStatus;
//   final String? paymentStatus;
//   final bool insuranceCovered;

//   /// Recorded By (from your JSON)
//   final Map<String, dynamic>? recordedBy; // ADD THIS - for recordedBy field
//   final String? recordedById; // ADD THIS - convenience field
//   final String? recordedByRole; // ADD THIS - convenience field
//   final String? recordedByStaffId; // ADD THIS - convenience field

//   InvestigationModel({
//     required this.id,

//     // Patient
//     this.patientName,
//     this.patientId,
//     this.patientMongoId,

//     // Doctor
//     this.doctorName,
//     this.doctorId,
//     this.doctorMongoId,

//     // Investigation
//     required this.investigationType,
//     required this.priority,
//     required this.reasonForInvestigation,
//     required this.clinicalHistory,
//     required this.investigationDetails,
//     required this.tags,

//     // Dates
//     required this.scheduledDateAndTime,
//     this.createdAt,
//     this.updatedAt,

//     // Billing
//     required this.insuranceStatus,
//     this.paymentStatus,
//     required this.insuranceCovered,

//     // Recorded By
//     this.recordedBy,
//     this.recordedById,
//     this.recordedByRole,
//     this.recordedByStaffId,
//   });

//   factory InvestigationModel.fromJson(Map<String, dynamic> json) {
//     // Extract recordedBy data if available
//     final recordedByData = json['recordedBy'] as Map<String, dynamic>?;
    
//     return InvestigationModel(
//       id: json['_id'] ?? '',

//       /// Patient
//       patientName: json['patientMongoId']?['name'],
//       patientId: json['patientId'],
//       patientMongoId: json['patientMongoId']?['_id'] ?? json['patientMongoId'],

//       /// Doctor
//       doctorName: json['doctorMongoId']?['name'],
//       doctorId: json['doctorMongoId']?['_id'],
//       doctorMongoId: json['doctorMongoId']?['_id'] ?? json['doctorMongoId'],

//       /// Investigation
//       investigationType: json['investigationType'] ?? '',
//       priority: json['priority'] ?? '',
//       reasonForInvestigation: json['reasonForInvestigation'] ?? '',
//       clinicalHistory: json['clinicalHistory'] ?? '',
//       investigationDetails: json['investigationDetails'] ?? '',
//       tags: json['tags'] ?? '',

//       /// Dates
//       scheduledDateAndTime: DateTime.parse(
//         json['scheduledDateAndTime'] ??
//             DateTime.now().toIso8601String(),
//       ),
//       createdAt: json['createdAt'] != null
//           ? DateTime.parse(json['createdAt'])
//           : null,
//       updatedAt: json['updatedAt'] != null
//           ? DateTime.parse(json['updatedAt'])
//           : null,

//       /// Billing
//       insuranceStatus: json['insuranceStatus'] ?? '',
//       paymentStatus: json['paymentStatus'],
//       insuranceCovered: json['insuranceCovered'] ?? false,

//       /// Recorded By
//       recordedBy: recordedByData,
//       recordedById: recordedByData?['id'],
//       recordedByRole: recordedByData?['role'],
//       recordedByStaffId: recordedByData?['staffId'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       "investigationType": investigationType,
//       "priority": priority,
//       "scheduledDateAndTime": scheduledDateAndTime.toIso8601String(),
//       "reasonForInvestigation": reasonForInvestigation,
//       "clinicalHistory": clinicalHistory,
//       "investigationDetails": investigationDetails,
//       "tags": tags,
//       "insuranceStatus": insuranceStatus,
//       "paymentStatus": paymentStatus,
//       "insuranceCovered": insuranceCovered,
//     };
//   }

//   /// Helper method to check if investigation is pending
//   bool get isPending => paymentStatus?.toLowerCase() == 'pending';
  
//   /// Helper method to check if investigation is completed
//   bool get isCompleted => paymentStatus?.toLowerCase() == 'completed';
  
//   /// Helper method to get formatted date
//   String get formattedScheduledDate {
//     // Add your date formatting logic here
//     return '${scheduledDateAndTime.day}/${scheduledDateAndTime.month}/${scheduledDateAndTime.year}';
//   }
// }


class InvestigationModel {
  final String id;
  final String? patientName;
  final String? patientId;
  final String? patientMongoId;
  final String? doctorName;
  final String? doctorMongoId;
  final String investigationType;
  final String priority;
  final String reasonForInvestigation;
  final String clinicalHistory;
  final String investigationDetails;
  final String tags;
  final DateTime scheduledDateAndTime;
  final String insuranceStatus;
  final String? paymentStatus;
  final bool insuranceCovered;

  InvestigationModel({
    required this.id,
    this.patientName,
    this.patientId,
    this.patientMongoId,
    this.doctorName,
    this.doctorMongoId,
    required this.investigationType,
    required this.priority,
    required this.reasonForInvestigation,
    required this.clinicalHistory,
    required this.investigationDetails,
    required this.tags,
    required this.scheduledDateAndTime,
    required this.insuranceStatus,
    this.paymentStatus,
    required this.insuranceCovered,
  });

  factory InvestigationModel.fromJson(Map<String, dynamic> json) {
    String? parseId(dynamic field) {
      if (field is Map) return field['_id']?.toString();
      return field?.toString();
    }

    return InvestigationModel(
      id: json['_id'] ?? '',
      patientName: json['patientMongoId'] is Map ? json['patientMongoId']['name'] : null,
      patientId: json['patientId']?.toString(),
      patientMongoId: parseId(json['patientMongoId']),
      doctorName: json['doctorMongoId'] is Map ? json['doctorMongoId']['name'] : null,
      doctorMongoId: parseId(json['doctorMongoId']),
      investigationType: json['investigationType'] ?? '',
      priority: json['priority'] ?? '',
      reasonForInvestigation: json['reasonForInvestigation'] ?? '',
      clinicalHistory: json['clinicalHistory'] ?? '',
      investigationDetails: json['investigationDetails'] ?? '',
      tags: json['tags'] ?? '',
      scheduledDateAndTime: json['scheduledDateAndTime'] != null
          ? DateTime.parse(json['scheduledDateAndTime']).toLocal()
          : DateTime.now(),
      insuranceStatus: json['insuranceStatus'] ?? 'Pending',
      paymentStatus: json['paymentStatus'] ?? 'Pending',
      insuranceCovered: json['insuranceCovered'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "patientMongoId": patientMongoId,
      "patientId": patientId,
      "doctorMongoId": doctorMongoId,
      "investigationType": investigationType,
      "priority": priority,
      // Send local ISO string with offset (matches Postman example)
      "scheduledDateAndTime": scheduledDateAndTime.toUtc().toIso8601String(),
      "reasonForInvestigation": reasonForInvestigation,
      "clinicalHistory": clinicalHistory,
      "investigationDetails": investigationDetails,
      "tags": tags,
      "insuranceStatus": insuranceStatus,
      "paymentStatus": paymentStatus,
      "insuranceCovered": insuranceCovered,
    };
  }
}