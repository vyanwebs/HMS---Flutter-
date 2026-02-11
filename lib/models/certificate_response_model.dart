class CertificateResponse {
  final PatientDetails patientDetails;
  final CertificateDetails certificateDetails;
  final AdmissionInfo admissionInfo;

  CertificateResponse({
    required this.patientDetails,
    required this.certificateDetails,
    required this.admissionInfo,
  });

  factory CertificateResponse.fromJson(Map<String, dynamic> json) {
    return CertificateResponse(
      patientDetails: PatientDetails.fromJson(json['patientDetails']),
      certificateDetails: CertificateDetails.fromJson(json['certificateDetails']),
      admissionInfo: AdmissionInfo.fromJson(json['admissionInfo']),
    );
  }
}


class CertificateDetails {
  final String localDriveUrl;
  final String googleDriveUrl;
  final String certificateName;
  final String diagnosis;
  final String medicalLeaveStartDate;
  final String expectedRestDuration;
  final String expectedReturnDate;
  final String issueDate;
  final String doctorName;
  final String doctorDepartment;
  final String additionalNotes;
  final String certificateType;

  CertificateDetails({
    required this.localDriveUrl,
    required this.googleDriveUrl,
    required this.certificateName,
    required this.diagnosis,
    required this.medicalLeaveStartDate,
    required this.expectedRestDuration,
    required this.expectedReturnDate,
    required this.issueDate,
    required this.doctorName,
    required this.doctorDepartment,
    required this.additionalNotes,
    required this.certificateType,
  });

  factory CertificateDetails.fromJson(Map<String, dynamic> json) {
    return CertificateDetails(
      localDriveUrl: json['localDriveUrl'],
      googleDriveUrl: json['googleDriveUrl'],
      certificateName: json['certificateName'],
      diagnosis: json['diagnosis'],
      medicalLeaveStartDate: json['medicalLeaveStartDate'],
      expectedRestDuration: json['expectedRestDuration'],
      expectedReturnDate: json['expectedReturnDate'],
      issueDate: json['issueDate'],
      doctorName: json['doctorName'],
      doctorDepartment: json['doctorDepartment'],
      additionalNotes: json['additionalNotes'],
      certificateType: json['certificateType'],
    );
  }
}

class PatientDetails {
  final String name;
  final String patientId;
  final int age;
  final String gender;

  PatientDetails({
    required this.name,
    required this.patientId,
    required this.age,
    required this.gender,
  });

  factory PatientDetails.fromJson(Map<String, dynamic> json) {
    return PatientDetails(
      name: json['name'],
      patientId: json['patientId'],
      age: json['age'],
      gender: json['gender'],
    );
  }
}

class AdmissionInfo {
  final String admissionCode;
  final String admissionId;
  final String admissionDate;
  final String reasonForAdmission;

  AdmissionInfo({
    required this.admissionCode,
    required this.admissionId,
    required this.admissionDate,
    required this.reasonForAdmission,
  });

  factory AdmissionInfo.fromJson(Map<String, dynamic> json) {
    return AdmissionInfo(
      admissionCode: json['admissionCode'],
      admissionId: json['admissionId'],
      admissionDate: json['admissionDate'],
      reasonForAdmission: json['reasonForAdmission'],
    );
  }
}
