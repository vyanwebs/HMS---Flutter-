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