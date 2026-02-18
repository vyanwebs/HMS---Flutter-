class IpdManagementDetailsModel {
  final PatientDetails patient;
  final AdmissionDetails admission;
  final DiagnosisDetails? diagnosis;
  final VitalsDetails? vitals;
  final TreatmentMedication? medication;
  final TreatmentIVFluid? ivFluid;
  final TreatmentProcedure? procedure;
  final TreatmentInstruction? instruction;

  IpdManagementDetailsModel({
    required this.patient,
    required this.admission,
    this.diagnosis,
    this.vitals,
    this.medication,
    this.ivFluid,
    this.procedure,
    this.instruction,
  });

  factory IpdManagementDetailsModel.fromJson(Map<String, dynamic> json) {
    return IpdManagementDetailsModel(
      patient: PatientDetails.fromJson(json['patient'] ?? {}),
      admission: AdmissionDetails.fromJson(json['admissionDetails'] ?? {}),
      diagnosis: json['diagnosisDetails'] != null
          ? DiagnosisDetails.fromJson(json['diagnosisDetails'])
          : null,
      vitals: json['vitalsDetails'] != null
          ? VitalsDetails.fromJson(json['vitalsDetails'])
          : null,
      medication: json['treatmentMedications'] != null
          ? TreatmentMedication.fromJson(json['treatmentMedications'])
          : null,
      ivFluid: json['treatmentIVFluids'] != null
          ? TreatmentIVFluid.fromJson(json['treatmentIVFluids'])
          : null,
      procedure: json['treatmentProcedure'] != null
          ? TreatmentProcedure.fromJson(json['treatmentProcedure'])
          : null,
      instruction: json['treatmentInstructions'] != null
          ? TreatmentInstruction.fromJson(json['treatmentInstructions'])
          : null,
    );
  }
}

class PatientDetails {
  final String id;
  final String patientId;
  final String name;
  final String age;
  final String weight;
  final String gender;
  final String address;
  final String bloodGroup;
  final String bedAssign;
  final String wardType;
  final String healthCondition;
  final String email;
  final String mobileNumber;
  final String guardianName;
  final String maritalStatus;
  final String occupation;
  final String education;
  final String nationality;
  final String language;
  final DateTime? registeredAt;
  final DateTime? updatedAt;

  PatientDetails({
    required this.id,
    required this.patientId,
    required this.name,
    required this.age,
    required this.gender,
    required this.address,
    required this.bloodGroup,
    required this.bedAssign,
    required this.wardType,
    required this.healthCondition,
    required this.email,
    required this.mobileNumber,
    required this.guardianName,
    required this.maritalStatus,
    required this.occupation,
    required this.education,
    required this.nationality,
    required this.language,
    required this.weight,
    this.registeredAt,
    this.updatedAt,
  });

