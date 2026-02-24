import 'package:get/get.dart';

import '../../models/patient_model.dart';
import '../../services/api_service.dart';
import '../../services/apis.dart';
import '../../utils/overlay.dart';
import '../../utils/snackbar.dart';

class PatientManagementController extends GetxController {

  /// ================= STATE =================
  final isLoading = false.obs;

  /// TAB
  final isAssignedTab = true.obs;

  /// ================= DATA =================
  final opdPatients = <PatientModel>[].obs;
  final patients = <PatientModel>[].obs;
  final ipdPatients = <PatientModel>[].obs;

  /// ================= STATS =================
  final totalPatients = 0.obs;
  final assignedPatients = 0.obs;
  final admittedPatients = 0.obs;

  /// ================= INIT =================
  @override
  void onInit() {
    super.onInit();
    _loadData();
  }

  Future<void> _loadData() async {
    isLoading.value = true;
    await fetchOPDPatients();
    await fetchIPDPatients();
    isLoading.value = false;
    _calculateStats();
    _applyFilter();
  }

  /// =====================================================
  /// FETCH OPD PATIENTS
  /// =====================================================
  Future<void> fetchOPDPatients() async {
    try {

      final helper = NetworkHelper(url: getAllOPDPatientsApi);
      final response = await helper.get(auth: true);

      if (response["success"] == true) {
        opdPatients.value =
            (response["data"] as List)
                .map((e) => PatientModel.fromJson(e))
                .toList();
      }

    } catch (e) {
      print(e);
    }
  }

  // ==================== FETCH ADMITTED PATIENTS ===============
  Future<void> fetchIPDPatients() async {
    try {
      isLoading.value = true;

      final helper = NetworkHelper(
        url: getAllIPDPatientsWithDiagnosisApi,
      );

      final response = await helper.get(auth: true);

      if (response["success"] == true) {
        final List list = response["data"];

        ipdPatients.value = list.map((e) => PatientModel.fromJson(e)).toList();
      }
    } catch (e) {
      print("IPD Fetch Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
  // ================== TRANSFER PATIENT =================
  Future<void> transferPatient({
    required String patientMongoId,
    required String doctorName,
    required String staffId,
    String? reason,
  }) async {
    try {

      /// 🔵 LOADER
      LoadingOverlayService.show(
        message: "Transferring patient...",
      );

      final helper = NetworkHelper(
        url: transferPatientToDoctorApi,
      );

      final response = await helper.postData(
        auth: true,
        body: {
          "patientMongoId": patientMongoId,
          "doctorName": doctorName,
          "staffId": staffId,
          "doctorTransferReason": reason ?? "",
        },
      );

      /// ✅ SUCCESS
      if (response["success"] == true) {

        AppSnackbar.show(
          title: "Success",
          message: "Patient transferred successfully",
          type: AppSnackType.success,
        );

        await fetchOPDPatients(); // ✅ refresh
      } else {

        AppSnackbar.show(
          title: "Transfer Failed",
          message: response["message"] ?? "Something went wrong",
          type: AppSnackType.error,
        );
      }

    } catch (e) {

      AppSnackbar.show(
        title: "Error",
        message: e.toString(),
        type: AppSnackType.error,
      );

    } finally {
      LoadingOverlayService.hide();
    }
  }

  /// =====================================================
  /// STATS
  /// =====================================================
  void _calculateStats() {

    totalPatients.value = opdPatients.length + ipdPatients.length;

    assignedPatients.value = opdPatients.length;

    admittedPatients.value = ipdPatients.length;
  }

  /// =====================================================
  /// TAB SWITCH
  /// =====================================================
  void changeTab(bool assigned) {
    isAssignedTab.value = assigned;
    _applyFilter();
  }

  void _applyFilter() {

    if (isAssignedTab.value) {

      /// Assigned Patients → OPD LIST
      patients.assignAll(opdPatients);

    } else {

      /// Admitted Patients → IPD LIST
      patients.assignAll(ipdPatients);
    }
  }

  /// =====================================================
  /// SEARCH
  /// =====================================================
  void searchPatients(String query) {

    final source = isAssignedTab.value ? opdPatients : ipdPatients;

    if (query.isEmpty) {
      _applyFilter();
      return;
    }

    patients.assignAll(
      source.where((p) =>
          p.name.toLowerCase().contains(query.toLowerCase()) ||
          p.patientId.toLowerCase().contains(query.toLowerCase()) ||
          p.mobileNumber.contains(query)),
    );
  }

  /// =====================================================
  /// STATUS HELPERS (FOR UI BADGES)
  /// =====================================================
  bool isPending(PatientModel p) => p.currentAdmissionStatus == "PENDING";

  bool isConfirmed(PatientModel p) => p.currentAdmissionStatus == "CONFIRMED";

  bool isAdmitted(PatientModel p) => p.currentAdmissionStatus == "ADMITTED";

  bool isEmergency(PatientModel p) => p.currentAdmissionPriorityLevel == "URGENT";

  /// =====================================================
  /// ACTIONS
  /// =====================================================
  
  Future<void> admitPatient({
    required String patientMongoId,
    required String ward,
    String? preferredBed,
    required String diagnosis,
    required String priority,
    String? notes,
  }) async {

    LoadingOverlayService.show(
      message: "Submitting admission request...",
    );

    try {

      final helper = NetworkHelper(url: "");

      final response = await helper.postData(
        auth: true,
        body: {
          "patientMongoId": patientMongoId,
          "ward": ward,
          "preferredBed": preferredBed ?? "",
          "diagnosis": diagnosis,
          "priority": priority,
          "notes": notes ?? "",
        },
      );

      if (response["success"] == true) {
        AppSnackbar.show(
          title: "Success",
          message: "Admission request created",
          type: AppSnackType.success,
        );

        await fetchOPDPatients();
        await fetchIPDPatients();
      }

    } finally {
      LoadingOverlayService.hide();
    }
  }
}