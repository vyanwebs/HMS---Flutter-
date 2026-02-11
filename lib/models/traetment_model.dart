class TreatmentMedicationModel {
  final String id;
  final String patientMongoId;
  final String patientId;
  final String doctorMongoId;
  final String doctorId;

  final String medicationName;
  final String medicationType;
  final String mealRelation;
  final String status;

  final MedicationDosage dosage;

  final DateTime createdAt;
  final DateTime updatedAt;

  TreatmentMedicationModel({
    required this.id,
    required this.patientMongoId,
    required this.patientId,
    required this.doctorMongoId,
    required this.doctorId,
    required this.medicationName,
    required this.medicationType,
    required this.mealRelation,
    required this.status,
    required this.dosage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TreatmentMedicationModel.fromJson(Map<String, dynamic> json) {
    return TreatmentMedicationModel(
      id: json['_id'] ?? '',
      patientMongoId: json['patientMongoId'] ?? '',
      patientId: json['patientId'] ?? '',
      doctorMongoId: json['doctorMongoId'] ?? '',
      doctorId: json['doctorId'] ?? '',
      medicationName: json['medicationName'] ?? '',
      medicationType: json['medicationType'] ?? '',
      mealRelation: json['mealRelation'] ?? '',
      status: json['status'] ?? '',
      dosage: MedicationDosage.fromJson(json['dosages'] ?? {}),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class MedicationDosage {
  final String timeOfDay;

  MedicationDosage({
    required this.timeOfDay,
  });

  factory MedicationDosage.fromJson(Map<String, dynamic> json) {
    return MedicationDosage(
      timeOfDay: json['timeOfDay'] ?? '',
    );
  }
}

class IvFluidTreatmentModel {
  final String id;
  final String ivFluidName;
  final String quantity;
  final String duration;
  final String status;
  final DateTime createdAt;

  IvFluidTreatmentModel({
    required this.id,
    required this.ivFluidName,
    required this.quantity,
    required this.duration,
    required this.status,
    required this.createdAt,
  });

  factory IvFluidTreatmentModel.fromJson(Map<String, dynamic> json) {
    return IvFluidTreatmentModel(
      id: json['_id'],
      ivFluidName: json['ivFluidName'],
      quantity: json['quantity'],
      duration: json['duration'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class ProcedureTreatmentModel {
  final String id;
  final String patientMongoId;
  final String procedure;
  final String frequency;
  final String status;
  final DateTime createdAt;

  ProcedureTreatmentModel({
    required this.id,
    required this.patientMongoId,
    required this.procedure,
    required this.frequency,
    required this.status,
    required this.createdAt,
  });

  factory ProcedureTreatmentModel.fromJson(Map<String, dynamic> json) {
    return ProcedureTreatmentModel(
      id: json['_id'],
      patientMongoId: json['patientMongoId'],
      procedure: json['procedure'],
      frequency: json['frequency'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class InstructionTreatmentModel {
  final String id;
  final String patientMongoId;
  final String patientId;
  final String doctorMongoId;
  final String doctorId;
  final String specialInstruction;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  InstructionTreatmentModel({
    required this.id,
    required this.patientMongoId,
    required this.patientId,
    required this.doctorMongoId,
    required this.doctorId,
    required this.specialInstruction,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory InstructionTreatmentModel.fromJson(Map<String, dynamic> json) {
    return InstructionTreatmentModel(
      id: json['_id'] ?? '',
      patientMongoId: json['patientMongoId'] ?? '',
      patientId: json['patientId'] ?? '',
      doctorMongoId: json['doctorMongoId'] ?? '',
      doctorId: json['doctorId'] ?? '',
      specialInstruction: json['specialInstruction'] ?? '',
      status: json['status'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'patientMongoId': patientMongoId,
      'patientId': patientId,
      'doctorMongoId': doctorMongoId,
      'doctorId': doctorId,
      'specialInstruction': specialInstruction,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