  factory PatientDetails.fromJson(Map<String, dynamic> json) {
    return PatientDetails(
      id: json['_id'] ?? '',
      patientId: json['patientId'] ?? '',
      name: json['name'] ?? '',
      gender: json['gender'] ?? '',
      address: json['address'] ?? '',
      bloodGroup: json['bloodGroup'] ?? '',
      bedAssign: json['currentBedAssign'] ?? '',
      wardType: json['currentWardType'] ?? '',
      healthCondition: json['currentHealthCondition'] ?? '',
      email: json['email'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      guardianName: json['guardianName'] ?? '',
      maritalStatus: json['maritalStatus'] ?? '',
      occupation: json['occupation'] ?? '',
      education: json['education'] ?? '',
      nationality: json['nationality'] ?? '',
      language: json['language'] ?? '',
      age: json['age']?.toString() ?? '0',
      weight: json['weight']?.toString() ?? '0',

      registeredAt: _parseDate(json['registeredAt']),
      updatedAt: _parseDate(json['updatedAt']),
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    try {
      return DateTime.parse(value);
    } catch (_) {
      return null;
    }
  }
}

class AdmissionDetails {
  final String admissionCode;
  final String admissionStatus;
  final String admissionType;
  final String doctorId;
  final String doctorStaffId;
  final String ipdDepositAmount;
  final bool needsUpdate;
  final DateTime? admittedAt;
  final DateTime? dischargedAt;

  AdmissionDetails({
    required this.admissionCode,
    required this.admissionStatus,
    required this.admissionType,
    required this.doctorId,
    required this.doctorStaffId,
    required this.ipdDepositAmount,
    required this.needsUpdate,
    this.admittedAt,
    this.dischargedAt,
  });

  factory AdmissionDetails.fromJson(Map<String, dynamic> json) {
    return AdmissionDetails(
      admissionCode: json['admissionCode'] ?? '',
      admissionStatus: json['admissionStatus'] ?? '',
      admissionType: json['admissionType'] ?? '',
      doctorId: json['doctor']?['id'] ?? '',
      doctorStaffId: json['doctor']?['staffId'] ?? '',
      ipdDepositAmount: json['ipdDepositAmount']?.toString() ?? "0.0",
      needsUpdate: json['needsUpdate'] ?? false,
      admittedAt: _parseDate(json['admittedAt']),
      dischargedAt: _parseDate(json['dischargedAt']),
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    try {
      return DateTime.parse(value);
    } catch (_) {
      return null;
    }
  }
}

class DiagnosisDetails {
  final List<String> diagnoses;

  DiagnosisDetails({required this.diagnoses});

  factory DiagnosisDetails.fromJson(Map<String, dynamic> json) {
    final list = (json['diagnoses'] as List?) ?? [];

    return DiagnosisDetails(
      diagnoses: list.map((e) => e['name'].toString()).toList(),
    );
  }
}

class VitalsDetails {
  final String bp;
  final int pulse;
  final String temperature;
  final int spo2;
  final DateTime? recordedAt;
  final String recordedByRole;
  final int respirationRate;

  VitalsDetails({
    required this.bp,
    required this.pulse,
    required this.temperature,
    required this.spo2,
    this.recordedAt,
    required this.recordedByRole,
    required this.respirationRate,
  });

  factory VitalsDetails.fromJson(Map<String, dynamic> json) {
    return VitalsDetails(
      bp: json['bp'] ?? '',
      pulse: json['pulse'] ?? 0,
      temperature: json['temperature']?.toString() ?? "0",
      spo2: json['spo2'] ?? 0,
      recordedAt: _parseDate(json['recordedAt']),
      recordedByRole: json['recordedBy']?['role'] ?? '',
      respirationRate: json['respirationRate'] ?? 0,
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    try {
      return DateTime.parse(value);
    } catch (_) {
      return null;
    }
  }
}


class TreatmentMedication {
  final String name;
  final String type;
  final String mealRelation;
  final String status;

  TreatmentMedication({
    required this.name,
    required this.type,
    required this.mealRelation,
    required this.status,
  });

  factory TreatmentMedication.fromJson(Map<String, dynamic> json) {
    return TreatmentMedication(
      name: json['medicationName'] ?? '',
      type: json['medicationType'] ?? '',
      mealRelation: json['mealRelation'] ?? '',
      status: json['status'] ?? '',
    );
  }
}

class TreatmentIVFluid {
  final String name;
  final String quantity;
  final String duration;
  final String status;

  TreatmentIVFluid({
    required this.name,
    required this.quantity,
    required this.duration,
    required this.status,
  });

  factory TreatmentIVFluid.fromJson(Map<String, dynamic> json) {
    return TreatmentIVFluid(
      name: json['ivFluidName'] ?? '',
      quantity: json['quantity'] ?? '',
      duration: json['duration'] ?? '',
      status: json['status'] ?? '',
    );
  }
}

class TreatmentProcedure {
  final String procedure;
  final String frequency;
  final String status;

  TreatmentProcedure({
    required this.procedure,
    required this.frequency,
    required this.status,
  });

  factory TreatmentProcedure.fromJson(Map<String, dynamic> json) {
    return TreatmentProcedure(
      procedure: json['procedure'] ?? '',
      frequency: json['frequency'] ?? '',
      status: json['status'] ?? '',
    );
  }
}

class TreatmentInstruction {
  final String instruction;
  final String status;

  TreatmentInstruction({
    required this.instruction,
    required this.status,
  });

  factory TreatmentInstruction.fromJson(Map<String, dynamic> json) {
    return TreatmentInstruction(
      instruction: json['specialInstruction'] ?? '',
      status: json['status'] ?? '',
    );
  }
}
