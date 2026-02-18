class PrescriptionModel {
  final String id;
  final String patientMongoId;
  final String patientId;
  final String comment;
  final int durationInDays;
  final MedicineModel? medicine; // 👈 nullable
  final List<DosageSchedule> dosageSchedule;
  final String prescribedBy;
  final String prescriptionStatus;
  final DateTime createdAt;
  final DateTime updatedAt;

  PrescriptionModel({
    required this.id,
    required this.patientMongoId,
    required this.patientId,
    required this.comment,
    required this.durationInDays,
    required this.medicine,
    required this.dosageSchedule,
    required this.prescribedBy,
    required this.prescriptionStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PrescriptionModel.fromJson(Map<String, dynamic> json) {
    return PrescriptionModel(
      id: json['_id'],
      patientMongoId: json['patientMongoId'],
      patientId: json['patientId'],
      comment: json['comment'] ?? "",
      durationInDays: json['durationInDays'] ?? 0,

      /// medicineMongoId can be null or object
      medicine: json['medicineMongoId'] != null
          ? MedicineModel.fromJson(json['medicineMongoId'])
          : null,

      dosageSchedule: (json['dosageSchedule'] as List? ?? [])
          .map((e) => DosageSchedule.fromJson(e))
          .toList(),

      prescribedBy: json['prescribedBy'],
      prescriptionStatus: json['prescriptionStatus'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class MedicineModel {
  final String id;
  final String name;
  final String? category;

  MedicineModel({
    required this.id,
    required this.name,
    this.category,
  });

  factory MedicineModel.fromJson(Map<String, dynamic> json) {
    return MedicineModel(
      id: json['_id'],
      name: json['name'],
      category: json['category'] ?? json['medicineCategory'] ?? json['drugCategory'] ?? null,
    );
  }
}

class DosageSchedule {
  final String id;
  final String timeOfDay;
  final String mealRelation;
  final int quantity;

  DosageSchedule({
    required this.id,
    required this.timeOfDay,
    required this.mealRelation,
    required this.quantity,
  });

  factory DosageSchedule.fromJson(Map<String, dynamic> json) {
    return DosageSchedule(
      id: json['_id'],
      timeOfDay: json['timeOfDay'],
      mealRelation: json['mealRelation'],
      quantity: json['quantity'],
    );
  }
}
