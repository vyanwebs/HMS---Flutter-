class LabTestRequestModel {
  final String id;

  // Patient Info
  final String patientMongoId;
  final String patientName;
  final String patientId;
  final int age;
  final String bloodGroup;
  final String bloodPressure;
  final String sugar;

  // Test Info
  final String testName;
  final String testCategory;
  final String priority;
  final String status;
  final String additionalRequest;

  // Metadata
  final DateTime createdAt;
  final DateTime? updatedAt;

  LabTestRequestModel({
    required this.id,
    required this.patientMongoId,
    required this.patientName,
    required this.patientId,
    required this.age,
    required this.bloodGroup,
    required this.bloodPressure,
    required this.sugar,
    required this.testName,
    required this.testCategory,
    required this.priority,
    required this.status,
    required this.additionalRequest,
    required this.createdAt,
    this.updatedAt,
  });

  factory LabTestRequestModel.fromJson(Map<String, dynamic> json) {
    return LabTestRequestModel(
      id: json['_id'] ?? '',
      patientMongoId: json['patientMongoId'] ?? '',
      patientName: json['patientName'] ?? '',
      patientId: json['patientId'] ?? '',
      age: json['age'] ?? 0,
      bloodGroup: json['bloodGroup'] ?? '',
      bloodPressure: json['bloodPressure'] ?? '',
      sugar: json['sugar'] ?? '',
      testName: json['testName'] ?? '',
      testCategory: json['testCategory'] ?? '',
      priority: json['priority'] ?? '',
      status: json['status'] ?? '',
      additionalRequest: json['additionalRequest'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "patientMongoId": patientMongoId,
      "patientName": patientName,
      "patientId": patientId,
      "age": age,
      "bloodGroup": bloodGroup,
      "bloodPressure": bloodPressure,
      "sugar": sugar,
      "testName": testName,
      "testCategory": testCategory,
      "priority": priority,
      "status": status,
      "additionalRequest": additionalRequest,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
    };
  }
}
