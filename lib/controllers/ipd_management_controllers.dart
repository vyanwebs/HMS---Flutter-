import 'package:get/get.dart';
import 'package:hms/models/avatar_model.dart';

import '../services/api_service.dart';
import '../services/apis.dart';

class IpdManagementControllers extends GetxController {

  /// ================= STATE =================

  final isLoading = false.obs;
  final patients = <PatientModel>[].obs;
  final errorMessage = "".obs;

  // ================== Stat Cards ==============

  // total patients
  int get totalPatients => patients.length;

  // stable patients
  int get stableCount => patients.where((p) => p.healthCondition.toLowerCase() == "stable").length;

  // improving patients
  int get improvingCount => patients.where((p) => p.healthCondition.toLowerCase() == "improving").length;

  // critical patients
  int get criticalCount => patients.where((p) => p.healthCondition.toLowerCase() == "critical").length;

  final selectedPatient = Rxn<PatientModel>();

  void selectPatient(PatientModel patient) {
    selectedPatient.value = patient;
  }

  /// ================= INIT =================

  @override
  void onInit() {
    super.onInit();
    fetchIpdPatients();
  }

  /// ================= FETCH PATIENTS =================

  Future<void> fetchIpdPatients() async {
    try {
      isLoading.value = true;
      errorMessage.value = "";

      final helper = NetworkHelper(
        url: getIpdPatientsApi, 
      );

      final response = await helper.get(auth: true);

      if (response['success'] == true) {
        final List data = response['data'] ?? [];

        final parsed = data.map((e) => PatientModel.fromJson(e)).toList();

        patients.assignAll(parsed);
        if (patients.isNotEmpty) {
          selectedPatient.value = patients.first;
        }
      } else {
        errorMessage.value = response['message'] ?? "Failed to load patients";
      }

    } catch (e) {
      errorMessage.value = "Something went wrong";
      print("IPD fetch error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// ================= REFRESH =================

  Future<void> refreshPatients() async {
    await fetchIpdPatients();
  }
}

class PatientModel {
  final String id;
  final String patientId;
  final String name;
  final int age;
  final String gender;
  final String email;
  final String mobileNumber;
  final String address;
  final String bloodGroup;

  /// admission related
  final String admissionType;
  final String admissionStatus;
  final String admissionCode;
  final String healthCondition;

  final int weight;
  final bool isTodayConfirmed;
  final String timeAgo;

  final DateTime? registeredAt;
  final DateTime? updatedAt;

  /// optional
  final String? doctorAssigned;
  final String? wardType;
  final PatientAvatarModel avatar;

  final String? bedAssign;
  final bool hasVitals;

  PatientModel({
    required this.id,
    required this.patientId,
    required this.name,
    required this.age,
    required this.gender,
    required this.email,
    required this.mobileNumber,
    required this.address,
    required this.bloodGroup,
    required this.admissionType,
    required this.admissionStatus,
    required this.admissionCode,
    required this.healthCondition,
    required this.weight,
    required this.isTodayConfirmed,
    required this.timeAgo,
    required this.avatar,
    this.registeredAt,
    this.updatedAt,
    this.doctorAssigned,
    this.wardType,
    this.bedAssign,
    this.hasVitals = false,
  });

  // ================= FROM JSON =================

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    final admission = json['currentAdmissionId'];
    Map<String, dynamic>? admissionMap =
        admission is Map<String, dynamic> ? admission : null;

    return PatientModel(
      id: json['_id'] ?? '',
      patientId: json['patientId'] ?? '',
      name: json['name'] ?? '',
      age: json['age'] ?? 0,
      gender: json['gender'] ?? '',
      email: json['email'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      address: json['address'] ?? '',
      bloodGroup: json['bloodGroup'] ?? '',

      admissionType:
          admissionMap?['admissionType'] ?? json['currentAdmissionType'] ?? '',

      admissionStatus:
          admissionMap?['admissionStatus'] ??
          json['currentAdmissionStatus'] ??
          '',

      admissionCode:
          admissionMap?['admissionCode'] ??
          json['currentAdmissionCode']?.toString() ??
          '',

      healthCondition:
          admissionMap?['healthCondition'] ??
          json['currentHealthCondition'] ??
          '',

      weight: json['weight'] ?? 0,
      isTodayConfirmed: json['isTodayConfirmed'] ?? false,
      timeAgo: json['timeAgo'] ?? '',

      registeredAt: _parseDate(json['registeredAt']),
      updatedAt: _parseDate(json['updatedAt']),

      doctorAssigned:
          admissionMap?['doctor']?['staffId'] ??
          json['currentDoctorAssigned'],

      wardType: json['currentWardType'],

      /// FIXED avatar parsing
      avatar: json['avatar'] is Map<String, dynamic>
          ? PatientAvatarModel.fromJson(json['avatar'])
          : PatientAvatarModel.empty(),

      bedAssign: json['currentBedAssign'],
      hasVitals: json['currentVitalsReport'] != null,
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

  // ================= COPY =================

  PatientModel copyWith({
    String? name,
    String? healthCondition,
    PatientAvatarModel? avatar,
  }) {
    return PatientModel(
      id: id,
      patientId: patientId,
      name: name ?? this.name,
      age: age,
      gender: gender,
      email: email,
      mobileNumber: mobileNumber,
      address: address,
      bloodGroup: bloodGroup,
      admissionType: admissionType,
      admissionStatus: admissionStatus,
      admissionCode: admissionCode,
      healthCondition: healthCondition ?? this.healthCondition,
      weight: weight,
      isTodayConfirmed: isTodayConfirmed,
      timeAgo: timeAgo,
      registeredAt: registeredAt,
      updatedAt: updatedAt,
      doctorAssigned: doctorAssigned,
      wardType: wardType,
      avatar: avatar ?? this.avatar,
      bedAssign: bedAssign,
      hasVitals: hasVitals,
    );
  }
}
